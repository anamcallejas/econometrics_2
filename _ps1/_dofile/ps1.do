//* Authors: Callejas A.; Gohlami A.; Montealegre F.
//* Date:
//* The latest version of this file along the entire folder structure is in
//* GitHub: XXX

//*#############################################################################
//* 0. Set working directory and log.
//*#############################################################################

clear all
set more off
*capture log close
cd "C:\Users\amcal\Documentos\Clases\II semester\Econometrics 2\_problem_sets\_ps1"
*log using "PS1_Ana",text replace

use _data/group9.dta


//*#############################################################################
//* Part 1
//*#############################################################################

//*=============================================================================
//* 1. generate org
//*=============================================================================

gen pre_org = soburial + sowomen + soreligious + soyouth
gen org = 1 if pre_org>0
replace org = 0 if missing(org)

* Checking to have the same number of 0 values
tab org
tab pre_org

drop pre_org
label variable org "Individual participation to at least one organization"

//*=============================================================================
//* 2. XXX
//*=============================================================================


//*#############################################################################
//* XXX
//*#############################################################################

//*=============================================================================
//* XXX
//*=============================================================================
//*----- XXX

//*#############################################################################
//* n. Close log.
//*#############################################################################

*log close
*translate 3_log\log.smcl 3_log\log.pdf, replace

//*#############################################################################

