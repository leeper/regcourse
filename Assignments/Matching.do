* Houston 2005 Matching activity

use "GSS2002.dta", clear

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


* --------- Outcomes --------- *
recode volchrty 6=0 1/5=1, gen(volbin)
* tab volchrty volbin

recode givblood 6=0 1/5=1, gen(bloodbin)
* tab givblood bloodbin

recode givchrty 6=0 1/5=1, gen(charbin)
* tab givchrty charbin

recode strsswrk 1=-1 2=-.5 3=0 4=.5 5=1, gen(jobstress)
* jobstress: higher values indicate job is more stressful
* tab strsswrk jobstress


