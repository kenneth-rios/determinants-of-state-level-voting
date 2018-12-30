***** Author: Kenneth Rios
***** Last Updated: 3/13/2018
*****
***** Purpose: This script generates percentages of population according to male/
***** female, white/black/asian/other, and hispanic/non-hispanic by state, for
***** years 2000, 2004, 2008, 2012, and 2016.

clear all
set more off

/* Import state-level demographics */
*** 2000, 2004, and 2008 ***
import delimited "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Demographics\st-est00int-sexracehisp_2000_2010.csv"

keep name sex origin race popestimate2000 popestimate2004 popestimate2008
drop if name == "United States"

reshape long popestimate, i(name sex origin race) j(Year)
rename name State
order State Year
sort Year State sex origin race

/* Generate variables for female, white, black, asian, and hispanic totals; by state, by year */
by Year State: gen total = popestimate if sex == 0 & origin == 0 & race == 0
replace total = total[_n-1] if total >= . 

*** Female ***
by Year State: gen female = popestimate if sex == 2 & origin == 0 & race == 0
sort Year State female
replace female = female[_n-1] if female >= . 

*** White ***
by Year State: gen white = popestimate if sex == 0 & origin == 0 & race == 1
sort Year State white
replace white = white[_n-1] if white >= .

*** Black ***
by Year State: gen black = popestimate if sex == 0 & origin == 0 & race == 2
sort Year State black
replace black = black[_n-1] if black >= .

*** Asian ***
by Year State: gen asian = popestimate if sex == 0 & origin == 0 & race == 4
sort Year State asian
replace asian = asian[_n-1] if asian >= .

*** Hispanic ***
by Year State: gen hispanic = popestimate if sex == 0 & origin == 2 & race == 0
sort Year State hispanic
replace hispanic = hispanic[_n-1] if hispanic >= .

/* Generate percentages of population by female, white, black, asian, and hispanic members */
keep State Year total female white black asian hispanic

gen Female_pct = (female/total)*100
gen White_pct = (white/total)*100
gen Black_pct = (black/total)*100
gen Asian_pct = (asian/total)*100
gen Hispanic_pct = (hispanic/total)*100

drop total-hispanic
duplicates drop

save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\demographics.dta", replace


*** 2012 ***
import delimited "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Demographics\ACS_12_1YR_DP05_with_ann.csv", varnames(1) rowrange(3) clear
drop if geodisplaylabel == "Puerto Rico"

keep geodisplaylabel hc03_vc05 hc03_vc43 hc03_vc44 hc03_vc50 hc03_vc82
rename geodisplaylabel State
rename hc03_vc05 Female_pct
rename hc03_vc43 White_pct
rename hc03_vc44 Black_pct
rename hc03_vc50 Asian_pct
rename hc03_vc82 Hispanic_pct
destring Female_pct-Hispanic_pct, replace

gen Year = 2012
order State Year

append using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\demographics.dta"
sort Year State
save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\demographics.dta", replace


*** 2016 ***
import delimited "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Data\State Demographics\ACS_16_1YR_DP05_with_ann.csv", varnames(1) rowrange(3) clear
drop if geodisplaylabel == "Puerto Rico"

keep geodisplaylabel hc03_vc05 hc03_vc49 hc03_vc50 hc03_vc56 hc03_vc88
rename geodisplaylabel State
rename hc03_vc05 Female_pct
rename hc03_vc49 White_pct
rename hc03_vc50 Black_pct
rename hc03_vc56 Asian_pct
rename hc03_vc88 Hispanic_pct
destring Female_pct-Hispanic_pct, replace

gen Year = 2016
order State Year

append using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\demographics.dta"
sort Year State
save "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\demographics.dta", replace

