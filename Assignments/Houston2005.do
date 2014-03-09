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
logit charbin pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church
* predicted probabilities (fitted values)
predict charprobs
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
