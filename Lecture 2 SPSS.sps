* Encoding: UTF-8.

*Use asterisk to make comments

**1. Load in file

**Get SPSS file

GET FILE='W:\Projects\MPC-All-Projects\MPC-Team\Data Entry Training\Syntax Training\Syntax and Data\Qualtrics Teacher Rating.sav'. 

**Get Excel file

GET DATA 
/TYPE=XLSX 
/FILE='W:\Projects\MPC-All-Projects\MPC-Team\Data Entry Training\Syntax Training\Syntax and Data\Qualtrics Teacher Rating.xlsx'
/READNAMES=ON 
/DATATYPEMIN PERCENTAGE=75.0.

*If using the excel file then you need to delete the first row of data

SELECT IF (Q1=1). 
EXECUTE.


**2. Explore number of cases

***Exploring the data

**Number of cases

FREQUENCIES VARIABLES=Q1 
  /FORMAT=LIMIT(5).


*Sort cases by student name

SORT CASES BY Q2_2_TEXT Q2_1_TEXT. 


*If we were supposed to have 12 observations we would need to go back and figure out who is missing
*If we were supposed to have 8, we need to figure out who isn't supposed to be in there
    *Checking for duplicates, go over later (like in this case there is an extra Crystal Lewis we would need to delete one)
    *Checking against a roster to see who isn't in the study
*In the case of SCSL and NIJ, the surveys are anonymous so we don't know if we are missing anyone

**3. Delete unncessary variables

* Delete unncessary variables added by qualtrics.

DELETE VARIABLES V1 V2 V3 V4 V5 V6 V7 V10 Q1 Q8 Q2 LocationLatitude LocationLongitude LocationAccuracy.


**4. Explore variables

*Explore variables

FREQUENCIES VARIABLES=Q3 Q5_1 Q5_4 Q5_9 Q5_13 Q5_15 Q17_7 Q17_9.


**5. Rename variables

*Rename variables (T1 is because we are saying this is Time Period 1)
**Note: You can rename these variables in Qualtrics on the back end so that when you download them you only have to add a T# instead of renaming 
**(easier to keep track of and less likely to make errors in renaming)

RENAME VARIABLES (Q2_1_TEXT Q2_2_TEXT = Student_First_Name Student_Last_Name).

RENAME VARIABLES (V8 V9 Q3 = StartDateT1 EndDateT1 TGenderT1).

RENAME VARIABLES Q5_1=toca1T1 Q5_4=toca4T1 Q5_9=toca9T1 Q5_13=toca13T1  Q5_15=toca15T1 Q17_7=toca23T1 Q17_9=toca25T1.


**6. Add variable labels

*Assign variable labels to TOCA Concentration variables.

variable labels toca1T1 'TOCA - concentrates'
/toca4T1 'TOCA - pays attention'
/toca9T1 'TOCA - works hard'
/toca13T1 'TOCA - stays on task'
/toca15T1 'TOCA - easily distracted'
/toca23T1 'TOCA - completes assignments'
/toca25T1 'TOCA - learns up to ability'.


**7. Create new variables for dataset

*Create new variables called int (for treatment status) and year (for study wave).

*The first variable I am just creating with no data in it.

numeric Int (F8.0).

*The second variable I want to be filled with a value of 3.

COMPUTE Cohort=3.
EXECUTE.
FORMATS Cohort (F8.0).

*Add variable labels.

VARIABLE LABELS Int 'Treatment Status'
/Cohort 'Study Wave'.


**8. Add value labels to new created Int and Cohort

Value labels Int 0 'Control' 1 'Treatment' 
/Cohort 1 'study year 1' 2 'study year 2' 3 'study year 3' 4 'study year 4'.


**9. Recode TOCA Concentration Variables

**What do they currently look like?

FREQUENCIES toca1T1 toca4T1 toca9T1 toca13T1 toca15T1 toca23T1 toca25T1.

**Run descriptives on the variables you are going to recode

DESCRIPTIVES toca1T1 toca4T1 toca9T1 toca13T1  toca23T1 toca25T1.

**Then recode

recode toca1t1 toca4t1 toca9t1 toca13t1 toca23t1 toca25t1 (1=6)(2=5)(3=4)(4=3)(5=2)(6=1). 

    **We can do this since we account for it in documentation.  However, you may want to do the recode this way: 
    *recode toca1t1 toca4t1 toca9t1 toca13t1 toca23t1 toca25t1 (1=6)(2=5)(3=4)(4=3)(5=2)(6=1) into toca1Rt1 toca4Rt1 toca9Rt1 toca13Rt1 toca23Rt1 toca25Rt1.
    *EXECUTE.

**Check to see if it recoded

DESCRIPTIVES toca1T1 toca4T1 toca9T1 toca13T1  toca23T1 toca25T1.

***Add new value labels (super important).

value labels toca1t1 toca4t1 toca9t1 toca13t1 toca23t1 toca25t1 1 'Almost always' 2 'Very often' 3 'Often' 4 'Sometimes' 5 'Rarely' 6 'Never'.

**Check all frequencies again

FREQUENCIES toca1T1 toca4T1 toca9T1 toca13T1 toca15T1 toca23T1 toca25T1.


**10. Sum scores

**Compute the sum

compute tocaconcentT1s = toca1T1 + toca4T1 + toca9T1 + toca13T1 + toca15T1 + toca23T1 + toca25T1. 

**Compute the mean (we only want an average when a case has all data)

compute tocaconcentT1m = (tocaconcentT1s)/7.
execute.

    **If you want a mean even with missing data, then you can compute this way
    **Delete out the first toca1T1 for example purpose

    Compute tocaconcentT1m2= MEAN(toca1T1, toca4T1, toca9T1, toca13T1, toca15T1, toca23T1, toca25T1).
    Execute.

**add variable labels to new variables

variable labels tocaconcentT1s 'TOCA1 - concentration problems sum'
/tocaconcentT1m 'TOCA1 - concentration problems mean'.

*Check out the status of new variables

FREQUENCIES VARIABLES = tocaconcentT1s, tocaconcentT1m.
FREQUENCIES VARIABLES = tocaconcentT1m2.


**11.Add missing values for all variables

RECODE TGenderT1 to tocaconcentT1m2 (SYSMIS=-999). 
EXECUTE.
MISSING VALUES TGenderT1 to tocaconcentT1m2 (-999).


**12. Run descriptives to check for errors

FREQUENCIES TGenderT1 toca1T1 toca4T1 toca9T1 toca13T1 toca15T1 toca23T1 toca25T1.
DESCRIPTIVES tocaconcentT1s tocaconcentT1m tocaconcentT1m2.




