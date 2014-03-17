* Houston 2005 Replication

use "GSS2002.dta", clear

* ------- outcomes ------- *

recode volchrty 6=0 1/5=1, gen(volbin)
* tab volchrty volbin

recode givblood 6=0 1/5=1, gen(bloodbin)
* tab givblood bloodbin

recode givchrty 6=0 1/5=1, gen(charbin)
* tab givchrty charbin


* ------- covariates ------- *
recode wrkgovt 2=0, gen(pubemp)

recode sex 2=1 1=0, gen(gender)

recode race 1=1 else=0, gen(racebin)

* education is `educ`

* income category 20 and above is >=60k
recode rincom98 1/19=0 20/23=1, gen(income60)

* prestige is `prestg80`

* marital status
recode marital 1=1 else=0, gen(married)

* age squared
gen age2 = age^2

* children under 17 in HH
recode preteen missing = 0
recode teens missing = 0
recode babies missing = 0
gen hhchildren = babies + preteen + teens

* population size logged
gen poplog = log(size)

* attend church weekly or more
recode attend 7=1 8=1 else=0, gen(church)


* ------- logistic regression ------- *
logit volbin pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church

logit bloodbin pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church

logit charbin pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church


* ------- predicted probabilities ------- *
quietly logit charbin pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church
* predicted probabilities (fitted values)
predict charprobs
recode charprobs .5/1=1 .=. else=0, gen(charpredy)
tab charpredy charbin, cell
hist charprobs

* linear predictions
predict charfit, xb
twoway scatter charprobs charfit


margins, at(pubemp=(0 1))
logit charbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church

* average marginal effect
margins pubemp

* marginal effect at mean
margins pubemp, atmeans

* marginal effect at levels of education
margins pubemp, at(educ=(0 (5) 20))


* ------- predicted probability plots ------- *
twoway scatter charprobs educ

kdensity charprobs if pubemp==0, addplot(kdensity charprobs if pubemp==1) legend (label(1 "Private") label(2 "Public"))

margins, at(age=(30 35 40 45 50))
marginsplot, ylabel(0 (.1) 1)
marginsplot, recast(line) recastci(rarea) ylabel(0 (.1) 1)

quietly margins pubemp, at(educ=(0 (5) 20))
marginsplot, recast(line) recastci(rarea) ylabel(0 (.1) 1)



* ------- marginal effects ------- *

quietly logit charbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church
margins, dydx(pubemp)
margins, dydx(pubemp) atmeans
margins, dydx(pubemp) at(educ=(0 (5) 20))


* prvalue doesn't play well with factor variables
quietly logit charbin pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church
prvalue pubemp


* ------- marginal effects plots ------- *
quietly logit charbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church
* predicted probabilities plot
margins pubemp, at(age=(20 (5) 80))
marginsplot, recast(line) recastci(rarea)

* marginal effects plot
margins, dydx(pubemp) at(age=(20 (5) 80))
marginsplot, recast(line) recastci(rarea)


* ---- Interactions ---- *

* effect of race (1=white/caucasion; 0=else)
logit charbin i.racebin
margins racebin
marginsplot, ylabel(0 (.1) 1)
margins racebin

logit charbin i.racebin i.married age
margins racebin
marginsplot, ylabel(0 (.1) 1)

margins, dydx(racebin)
marginsplot

margins racebin, at(married=(0 1))
marginsplot, ylabel(0 (.1) 1)


margins, dydx(race) predict(xb) at(age=(20 (20) 100))
marginsplot, name(panela, replace)
margins, dydx(race) at(age=(20 (20) 100))
marginsplot, ylabel(-.1 (.1) .2) name(panelb, replace)
graph combine panela panelb, cols(1)


* factor by factor
logit charbin i.racebin##i.married educ

* predicted probabilities
margins racebin, predict(xb)
marginsplot, ylabel(0 (.5) 2) name(panela, replace)
margins racebin
marginsplot, ylabel(0 (.1) 1) name(panelb, replace)
graph combine panela panelb, cols(1)

* marginal effects
margins, dydx(racebin) predict(xb) at(educ=(0 (5) 20))
marginsplot, ylabel(0 (.5) 2) name(panela, replace)
margins, dydx(racebin) at(educ=(0 (5) 20))
marginsplot, ylabel(0 (.1) .5) name(panelb, replace)
graph combine panela panelb, cols(1)



margins racebin, at(married=(0 1) educ=(0 20))
marginsplot, ylabel(0 (.1) 1)

margins, dydx(racebin) at(educ=(0 (5) 20))
marginsplot




* factor by continous
logit charbin i.racebin##c.age
margins racebin

margins racebin, predict(xb) at(age=(20 (20) 100))
marginsplot, ylabel(0 (.5) 2) name(panela, replace)
margins racebin, at(age=(20 (20) 100))
marginsplot, ylabel(0 (.1) 1) name(panelb, replace)
graph combine panela panelb, cols(1)

margins, dydx(racebin) predict(xb) at(age=(20 (20) 100))
marginsplot, ylabel(0 (.5) 2) name(panela, replace)
margins, dydx(racebin) at(age=(20 (20) 100))
marginsplot, ylabel(-.3 (.1) .4) name(panelb, replace)
graph combine panela panelb, cols(1)


* --- Ordered outcome --- *

* Those in need should take care of self
recode careself 5=1 4=2 3=3 2=4 1=5, gen(attcare)
ologit attcare pubemp gender racebin educ married age

* use `prvalue` to look at predicted probabilities
prvalue

* `margins` doesn't 
