
****INPUTS****
*enter fuction (ologit/oprobit) after "func"
local func ologit

*enter DV after "y"
local y attcare

*enter primary X after "prix"
local prix age

*enter controls after "controls" (leave empty for none)
local controls 

*************

`func' `y' `prix' `controls'  //estimation
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

order `prix' margins* ll* ul*

local tw
foreach cat of local cats {
local tw `tw' (line margins`cat'1 `prix') 
}
tw `tw'
