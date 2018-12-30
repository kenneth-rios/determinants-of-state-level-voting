***** Author: Kenneth Rios
***** Last Updated: 3/11/2018
*****
***** Purpose: This script generates state-level Presidential outcomes by political
***** party in long format for election years 2000, 2004, 2008, 2012, and 2016.

clear all
set more off

/* Import state-level electoral outcomes */
*** 2000 ***
import excel "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Electoral Outcomes\federalelections2000.xls", sheet("2000 Pres Elec & Pop Vote-p. 12") cellrange(A3:C54) firstrow
gen Year = 2000
rename STATE stateabbr	
rename ElectoralVoteBushR Republican
rename ElectoralVoteGoreD Democrat
replace stateabbr = "DC" if stateabbr == "DC*"
save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta", replace

*** 2004 ***
import excel "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Electoral Outcomes\federalelections2004.xls", sheet("Table 2. Pres Elec & Pop Vote") cellrange(A3:C54) firstrow clear
gen Year = 2004
rename STATE stateabbr
rename ElectoralVoteBushR Republican
rename ElectoralVoteKerryD Democrat
replace Democrat = "9" if Democrat == "9*"
destring Democrat, replace
append using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta"
save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta", replace

*** 2008 ***
import excel "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Electoral Outcomes\federalelections2008.xls", sheet("Table 2. Electoral &  Pop Vote") cellrange(A4:C55) firstrow clear
gen Year = 2008
rename A stateabbr
rename McCainR Republican
rename ObamaD Democrat
append using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta"
save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta", replace

*** 2012 ***
import excel "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Electoral Outcomes\federalelections2012.xls", sheet("Table 2. Electoral &  Pop Vote") cellrange(A5:C56) firstrow clear
gen Year = 2012	
rename A stateabbr
rename RomneyR Republican 
rename ObamaD Democrat
append using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta"
save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta", replace

*** 2016 ***
import excel "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Electoral Outcomes\federalelections2016.xlsx", sheet("Table 2. Electoral &  Pop Vote") cellrange(A4:C55) firstrow clear
gen Year = 2016
rename A stateabbr
rename TrumpR Republican
rename ClintonD Democrat
replace Republican = "36" if Republican == "36*"
replace Democrat = "3" if Democrat == "3**" 
replace Democrat = "8" if Democrat == "8**"
destring Republican, replace
destring Democrat, replace
append using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta"
save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta", replace


/* Merge in state names */
merge m:1 stateabbr using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\stateabbr.dta"
drop _merge stateabbr

order State Year
sort Year State

/* Convert electoral outcomes to 1/0s */
drop Republican
replace Democrat = cond(Democrat, 1, 0, 0)

save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta", replace
