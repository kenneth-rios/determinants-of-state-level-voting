***** Author: Kenneth Rios
***** Last Updated: 3/11/2018
*****
***** Purpose: This script generates US unemployment rates by state for October
***** 2000, 2004, 2008, 2012, and 2016.

clear all
set more off

/* Import state-level unemployment rates */
import excel "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Unemployment Rates\State_level_unemployment_rate.xls", sheet("Monthly") firstrow

* Keep only October 2000, 2004, 2008, 2012, and 2016 figures *
gen Month = month(DATE)
gen Year = year(DATE)
keep if Month == 10 & (Year == 2000 | Year == 2004 | Year == 2008 | Year == 2012 | Year == 2016)
drop DATE Month

xpose, clear varname

drop if _varname == "Year"
rename v1 Unemp_rate2000
rename v2 Unemp_rate2004
rename v3 Unemp_rate2008
rename v4 Unemp_rate2012
rename v5 Unemp_rate2016
rename _varname stateabbr
reshape long Unemp_rate, i(stateabbr) j(Year)

* Merge in state names *
replace stateabbr = substr(stateabbr,1,2)

merge m:1 stateabbr using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\stateabbr.dta"
drop _merge stateabbr

order State Year
sort Year State

save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\unemp_rates.dta", replace
