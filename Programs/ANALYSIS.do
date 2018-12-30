clear all
set more off
capture log close
log using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\results.log", replace text

***** Author: Kenneth Rios
***** Last Updated: 3/21/2018
*****
***** Purpose: This script merges all state-level data, calculates summary statistics
***** and runs a logistic regression of state-level electoral outcome on %male,
***** %white, %black, %asian, %hispanic, Gini and Atkinson inequality indices, 
***** and unemployment rates for years 2000, 2004, 2008, 2012, and 2016. We run
***** both fixed and random effects specifications and decide between the two
***** using a Hausman test. We then estimate marginal effects using -margins-.

/* Merge all state-level datasets for analysis */
use "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\electoral_outcomes.dta"

merge 1:1 State Year using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\demographics.dta", nogen
merge 1:1 State Year using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\income_pc.dta", nogen
merge 1:1 State Year using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\inequality_indices.dta", nogen
merge 1:1 State Year using "\\Client\C$\Users\kenri\OneDrive\Spring 2018\Applied Statistics & Econometrics II\Research Project\Output\unemp_rates.dta", nogen

sort Year State

/* Convert data to balanced panel */
rename State state
encode state, gen(State)
drop state
order State 

xtset State Year, delta(4)

/* Generate summary statistics */
xtsum Democrat White_pct Black_pct Asian_pct Female_pct Hispanic_pct Gini Unemp_rate
corr Democrat White_pct Black_pct Asian_pct Female_pct Hispanic_pct Gini Unemp_rate

/* Run panel-data logistic regressions and estimate marginal effects (-xtlogit-) */
*** Fixed Effects Specification ***
xtlogit Democrat White_pct Black_pct Asian_pct Female_pct Hispanic_pct Gini Unemp_rate, fe
est sto fixed_effs

margins, dydx(*) predict(xb)

*** Random Effects Specification ***
xtlogit Democrat White_pct Black_pct Asian_pct Female_pct Hispanic_pct Gini Unemp_rate, re 
est sto random_effs

margins, dydx(*)

/* Perform Hausman test */
hausman fixed_effs random_effs
* We fail to reject the null hypothesis at the 5% significance level. 
* Therefore we use the random effects model!

********************************************************************************

/* Perform test for autocorrelation in panel data */
reg D.Democrat D. White_pct D.Black_pct D.Asian_pct D.Female_pct D.Hispanic_pct D.Gini D.Unemp_rate
predict residuals, resid
reg residuals L.residuals
* Use -xtserial- instead

log close
