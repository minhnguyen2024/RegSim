*Minh T. Nguyen
*Do Computer Science majors earn higher annual income than other majors?
*Submission in partial fulfillment of ECON385: Regression and Simulation
*Professor Barreto
*STATA Do-file

use "I:\22231-ECON385A\MINHNGUYEN_2024\PAPER\FINAL\Data\usa_00011.dta" 
*CLEANING DATA
*Step 1: omit INCWAGE less than $20,000
ssc install estout
drop if incwage < 20000

*Step 2: sort INCWAGE, smallest to largest
sort incwage

*VARIABLE RECODING and GENERATING 
*Recode DEGFIELD, generating categozied Major variables
gen CS = 0
replace CS = 1 if degfield == 21 | degfield2 == 21

gen NaturalScience = 0
replace NaturalScience = 1 if degfield == 11 | degfield == 13 | degfield == 36 |degfield == 37 | degfield == 50 | degfield == 61

gen SocialScience = 0
replace SocialScience = 1 if degfield == 15 |degfield == 19 |degfield == 23 |degfield == 26 |degfield == 29 |degfield == 32 |degfield == 33 |degfield == 34 |degfield == 35 |degfield == 48 |degfield == 49 |degfield == 52 |degfield == 54 |degfield == 55 |degfield == 64

gen Engineering = 0
replace Engineering = 1 if degfield == 14 | degfield == 20 |degfield == 24 |degfield == 25 |degfield == 38 |degfield == 51 |degfield == 56 |degfield == 57 |degfield == 59

gen Business = 0
replace Business = 1 if degfield == 62

gen Arts = 0
replace Arts = 1 if degfield == 22 |degfield == 58 |degfield == 60

gen OtherMajors = 0
replace OtherMajors = 1 if degfield == 40 |degfield == 41 |degfield == 53

gen NoDeg = 0
replace NoDeg = 1 if degfield == 0

*Recode DEGFIELD2
gen DoubleMajor = 0
replace DoubleMajor = 1 if degfield > 0 & degfield2 > 0

*Recode SEX
gen Male = 1
replace Male = 0 if sex == 2

*Recode RACE
gen White = 0
replace White = 1 if race == 1

*Recode HISPANIC 
gen Hispan = 1
replace Hispan = 0 if hispan == 0

*Recode EDUC
gen EducYears = 0 
replace EducYears = 0 if educd == 999
replace EducYears = 9 if educd <= 030
replace EducYears = 10 if educd == 040
replace EducYears = 11 if educd == 050
replace EducYears = 12 if educd >= 060 & educd <= 065
replace EducYears = 13 if educd == 070 | educd == 071
replace EducYears = 14 if educd >= 080 & educd <= 083
replace EducYears = 15 if educd == 090
replace EducYears = 16 if educd == 100 | educd == 101
replace EducYears = 17 if educd == 110
replace EducYears = 18 if educd >= 110 

*Create Experience
gen Exp = age - EducYears - 6

*PARAMETER TRANSFORMATION

*Experience and Experience Squared
gen Exp2 = Exp ^ 2
*Natural log transfromation of INCWAGE
gen lnINCWAGE = ln(incwage)


*SUMMARY STATISTICS
summarize CS Engineering NaturalScience SocialScience Business Arts OtherMajors NoDeg EducYears Exp
tabulate EducYears CS, summ(incwage)
tabulate CS Male, summ(incwage)
tabulate CS White, summ(incwage)

*REGRESSION MODELS
*Regress lnINCWAGE on CS only
eststo: reg lnINCWAGE CS [pw=perwt], robust

*Regress lnINCWAGE on Male and Majors (NoDeg as base case)
eststo: reg lnINCWAGE CS NaturalScience SocialScience Engineering Business Arts OtherMajors DoubleMajor EducYears Exp Exp2 [pw=perwt], robust

*Unrestricted model
eststo: reg lnINCWAGE CS NaturalScience SocialScience Engineering Business Arts OtherMajors DoubleMajor EducYears Exp Exp2 i.sex i.race i.hispan [pw=perwt], robust


//esttab using reg.rtf, se label r2

clear
