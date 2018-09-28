
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

SELECT IF (V10=1). 
EXECUTE.


**2. Explore number of cases

***Exploring the data

**Number of cases

FREQUENCIES VARIABLES=V1 
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

FREQUENCIES VARIABLES=Q3 Q4_1 Q5_1 Q5_2 Q5_3 Q5_4 Q5_5.


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

COMPUTE Year=3.
EXECUTE.
FORMATS Year (F8.0).

*Add variable labels.

VARIABLE LABELS Int 'Treatment Status'
/Year 'Study Wave'.









