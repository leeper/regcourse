* Houston 2005 Matching activity

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
quietly logit volbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church
margins, dydx(pubemp)

quietly logit bloodbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church
margins, dydx(pubemp)

quietly logit charbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church
margins, dydx(pubemp)

* ------- OLS regression ------- *
reg volbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church

reg bloodbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church

reg charbin i.pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church

* ------- Matching estimates -------- *
* factor variables not allowed
teffects psmatch (volbin) (pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church)

teffects psmatch (bloodbin) (pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church)

teffects psmatch (charbin) (pubemp gender racebin educ income60 prestg80 married age hhchildren poplog church)

