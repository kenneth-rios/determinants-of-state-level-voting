***** Author: Kenneth Rios
***** Last Updated: 4/18/2018
*****
***** Purpose: This script generates state-level Gini and Atkinson indices
***** for years 2000, 2004, 2008, 2012, and 2016.

clear all
set more off

/* Import state-level Gini and Atkinson indices */
import excel "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Income Data\Frank_Gini_2015.xls", sheet("Measures") firstrow
keep if Year == 2000 | Year == 2004 | Year == 2008 | Year == 2012 | Year == 2015
replace Year = 2016 if Year == 2015 // impute 2016 data with 2015 figures

drop if st == 0
keep Year State Gini Atkin05
order State Year Gini Atkin05

save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\inequality_indices.dta", replace

/* Import state-level per-capita income levels 
import excel "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Income Data\percapitalPI_levels.xls", sheet("Sheet0") cellrange(A6:AP62) firstrow clear

replace GeoName = "Alaska" if GeoName == "Alaska*"
replace GeoName = "Hawaii" if GeoName == "Hawaii*"
drop if GeoName == ""
keep GeoName Z AD AH AL AP

rename Z Income_pc2000
rename AD Income_pc2004
rename AH Income_pc2008
rename AL Income_pc2012
rename AP Income_pc2016
reshape long Income_pc, i(GeoName) j(Year)
replace Income_pc = Income_pc/1000
rename Income_pc Income_pc_thous

rename GeoName State
sort Year State 

save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\income_pc.dta", replace */
