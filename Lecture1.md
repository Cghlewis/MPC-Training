Lecture 1 9/28/18
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

(1) Load in our data
--------------------

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

(2) Explore Number of Cases
---------------------------

``` r
dim(XL)
```

    ## [1] 10 89

Sort data to see who shouldn't be in the file

``` r
#arrange comes from dplyr in tidyverse
XL<-arrange(XL, Q2_2_TEXT, Q2_1_TEXT) 
View(XL)
```

(3) Delete unncessary variables
-------------------------------

``` r
#select comes from dplyr in tidyverse
XL2<-select (XL, -(V1:V7),-(V10:Q1), -Q2, -(Q8:LocationAccuracy))
View(XL2)
```

(4) Explore variables
---------------------

``` r
#select comes from dplyr in tidyverse
summary(XL2)  
```

(5) Rename Variables
--------------------

``` r
#rename comes from dplyr in tidyverse
XL2<-rename(XL2, Student_First_Name=Q2_1_TEXT, Student_Last_Name=Q2_2_TEXT)

XL2<-rename(XL2, StartDateT1=V8, EndDateT1=V9, TGenderT1=Q3)

XL2<-rename(XL2,toca1T1=Q5_1,toca4T1=Q5_4,toca9T1=Q5_9,toca13T1=Q5_13,toca15T1=Q5_15, toca23T1=Q17_7,toca25T1=Q17_9)
```

(6) Variable Labels
-------------------

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

(7) Add new variables
---------------------

``` r
XL2$Int<-NaN
XL2$Year<-3

names(XL2)
View(XL2)
```
