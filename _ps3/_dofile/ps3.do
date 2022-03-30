//* Authors: Callejas A.; Gohlami A.; Montealegre F.
//* Date: 30/03/2021
//* The latest version of this file along the entire folder structure is in
//* GitHub: https://github.com/anamcallejas/econometrics_2

//*#######################################################################
//* 0. Set working directory and log.
//*#######################################################################

clear all
set more off

*cd "C:\Users\amcal\Documentos\Clases\3-Econometrics 2\_problem_sets\_ps3"
cd "C:\Users\Felipe M\Dropbox\1_Personal\_maestria_unibo_(operacional)\8_econometrics_2\_problem_sets\_ps3"
*log using _log/log, replace

*ssc install ivreg2
*ssc install ranktest
*ssc install ivregress2
*ssc install estout, replace
use _data/group9

//*=======================================================================
//* 0. Data mangling
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

gen cjs_ = .
replace cjs_ = 1 if cjs == 1
replace cjs_ = 2 if cjs == 2
replace cjs_ = 3 if cjs == 3
replace cjs_ = 4 if cjs == 4
replace cjs_ = 5 if cjs == 5
replace cjs_ = 6 if cjs == 97
tab cjs_

save _data/group9_v2 , replace

*age behavior: graphing of the mean of life satisfaction by age 
collapse (mean) mean_lifesat =lifesat , by(age)
scatter mean_lifesat age,  legend(size(medsmall))
graph save _graphs\lifesat10.gph, replace


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

clear all 
use _data/group9_v2

*showld we include more variables and age^2?
gen sqd_age = age^2
reg life_sat income age sqd_age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs_ fahc fohc thexp hnetw nchild ngrchild, robust

*chosen model
reg life_sat income age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs_ , robust

esttab using _output/regression_lpm.tex, title("Regression of the probability of being satisfied with life (Linear Probability Model)") se nogap replace

//* ----- model is not the best:
//* y_hat has predicted values that go below/above the min/max range for y.

predict y_hat
summarize y_hat

//* We can calculate the % correcly predicted as follows:

gen y_tilde = .
replace y_tilde = 0 if y_hat < 0.5
replace y_tilde = 1 if y_hat >= 0.5

gen correctly_predicted = .
replace correctly_predicted = 0 if life_sat != y_tilde
replace correctly_predicted = 1 if life_sat == y_tilde



//*#######################################################################
//* Part 2
//*#######################################################################

//*=======================================================================
//* 1. ML estimation
//*=======================================================================

probit life_sat income age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs_

*Report of the estimate for income
esttab using _output/probit1.tex, title("Estimation of income coefficient from probit model") se keep(income) replace

* Wald Test for joint significance. Null hypothesis : The coefficients for all the regressors are zero

test income age female yedu 2.mstat 3.mstat 4.mstat 5.mstat 6.mstat 2.hstatus 3.hstatus 4.hstatus 5.hstatus gali wave2 wave3 phinact 2.cjs_ 3.cjs_ 4.cjs_ 5.cjs_ 6.cjs_

*testing for female, wave3 and cjs=2 significance
quietly: probit life_sat income age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs_

test female wave3 2.cjs_

*correctly predicted percentage
quietly: probit life_sat income age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs_

predict phat, p
generate ls_hat=(phat>0.5)
tab  life_sat ls_hat,row

*percentage correcly predicted: (n_00 + n_11)/N
display (2338+5795)/12292

//*=======================================================================
//* 2. Wald test and Likelihood ratio test
//*=======================================================================

quietly: probit life_sat income age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs_

*Wald test for significance of trend dummies coefficients
test wave2 wave3

*Likelihood ratio test on trend dummies coefficients
quietly: probit life_sat income age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs_
estimate store unres

quietly: probit life_sat income age female yedu i.mstat i.hstatus gali  phinact i.cjs_ 
*without wave2 and wave3

lrtest unres


//*=======================================================================
//* 3. Margins
//*=======================================================================

probit life_sat income age female yedu i.mstat i.hstatus gali wave2 wave3 phinact i.cjs_ 

*average partial effect (APE)
margins, dydx(*)

*partial effect at the average (PEA)
margins, dydx(*) atmeans

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