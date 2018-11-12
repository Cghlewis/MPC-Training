Lecture 2 11/16/18
================

Tidyverse
---------

For these lectures I tried to use packages that were in the `tidyverse` (a combination of packages used for data science).That doesn't mean these are the best packages or easiest (there are many other options).

Core `tidyverse` packages include: (`dply`, `ggplot2`, `tidyr`, `readr`, `purr`, `tibble`, `stringr`, `forcats`)

Read about `tidyverse` here: <https://www.tidyverse.org/>

Install Tidyverse and other relevant packages
---------------------------------------------

``` r
install.packages("tidyverse")
install.packages("haven")
install.packages("readxl")
install.packages("labelled")
```

Call Tidyverse
--------------

We will use this package throughout our lecture (mainly `dplyr`).

``` r
library(tidyverse)
```

1) Load in our data
-------------------

First set your working directory.

``` r
setwd("W:/Projects/MPC-All-Projects/MPC-Team/Data Entry Training/Syntax Training/Syntax and Data")
```

### For SPSS

Although `haven` is part of the `tidyverse`, it is not part of the core `tidyverse` package so it will need to be loaded.

``` r
library(haven)

SPSS <- read_sav("Qualtrics Teacher Rating.sav")

View(SPSS)
str(SPSS)
```

### For Excel

Although `readxl` is part of the `tidyverse`, it is not part of the core `tidyverse` package so it will need to be loaded

``` r
library(readxl)

XL<-read_excel("Qualtrics Teacher Rating minus labels.xlsx")

View(XL)
str(XL)
```

2. Explore Number of Cases
--------------------------

``` r
dim(XL)
```

    ## [1] 10 89

### Sort Data to see who shouldn't be in the file

``` r
#arrange comes from dplyr in tidyverse
XL<-arrange(XL, Q2_2_TEXT, Q2_1_TEXT) 
View(XL)
```

3. Delete unncessary variables
------------------------------

``` r
#select comes from dplyr in tidyverse
XL2<-select (XL, -(V1:V7),-(V10:Q1), -Q2, -(Q8:LocationAccuracy))
View(XL2)
```

4. Explore variables
--------------------

``` r
summary(XL2)  
```

5. Rename Variables
-------------------

``` r
#rename comes from dplyr in tidyverse
XL2<-rename(XL2, Student_First_Name=Q2_1_TEXT, Student_Last_Name=Q2_2_TEXT)

XL2<-rename(XL2, StartDateT1=V8, EndDateT1=V9, TGenderT1=Q3)

XL2<-rename(XL2,toca1T1=Q5_1,toca4T1=Q5_4,toca9T1=Q5_9,toca13T1=Q5_13,toca15T1=Q5_15, toca23T1=Q17_7,toca25T1=Q17_9)
```

6. Variable Labels
------------------

Will first need to call `labelled`, which is not part of the `tidyverse`

``` r
library(labelled) 

var_label(XL2$toca1T1)<-"Concentrates"
var_label(XL2) <- list(toca4T1 = "Pays Attention", toca9T1 = "Works Hard")
var_label(XL2) <- list(toca13T1 = "Stays on Task", toca15T1 = "Easily Distracted")
var_label(XL2) <- list(toca23T1 = "Completes Assignments", toca25T1 = "Learns up to Ability")

str(XL2)
View(XL2)
```

7. Add new variables
--------------------

``` r
XL2$Int<-NaN
XL2$Cohort<-3

names(XL2)
View(XL2)

#Add variable labels

var_label(XL2) <- list(Cohort = "Study Wave", Int = "Treatment Status")
```

8. Add value labels
-------------------

Uses labelled package

``` r
val_labels(XL2$Cohort)

XL2$Cohort<-labelled (XL2$Cohort, c("study year 1"=1, "study year 2"=2,
                                        "study year 3"=3, "study year 4"=4))

val_labels(XL2$Cohort)
```

9. Recode TOCA Concentration variables
--------------------------------------

``` r
#What are current values

table(XL2$toca1T1, useNA='always')
table(XL2$toca4T1, useNA='always')
table(XL2$toca9T1, useNA='always')
table(XL2$toca13T1, useNA='always')
table(XL2$toca15T1, useNA='always')
table(XL2$toca23T1, useNA='always')
table(XL2$toca25T1, useNA='always')

#Run descriptives before you recode

summary(XL2)

#Recode

#This method will only work if you have at least one value at the max value

XL2$toca1T1R<-((max(XL2$toca1T1)+1)-XL2$toca1T1)

#Check to see if it worked

table(XL2$toca1T1R, XL2$toca1T1)

#If variables don't reach max, will need to recode this way
#Uses dplyr

XL2$toca4T1R<-recode(XL2$toca4T1, '1'=6,'2'=5,'3'=4,'4'=3,'5'=2,'6'=1)

#Check again
table(XL2$toca4T1R, XL2$toca4T1)

#We need to recode the remaining toca concentration variables

XL2$toca9T1R<-((max(XL2$toca9T1)+1)-XL2$toca9T1)

XL2$toca13T1R<-((max(XL2$toca13T1)+1)-XL2$toca13T1)

XL2$toca23T1R<-((max(XL2$toca23T1)+1)-XL2$toca23T1)

XL2$toca25T1R<-((max(XL2$toca25T1)+1)-XL2$toca25T1)

#Check remaining recodes
table(XL2$toca9T1R, XL2$toca9T1)
table(XL2$toca13T1R, XL2$toca13T1)
table(XL2$toca23T1R, XL2$toca23T1)
table(XL2$toca25T1R, XL2$toca25T1)


#Add new value labels

XL2$toca1T1R<-labelled (XL2$toca1T1R, c("Almost Always"=1, "Very Often"=2, "Often"=3, "Sometimes"=4, "Rarely"=5, "Never"=6))

XL2$toca4T1R<-labelled (XL2$toca4T1R, c("Almost Always"=1, "Very Often"=2, "Often"=3, "Sometimes"=4, "Rarely"=5, "Never"=6))

XL2$toca9T1R<-labelled (XL2$toca9T1R, c("Almost Always"=1, "Very Often"=2, "Often"=3, "Sometimes"=4, "Rarely"=5, "Never"=6))

XL2$toca13T1R<-labelled (XL2$toca13T1R, c("Almost Always"=1, "Very Often"=2,"Often"=3, "Sometimes"=4, "Rarely"=5,"Never"=6))

XL2$toca23T1R<-labelled (XL2$toca23T1R, c("Almost Always"=1, "Very Often"=2, "Often"=3, "Sometimes"=4,"Rarely"=5,"Never"=6))

XL2$toca25T1R<-labelled (XL2$toca25T1R, c("Almost Always"=1, "Very Often"=2,"Often"=3, "Sometimes"=4, "Rarely"=5,"Never"=6))

#And we need to add labels to the variable we didn't recode

XL2$toca15T1<-labelled (XL2$toca15T1, c("Never"=1, "Rarely"=2, "Sometimes"=3,  "Often"=4,"Very Often"=5,"Almost Always"=6))

# Lets see if it looks good (you would want to check ALL recoded variables in reality)

val_labels(XL2$toca15T1)

val_labels(XL2$toca25T1R)
```

10. Sum Scores
--------------

``` r
#This method will not create a sum score if missing data (which is usually what we want)

XL2$tocaconcentT1s <- rowSums(select(XL2, toca1T1R, toca4T1R, toca9T1R, toca13T1R,
                                           toca15T1, toca23T1R, toca25T1R), na.rm = F)

#OR

#XL2$tocaconcentT1s2<- XL2$toca1T1R + XL2$toca4T1R + XL2$toca9T1R + XL2$toca13T1R + XL2$toca15T1 + XL2$toca23T1R + XL2$toca25T1R

#Now create a mean

XL2$tocaconcentT1m <- rowMeans(select(XL2, toca1T1R, toca4T1R, toca9T1R, toca13T1R,
                                           toca15T1, toca23T1R, toca25T1R), na.rm = F)

#OR

#XL2$tocaconcentT1m2<-XL2$tocaconcentT1s/7

#If you want an average even with the missing values

XL2$tocaconcentT1m_withmiss <- rowMeans(select(XL2, toca1T1R, toca4T1R, toca9T1R, toca13T1R,
                                                   toca15T1, toca23T1R, toca25T1R), na.rm = T)

#Add variable labels to new sum/mean variables

var_label(XL2) <- list(tocaconcentrateT1s = "TOCA Concentrate sum", tocaconcentrateT1m = "TOCA Concentrate mean")

#Check the label
str(XL2$tocaconcentrateT1m)

#Check descriptives for new variables

summary(XL2$tocaconcentT1s)
summary(XL2$tocaconcentT1m)
```

11. Add missing values for all variables
----------------------------------------

In our case NAs are already assigned to missing But if you needed to assign NA to a missing value from say SPSS here is an example:

``` r
XL2$toca1T1[XL2$toca1T1==999]<--NA
```

12. Run descriptives on all variables to check for errors
---------------------------------------------------------

``` r
summary(XL2)
```
