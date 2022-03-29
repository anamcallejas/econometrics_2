//* Authors: Callejas A.; Gohlami A.; Montealegre F.
//* Date: 30/03/2021
//* The latest version of this file along the entire folder structure is in
//* GitHub: https://github.com/anamcallejas/econometrics_2

//*#######################################################################
//* 0. Set working directory and log.
//*#######################################################################

clear all
set more off

*cd "C:\Users\amcal\Documentos\Clases\3-Econometrics 2\_problem_sets\_ps2"
cd "C:\Users\Felipe M\Dropbox\1_Personal\_maestria_unibo_(operacional)\8_econometrics_2\_problem_sets\_ps3"
*log using _log/log, replace

*ssc install ivreg2
*ssc install ranktest
*ssc install ivregress2
*ssc install estout, replace
use _data/group9.dta

//*=======================================================================
//* 1. Data mangling
//*=======================================================================

tab gender
gen female = .
replace female = 0 if gender == 1
replace female = 1 if gender == 2
tab female

tab year, generate (wave)
tab wave1
tab wave2
tab wave3
drop wave1


//*#######################################################################
//* Part 1
//*#######################################################################

//*=======================================================================
//* 1. OLS estimation
//*=======================================================================
//* ----- must-have regressors:
* income age female yedu mstat hstatus gali wave2 wave3
//* ----- Our choice regressors:
* phinact cjs

reg life_sat income age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs

//* ----- model is not the best:
//* y_hat has predicted values that go below/above the min/max range for y.

predict y_hat
summarize y_hat



//*#######################################################################
//* Part 2
//*#######################################################################

//*=======================================================================
//* 1. ML estimation
//*=======================================================================


//*=======================================================================
//* 2. Wald test and Likelihood ratio test
//*=======================================================================

//*=======================================================================
//* 3. Margins
//*=======================================================================

//*=======================================================================
//* 4. Partial effect of income
//*=======================================================================

//*=======================================================================
//* 5. Partial effect of gali
//*=======================================================================

//*=======================================================================
//* 6. Percent correctly predicted
//*=======================================================================



//*#######################################################################
//* n. Close log.
//*#######################################################################

*log close
*translate _log\log.smcl _log\log.pdf, replace

//*#######################################################################