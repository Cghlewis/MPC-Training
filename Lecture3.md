Lecture 3 12/7/18
================

Appending, Merging, and Removing Duplicates
===========================================

Many times when we collect data through qualtrics, our teachers all get separate links to surveys where they complete ratings on their students. Separate links mean separate downloaded files that all need to be brought together. This means all teacher files need to first be appended (stacked on top of each other) and then that combined file needs to be merged with a file that has Student ID in it so we can remove student names. Last, occasionally a teacher may accidentally complete a student's rating twice, or may start a student rating, not finish it and then start a new survey. So we need to remove duplicate surveys in our data. So let's give this a try.

### Install Tidyverse and other relevant packages

``` r
install.packages("tidyverse")
install.packages("readxl")
```

### Call the packages we will use

``` r
library(tidyverse)
library(readxl)
```

(1) Load in our data
--------------------

``` r
setwd("W:/Projects/MPC-All-Projects/MPC-Team/Data Entry Training/Syntax Training/Syntax and Data")

XL202<-read_excel("Qualtrics Teacher Rating Teacher 202.xlsx")

head(XL202)
glimpse(XL202)
```

(2) Append our data
-------------------

Before we do any manipulations to our data, we want to append all of our data together. This way we can do all manipulation at once, rather than to each dataset separately. In our hypothetical example, we only have 3 teachers and we need to append all 3 datasets. So we need to load in the other 2 datasets.

``` r
XL203<-read_excel("Qualtrics Teacher Rating Teacher 203.xlsx")
XL204<-read_excel("Qualtrics Teacher Rating Teacher 204.xlsx")
```

Then we can append.

``` r
XL<- rbind(XL202, XL203, XL204)
View(XL)
```

(3) Delete unncessary variables
-------------------------------

``` r
#select comes from dplyr in tidyverse
XL2<-select (XL, -(V1:V7),-(Q1), -Q2, -(Q8:LocationAccuracy))
View(XL2)
dim(XL)
```

(4) Explore variables
---------------------

``` r
summary(XL2)  
```

(5) Rename variables that we are going to use for merging
---------------------------------------------------------

``` r
#rename comes from dplyr in tidyverse
XL2<-rename(XL2, FirstName=Q2_1_TEXT, LastName=Q2_2_TEXT)
```

(6) Merge in Student ID
-----------------------

First read in our Student ID file.

``` r
StudID<-read_excel("StudentID.xlsx")
glimpse(StudID)
View(StudID)
```

Notice how "Van wie"" is spelled with a lower case w and has a space between van and wie. And the last name McCall is spelled with an upper case second C while in the teacher rating dataset it is spelled with two lower case Cs. This happens all the time. Files won't merge if the names are spelled or formatted differently so we need to change all letters to either upper or lower and remove spaces.

First we will make all of the names in both of our dataframes upper case.

``` r
StudID$FirstName<-toupper(StudID$FirstName)
StudID$LastName<-toupper(StudID$LastName)

head(StudID)

XL2$FirstName<-toupper(XL2$FirstName)
XL2$LastName<-toupper(XL2$LastName)

head(XL2)
```

Next we need to remove the space in Van Wie using the `stringr` package from the `tidyverse`.

``` r
StudID$LastName<-str_replace(StudID$LastName, " ", "")
View(XL2)
```

It's finally time to merge! NOTE: if names are not spelled correctly, the ones spelled incorrectly will not merge. There are ways to try to deal with this, but it is more complicated. For now, try to make sure the spelling is the same between datasets.

``` r
Merged<-merge(XL2,StudID,by=c("LastName", "FirstName"), all=TRUE)
#we add "all=true"" b/c we want an outer join, we want Madison even though she isn't in the rating file
View(Merged)
dim(Merged)
```

You'll notice we have person in our merged data with no data, Madison, which means she is in the study but we are missing her data. You would want to check tracking to see why we are missing data for that student (did the teacher forget to complete a survey on that student, did the student move, etc.).

(7) Identify Duplicates
-----------------------

First sort your data and then have R tell us which lines the duplicates are on.

``` r
#arrange comes from dplyr in the tidyverse
Merged<-arrange(Merged, StudentID) 
View(Merged)

#This shows which line the non-primary duplicates are on
which(duplicated(Merged$StudentID))
```

This tells us our duplicates are on rows 2 and 10. But we don't necessarily want duplicates dropped just based on order. We want a) complete cases and b) if both duplicates are complete cases, then we want the most recent. So looking at our data, we actually want to drop row 1 and row 10.

``` r
Mergednew<-Merged[-c(1,10),]
View(Mergednew)
```

If we had thousands of students and it was too difficult to do this by sight, we could be more methodical. We could first drop duplicates that are incomplete based on variable V10 which is 1 if the survey is finished and 0 if incomplete. Then sort our data based on StudentID and descending Survey End Date (V9). Then drop duplicates knowing that the second duplicate is the one removed so earlier surveys would be dropped rather than newer surveys.

``` r
Mergednew<-Merged%>%filter(V10>0)%>%arrange(StudentID, desc(V9))%>%distinct(StudentID, .keep_all=TRUE)
```

(8) Delete student name for security
------------------------------------

All student names in this example are fake but in reality, student names must be removed to protect confidentiality.

``` r
Mergednew$FirstName<-NULL
Mergednew$LastName<-NULL
```
