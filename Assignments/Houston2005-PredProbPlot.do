*get data
sysuse auto,clear


****INPUTS****
*enter specification including if statements
ologit rep78 weight

*Specify the primary independent variable after "prix"
local prix weight

****END INPUT***


*requires estadd
qui: which estadd
local y `e(depvar)' 
global numcat = e(k_cat) 
est sto ologit //stores results
su `prix' if e(sample) 
loc min = r(min)
loc max = r(max)
loc step = round(((r(max)-r(min))/20),.0001)

levelsof `y' if e(sample),local(cats)
*local cats = e(k_cat) // stores number of levels on Y 
foreach cat of local cats {
*forvalues cat  = 1/`cats' { 
est restore ologit
margins , at(`prix' = (`min' (`step') `max')) predict(outcome(`cat')) post //margins for each outcome over prix
mat at = e(at)
estadd margins
mat A = e(margins_table)
mat margins`cat' = A["b",1...]'
mat ll`cat' = A["ll",1...]'
mat ul`cat' = A["ul",1...]'
}

clear
svmat at
rename at `prix'


foreach cat of local cats {
svmat margins`cat',names(margins`cat')
label var margins`cat' "Outcome`cat'"
svmat ll`cat'
svmat ul`cat'
}
rename margins*? margins*

local acum
local i = 1
foreach cat of local cats {
local acum `acum' margins`cat'
macro list
egen test`cat' =  rowmean(`acum')
gen acummargins`cat' = test`cat'*`i'
drop test*
loc i = `i' + 1
}

order `prix' margins* ll* ul*

global cats `cats'
global prix `prix'

***********************************
****Graphing*******

*Predicted probs
local cats $cats
local tw
foreach cat of local cats {
di `cat'
local tw `tw' (line margins`cat' $prix) 
}
tw `tw'

*Accumulated
local cats $cats
local i = 1
local atw
foreach cat of local cats {
if `i' < $numcat {
local atw `atw' (line acummargins`cat' $prix) 
local i = `i' + 1
}
else {
continue, break
}
}
tw `atw'
