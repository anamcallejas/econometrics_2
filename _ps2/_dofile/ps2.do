//* Authors: Callejas A.; Gohlami A.; Montealegre F.
//* Date: 18/03/2021
//* The latest version of this file along the entire folder structure is in
//* GitHub: https://github.com/anamcallejas/econometrics_2

//*#############################################################################
//* 0. Set working directory and log.
//*#############################################################################

clear all
set more off

cd "C:\Users\amcal\Documentos\Clases\3-Econometrics 2\_problem_sets\_ps2"
*log using _log/log, replace

*ssc install estout, replace
use _data/group9.dta


//*#############################################################################
//* Part 2
//*#############################################################################
//*=============================================================================
//* Setting variable labels
//*=============================================================================

*----- Time variables ------
label variable yweek "complete years"
label variable periodo1 "seasonality variable"
drop week
drop periodo2

*----- Product variables (pv) ------
label variable firm "(pv) ID number of the producer"
label variable lsales_volume "(pv) (y) vol sales of i in week t"
label variable lprice "log price per i"
label variable pri_labe "(pv) 1 if i is from a private label"
label variable energy "(pv) calories per 100g"
label variable carbo "(pv) sugar per 100g"
label variable fat "(pv) fat per 100g"
label variable protein "(pv) protein per 100g"
label variable flav "(pv) 1 if flavored, 0 if natural or white"
label variable cream "(pv) 1 if creamy texture"
label variable drink "(pv) 1 if sold in bottles only"

*----- Store variables (st) ------
label variable hyper "(st) 1 if superstore"
label variable poptot "(st) population"
label variable hhtot "(st) number of hh"
label variable incometot "(st) total income"
label variable constot "(st) value of consumption"
label variable mtot "(st) number of men in market"
label variable wtot "(st) number of women in market"
label variable age_pop "(st) average population age"
label variable sqmtot "(st) total sqrd meters of stores"
label variable sqm_own "(st) sqrd meters of store"

*Possible instrumental variables (iv)
label variable energy1 "(iv) avg energy of other products of the same firm"
label variable carbo1 "(iv) avg carbo of other products of the same firm"
label variable fat1 "(iv) avg fat of other products of the same firm"
label variable protein1 "(iv) avg protein of other products of the same firm"
label variable energy2 "(iv) avg energy of other products of the same and other firms"
label variable carbo2 "(iv) avg carb of other products of the same and other firms"
label variable fat2 "(iv) avg fat of other products of the same and other firms"
label variable protein2 "(iv) avg protein of other products of the same and other firms"

save _data/group9_v2 , replace

//*=============================================================================
//* 1.
//*=============================================================================

clear all
use _data/group9_v2

//-----generate dummy for firm 
tab firm, gen(firm)
drop firm1

//-----Test for multicollinearity (energy)
reg lsales_volume lprice i.firm pri_label energy carbo fat protein flav cream drink
estat vif
reg lsales_volume lprice i.firm pri_label carbo fat protein flav cream drink
estat vif

//-----Test for multicollinearity (pri_label)
* variable firm8 gets ommited because of collinearity in the following regression, indicating possible correlation between regressors.
reg lsales_volume lprice firm2 firm3 firm4 firm5 firm6 firm7 firm8 firm9 pri_label carbo fat protein flav cream drink

*this tab indicates that pri_label is possibly collinear with the set of firm dummies
tab firm pri_label

*we run this regression to identify the exact dependency of pri_label and the firm dummies. As expected, firm1 and pri_label are a linear combiantion of each other.
reg pri_label lprice firm2 firm3 firm4 firm5 firm6 firm7 firm8 firm9 carbo fat protein flav cream drink

reg lsales_volume lprice firm2 firm3 firm4 firm5 firm6 firm7 firm8 firm9 carbo fat protein flav cream drink

estat vif

//-----Test for multicollinearity for store variables
* We run this regression to identify the behaviour of variables asociated with the store, finding high correlation between most of them. We decide to use the variable (store) that accurately clusters market information. 

reg lsales_volume constot sqmtot incometot sqm_own poptot wtot mtot hhtot age_pop hyper
corr constot sqmtot incometot sqm_own poptot wtot mtot hhtot age_pop hyper


//-----Final regression

reg lsales_volume lprice i.firm carbo fat protein flav cream drink hhtot age_pop sqmtot sqm_own yweek periodo1

//-----Drop descarted and unused variables

drop pri_label
drop category
drop subcat
drop rank
drop hhsize
drop store

drop energy
drop hyper
drop poptot
drop constot
drop mtot
drop wtot

 reg lsales_volume lprice i.firm carbo fat protein flav cream drink i.store yweek periodo1

*Proof of multicollinearity of energy variable
reg sales_volume protein fat carbo energy
estat vif
reg sales_volume protein fat carbo
estat vif







//*=============================================================================
//* 1. OLS estimation
//*=============================================================================



//*=============================================================================
//* 3. carbo1 as an instrument for log price
//*=============================================================================



//*=============================================================================
//* 4. Two stage least square approach
//*=============================================================================




//*=============================================================================
//* 5. Endogeneity of log price
//*=============================================================================


//*#############################################################################
//* Part 3
//*#############################################################################

//*=============================================================================
//* 1. Joint relevance of instruments
//*=============================================================================


//*=============================================================================
//* 2. Estimation with ivreg2
//*=============================================================================



//*#############################################################################
//* n. Close log.
//*#############################################################################

*log close
*translate _log\log.smcl _log\log.pdf, replace

//*#############################################################################