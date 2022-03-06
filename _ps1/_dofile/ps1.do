//* Authors: Callejas A.; Gohlami A.; Montealegre F.
//* Date: 06/03/2021
//* The latest version of this file along the entire folder structure is in
//* GitHub: https://github.com/anamcallejas/econometrics_2

//*#############################################################################
//* 0. Set working directory and log.
//*#############################################################################

clear all
set more off

cd "C:\Users\amcal\Documentos\Clases\3-Econometrics 2\_problem_sets\_ps1"
log using _log/log, replace

ssc install estout, replace
use _data/group9.dta

//*#############################################################################
//* Part 1
//*#############################################################################

//*=============================================================================
//* 1. Generate org variable
//*=============================================================================

tab soburial, m
tab sowomen, m
tab soreligious, m
tab soyouth, m

gen org = .
replace org = 0 if (soburial == 0 & sowomen == 0 & soreligious == 0 & soyouth == 0)
replace org = 1 if (soburial == 1 | sowomen == 1 | soreligious == 1 | soyouth == 1)
label variable org "Participation to at least one organization"
tab org

//*=============================================================================
//* 2. Graph 1
//*=============================================================================
* https://stats.oarc.ucla.edu/stata/faq/how-can-i-make-a-bar-graph-with-error-bars/
* https://www.stata-journal.com/sjpdf.html?articlenum=gr0019

tab wave
generate byte t = .
replace t = 0 if wave == 1991
replace t = 1 if wave == 2003

bysort t: summarize soburial sowomen soreligious soyouth org

save _data/group9_v2, replace

//*-----------------------------------------------------------------------------
//*----- for soburial:

clear all
use _data/group9_v2

*graph bar soburial sowomen soreligious soyouth org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_soburial=soburial (sd) sd_soburial=soburial (count) n=soburial, by(t)

//*----- Create confidence intervals
generate hi_soburial= mean_soburial + invttail(n-1,0.025)*(sd_soburial / sqrt(n))
generate lo_soburial = mean_soburial - invttail(n-1,0.025)*(sd_soburial / sqrt(n))

graph bar mean_soburial, over(t)
twoway  (bar mean_soburial t, ylabel(0[.05]0.6)) (rcap hi_soburial lo_soburial t, xlabel(0[1]1)legend(off)xtitle("Mean soburial"))

graph save _graphs\mean_year_soburial.gph, replace

//*-----------------------------------------------------------------------------
//*----- for sowomen:

clear all
use _data/group9_v2

*graph bar soburial sowomen soreligious soyouth org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_sowomen=sowomen (sd) sd_sowomen=sowomen (count) n=sowomen, by(t)

//*----- Create confidence intervals
generate hi_sowomen= mean_sowomen + invttail(n-1,0.025)*(sd_sowomen / sqrt(n))
generate lo_sowomen = mean_sowomen - invttail(n-1,0.025)*(sd_sowomen / sqrt(n))

graph bar mean_sowomen, over(t)
twoway  (bar mean_sowomen t, ylabel(0[.05]0.6)) (rcap hi_sowomen lo_sowomen t, xlabel(0[1]1)legend(off)xtitle("Mean sowomen"))
graph save _graphs\mean_year_sowomen.gph, replace

//*-----------------------------------------------------------------------------
//*----- for soreligious:

clear all
use _data/group9_v2

*graph bar soburial sowomen soreligious soyouth org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_soreligious=soreligious (sd) sd_soreligious=soreligious (count) n=soreligious, by(t)

//*----- Create confidence intervals
generate hi_soreligious= mean_soreligious + invttail(n-1,0.025)*(sd_soreligious / sqrt(n))
generate lo_soreligious = mean_soreligious - invttail(n-1,0.025)*(sd_soreligious / sqrt(n))

graph bar mean_soreligious, over(t)
twoway  (bar mean_soreligious t, ylabel(0[.05]0.6)) (rcap hi_soreligious lo_soreligious t, xlabel(0[1]1)legend(off)xtitle("Mean soreligious"))
graph save _graphs\mean_year_soreligious.gph, replace

//*-----------------------------------------------------------------------------
//*----- for soyouth:

clear all
use _data/group9_v2

*graph bar soyouth sowomen soreligious soyouth org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_soyouth=soyouth (sd) sd_soyouth=soyouth (count) n=soyouth, by(t)

//*----- Create confidence intervals
generate hi_soyouth= mean_soyouth + invttail(n-1,0.025)*(sd_soyouth / sqrt(n))
generate lo_soyouth = mean_soyouth - invttail(n-1,0.025)*(sd_soyouth / sqrt(n))

graph bar mean_soyouth, over(t)
twoway  (bar mean_soyouth t, ylabel(0[.05]0.6)) (rcap hi_soyouth lo_soyouth t, xlabel(0[1]1)legend(off)xtitle("Mean soyouth"))
graph save _graphs\mean_year_soyouth.gph, replace

//*-----------------------------------------------------------------------------
//*----- for org:

clear all
use _data/group9_v2

*graph bar org sowomen soreligious org org, over(wave)

//*----- Use collapse to generate mean sd and count
collapse (mean) mean_org=org (sd) sd_org=org (count) n=org, by(t)

//*----- Create confidence intervals
generate hi_org= mean_org + invttail(n-1,0.025)*(sd_org / sqrt(n))
generate lo_org = mean_org - invttail(n-1,0.025)*(sd_org / sqrt(n))

graph bar mean_org, over(t)
twoway  (bar mean_org t, ylabel(0[.05]0.6)) (rcap hi_org lo_org t, xlabel(0[1]1)legend(off)xtitle("Mean org"))
graph save _graphs\mean_year_org.gph, replace

//*-----------------------------------------------------------------------------
//*----- merge graphs:

graph combine _graphs\mean_year_soburial.gph _graphs\mean_year_sowomen.gph _graphs\mean_year_soreligious.gph _graphs\mean_year_soyouth.gph _graphs\mean_year_org.gph, rows(1) , title("Average participation in 1991 and 2003")

graph save _graphs\graph1.ghp , replace
global infile="_output"
graph export "_output/graph1.pdf", as(pdf) replace



//*=============================================================================
//* 3. Graph 2: Between variability AND Table "Between variability"
//*=============================================================================
//*----- for soburial:

clear all
use _data/group9_v2

collapse (mean) mean_soburial=soburial, by(kecnum)
estpost summarize mean_soburial, listwise 
esttab using _output/between_variability.tex, cells ("count mean sd min max") unstack noobs nonumbers title ("Between variability of organizations by sub-districts"\label{tab1}) replace

gsort -mean_soburial
generate n =_n
twoway  (bar mean_soburial n), xlabel(0[400]800)
graph save _graphs\mean_dis_soburial.gph, replace

//*----- for sowomen:

clear all
use _data/group9_v2

collapse (mean) mean_sowomen=sowomen, by(kecnum)
estpost summarize mean_sowomen
esttab using _output/between_variability.tex, cells ("count mean sd min max") unstack noobs nonumbers append

gsort -mean_sowomen
generate n =_n
twoway  (bar mean_sowomen n), xlabel(0[400]800)
graph save _graphs\mean_dis_sowomen.gph, replace

//*----- for soreligious:

clear all
use _data/group9_v2

collapse (mean) mean_soreligious=soreligious, by(kecnum)
estpost summarize mean_soreligious
esttab using _output/between_variability.tex, cells ("count mean sd min max") unstack noobs nonumbers append

gsort -mean_soreligious
generate n =_n
twoway  (bar mean_soreligious n), xlabel(0[400]800)
graph save _graphs\mean_dis_soreligious.gph, replace


//*----- for soyouth:

clear all
use _data/group9_v2

collapse (mean) mean_soyouth=soyouth, by(kecnum)
estpost summarize mean_soyouth
esttab using _output/between_variability.tex, cells ("count mean sd min max") unstack noobs nonumbers append

gsort -mean_soyouth
generate n =_n
twoway  (bar mean_soyouth n), xlabel(0[400]800)
graph save _graphs\mean_dis_soyouth.gph, replace

//*----- for org:

clear all
use _data/group9_v2

collapse (mean) mean_org=org, by(kecnum)
estpost summarize mean_org
esttab using _output/between_variability.tex, cells ("count mean sd min max") unstack noobs nonumbers append 

gsort -mean_org
generate n =_n
twoway  (bar mean_org n), xlabel(0[400]800)
graph save _graphs\mean_dis_org.gph, replace

//*----- merge graphs:

graph combine _graphs\mean_dis_soburial.gph _graphs\mean_dis_sowomen.gph _graphs\mean_dis_soreligious.gph _graphs\mean_dis_soyouth.gph _graphs\mean_dis_org.gph , rows(1) , title("Means of organization by sub-district in descending order")


graph save _graphs\graph2.ghp , replace
global infile="_output"
graph export "_output/graph2.pdf", as(pdf) replace


//*=============================================================================
//* 4. Table "Within variability"
//*=============================================================================

clear all
use _data/group9_v2

//*----- for soburial:

bysort kecnum: egen mean_sd_soburial = mean(soburial)
egen mean_soburial = mean(mean_sd_soburial)
generate w_soburial = (soburial - mean_sd_soburial - mean_soburial)

drop mean_soburial
drop mean_sd_soburial

//*----- for sowomen:

bysort kecnum: egen mean_sd_sowomen = mean(sowomen)
egen mean_sowomen = mean(mean_sd_sowomen)
generate w_sowomen = (sowomen - mean_sd_sowomen - mean_sowomen)

drop mean_sowomen
drop mean_sd_sowomen

//*----- for soreligious:

bysort kecnum: egen mean_sd_soreligious = mean(soreligious)
egen mean_soreligious = mean(mean_sd_soreligious)
generate w_soreligious = (soreligious - mean_sd_soreligious - mean_soreligious)

drop mean_soreligious
drop mean_sd_soreligious

//*----- for soyouth:

bysort kecnum: egen mean_sd_soyouth = mean(soyouth)
egen mean_soyouth = mean(mean_sd_soyouth)
generate w_soyouth = (soyouth - mean_sd_soyouth - mean_soyouth)

drop mean_soyouth
drop mean_sd_soyouth

//*----- for org:

bysort kecnum: egen mean_sd_org = mean(org)
egen mean_org = mean(mean_sd_org)
generate w_org = (org - mean_sd_org - mean_org)

drop mean_org
drop mean_sd_org

//*----- report:

estpost sum w_soburial w_sowomen w_soreligious w_soyouth w_org
esttab using _output/tab1.tex, cells("count mean sd min max") title(Within variability\label{tab2}) replace

//*=============================================================================
//* 5. Graph 3 Between variability TV channels AND table 3 and 4 between and within variability TV channels
//*=============================================================================

clear all
use _data/group9_v2

//*----- between variability:
collapse (mean) mean_tv=tvchannels, by(kecnum)
summarize mean_tv

estpost sum mean_tv
esttab using _output/summary_btv.tex, cells("count mean sd min max") title(Between variability of TV channels\label{tab3}) replace

gsort -mean_tv
generate n =_n
twoway  (bar mean_tv n) , title("Means of TV channels by sub-district in descending order")

graph save _graphs\graph3.ghp , replace
global infile="_output"
graph export "_output/graph3.pdf", as(pdf) replace

clear all
use _data/group9_v2

//*----- within variability:

bysort kecnum: egen mean_sd_tv = mean(tvchannels)
egen mean_tv = mean(mean_sd_tv)
generate w_tv = (tvchannels - mean_sd_tv - mean_tv)

sum w_tv

estpost sum w_tv 
esttab using _output/summary_wtv.tex, cells("count mean sd min max") title(Within variability of TV channels\label{tab4}) replace

//*#############################################################################
//* Part 2.
//*#############################################################################

//*=============================================================================
//* 0. Regressions of tvchannels on social capital
//*=============================================================================

clear all
use _data/group9_v2

eststo: reg soburial tvchannels
eststo: reg sowomen tvchannels
eststo: reg soreligious tvchannels
eststo: reg soyouth tvchannels
eststo: reg org tvchannels

esttab using _output/regressions_v2.tex, title(Regression of the number of TV channels on social organization participation\label{tab5}) replace

//*#############################################################################
//* Part 3.
//*#############################################################################

//*=============================================================================
//* 1. Regression of org on tv channels, clustring on subdistrict level
//*=============================================================================

clear all
// Focusing on org therefore I drop the so... variables and t since wave is available
use _data/group9_v2
drop soyouth soreligious soburial sowomen t

* Simple regression of org on tv channels with dummies controling for 
//subdistrict differences. Approching to data as pooled cross-section not Panel data
reg org tvchannels age gender years_educ lnexpcap i.kecnum i.wave, cluster(kecnum)

estimates store m1 //, tvchannels _age _gender _years_educ _lnexpcap

* Same thing but treating data as panel. Since individual people are not 
// distinct in two time frames we have to treat subdistricts as individual
// there for collapsing the data for sub districs.
collapse tvchannels kabidwave age gender years_educ lnexpcap org , by (kecnum wave)

* Introducing kecnum as panel variable and wave as time variable
xtset kecnum wave

xtsum
quietly xtreg org tvchannels age gender years_educ lnexpcap

estimates store m2
esttab m1 m2 using _output/Table2.tex, title (" Regression of Social Participation over number of TV channels using OLS and Fixed Effect") mtitles("OLS" "Fixed Effect") drop (*.kecnum) replace

//*=============================================================================
//* 2. Regression of org on tv channels, clustring on subdistrict level and kabidwave
//*=============================================================================
//*----- 

clear all
// Focusing on org therefore I drop the so... variables and t since wave is available
use _data/group9_v2
drop soyouth soreligious soburial sowomen

reg org tvchannels age gender years_educ lnexpcap i.kecnum i.kabidwave i.wave, cluster (kecnum)

estimates store m3

collapse tvchannels kabidwave age gender years_educ lnexpcap org , by (kecnum wave)
xtset kecnum wave

xtreg org tvchannels age gender years_educ lnexpcap i.kabidwave

estimates store m4

esttab m3 m4 using _output/Table3.tex, title (" Regression of Social Participation over number of TV channels using OLS and Fixed Effect adding interaction of district and wave") mtitles("OLS" "Fixed Effect") drop (*.kecnum *.kabidwave) replace


//*#############################################################################
//* n. Close log.
//*#############################################################################

log close
translate _log\log.smcl _log\log.pdf, replace

//*#############################################################################