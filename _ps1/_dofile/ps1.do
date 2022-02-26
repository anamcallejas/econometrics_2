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
cd "C:\Users\Felipe M\Dropbox\1_Personal\_maestria_unibo_(operacional)\8_econometrics_2\_problem_sets\_ps1"
*log using "PS1_Ana",text replace

use _data/group9.dta

//*#############################################################################
//* Part 1
//*#############################################################################

//*=============================================================================
//* 1. generate org
//*=============================================================================

tab soburial, m
tab sowomen, m
tab soreligious, m
tab soyouth, m

gen org = .
replace org = 0 if (soburial == 0 & sowomen == 0 & soreligious == 0 & soyouth == 0)
replace org = 1 if (soburial == 1 | sowomen == 1 | soreligious == 1 | soyouth == 1)
tab org

//*=============================================================================
//* 2. graph 1
//*=============================================================================
* https://stats.oarc.ucla.edu/stata/faq/how-can-i-make-a-bar-graph-with-error-bars/
* https://www.stata-journal.com/sjpdf.html?articlenum=gr0019

tab wave
generate byte t = .
replace t = 0 if wave == 1991
replace t = 1 if wave == 2003

bysort t: summarize soburial sowomen soreligious soyouth org

save group9_v2, replace

//*-----------------------------------------------------------------------------
* for soburial:

clear all
use group9_v2

*graph bar soburial sowomen soreligious soyouth org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_soburial=soburial (sd) sd_soburial=soburial (count) n=soburial, by(t)

//*----- Create confidence intervals
generate hi_soburial= mean_soburial + invttail(n-1,0.025)*(sd_soburial / sqrt(n))
generate lo_soburial = mean_soburial - invttail(n-1,0.025)*(sd_soburial / sqrt(n))

graph bar mean_soburial, over(t)
twoway  (bar mean_soburial t, ylabel(0[.05]0.6)) (rcap hi_soburial lo_soburial t, xlabel(0[1]1))
graph save _graphs\mean_year_soburial.gph, replace

//*-----------------------------------------------------------------------------
* for sowomen:

clear all
use group9_v2

*graph bar soburial sowomen soreligious soyouth org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_sowomen=sowomen (sd) sd_sowomen=sowomen (count) n=sowomen, by(t)

//*----- Create confidence intervals
generate hi_sowomen= mean_sowomen + invttail(n-1,0.025)*(sd_sowomen / sqrt(n))
generate lo_sowomen = mean_sowomen - invttail(n-1,0.025)*(sd_sowomen / sqrt(n))

graph bar mean_sowomen, over(t)
twoway  (bar mean_sowomen t, ylabel(0[.05]0.6)) (rcap hi_sowomen lo_sowomen t, xlabel(0[1]1))
graph save _graphs\mean_year_sowomen.gph, replace

//*-----------------------------------------------------------------------------
* for soreligious:

clear all
use group9_v2

*graph bar soburial sowomen soreligious soyouth org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_soreligious=soreligious (sd) sd_soreligious=soreligious (count) n=soreligious, by(t)

//*----- Create confidence intervals
generate hi_soreligious= mean_soreligious + invttail(n-1,0.025)*(sd_soreligious / sqrt(n))
generate lo_soreligious = mean_soreligious - invttail(n-1,0.025)*(sd_soreligious / sqrt(n))

graph bar mean_soreligious, over(t)
twoway  (bar mean_soreligious t, ylabel(0[.05]0.6)) (rcap hi_soreligious lo_soreligious t, xlabel(0[1]1))
graph save _graphs\mean_year_soreligious.gph, replace

//*-----------------------------------------------------------------------------
* for soyouth:

clear all
use group9_v2

*graph bar soyouth sowomen soreligious soyouth org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_soyouth=soyouth (sd) sd_soyouth=soyouth (count) n=soyouth, by(t)

//*----- Create confidence intervals
generate hi_soyouth= mean_soyouth + invttail(n-1,0.025)*(sd_soyouth / sqrt(n))
generate lo_soyouth = mean_soyouth - invttail(n-1,0.025)*(sd_soyouth / sqrt(n))

graph bar mean_soyouth, over(t)
twoway  (bar mean_soyouth t, ylabel(0[.05]0.6)) (rcap hi_soyouth lo_soyouth t, xlabel(0[1]1))
graph save _graphs\mean_year_soyouth.gph, replace

//*-----------------------------------------------------------------------------
* for org:

clear all
use group9_v2

*graph bar org sowomen soreligious org org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_org=org (sd) sd_org=org (count) n=org, by(t)

//*----- Create confidence intervals
generate hi_org= mean_org + invttail(n-1,0.025)*(sd_org / sqrt(n))
generate lo_org = mean_org - invttail(n-1,0.025)*(sd_org / sqrt(n))

graph bar mean_org, over(t)
twoway  (bar mean_org t, ylabel(0[.05]0.6)) (rcap hi_org lo_org t, xlabel(0[1]1))
graph save _graphs\mean_year_org.gph, replace

//*=============================================================================
//* 2. XXX
//*=============================================================================

//*-----------------------------------------------------------------------------
* merge graphs:

graph combine _graphs\mean_year_soburial.gph _graphs\mean_year_sowomen.gph _graphs\mean_year_soreligious.gph _graphs\mean_year_soyouth.gph _graphs\mean_year_org.gph, rows(1)

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

