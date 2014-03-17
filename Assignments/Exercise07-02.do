* Replicate basic ideas from Citrin et al. (1997) using ESS Round 6
* What effect do education and ideology have on immigration attitudes?

* http://www.europeansocialsurvey.org/download.html?file=ESS6DK&c=DK&y=2012
* http://www.europeansocialsurvey.org/docs/round6/fieldwork/source/ESS6_source_main_questionnaire.pdf


* B29-B31 allowing individuals of particular categories to live in this country.
* imsmetn: same ethnic group
* imdfetn: different ethnic group
* impcntr: poorer countries
* imbgeco: immigration good/bad for country
* imueclt: cultural life undermined or enriched by immigration
* imwbcnt: immigration makes country worse or better place


* recode outcomes
recode impcntr 1=4 2=3 3=2 4=1 8/9=., gen(immpoor)
recode imdfetn 1=4 2=3 3=2 4=1 8/9=., gen(immsame)
recode imsmetn 1=4 2=3 3=2 4=1 8/9=., gen(immdiff)

* left-right scale
recode lrscale 88=. 99=., gen(ideo)

* education
recode edulvlb 0=1 113=1 213=2 229=3 313=3 322=4 520=5 610=6 620=6 720=7 800=8 8888=. 9999=., gen(educ)

* age
gen age = agea

* gender is `gndr`

* R is foreign-born
recode brncntr 2=1 1=0 9=., gen(foreign)

* Either parent is foreign born
egen foreignp = anymatch(facntr mocntr), v(2)

* union member
recode mbtru 1/2=1 3/9=0, gen(union)

* income decile
recode hinctnta 77/99=., gen(income)

* attitude toward European integration
recode euftf 88/99=0, gen(europe)


* --- Ordered Logit and Probit models --- *

* ologit
ologit immpoor ideo educ age gndr europe income union foreign foreignp

* ologit with interactions
gen fe = foreign * educ
gen pe = foreignp * educ
ologit immpoor ideo educ age gndr europe income union foreign foreignp fe
ologit immpoor ideo educ age gndr europe income union foreign foreignp pe
ologit immpoor ideo educ age gndr europe income union foreign foreignp fe pe

gen fi = foreign * ideo
gen pi = foreignp * ideo
ologit immpoor ideo educ age gndr europe income union foreign foreignp fi
ologit immpoor ideo educ age gndr europe income union foreign foreignp pi
ologit immpoor ideo educ age gndr europe income union foreign foreignp fi pi

gen finc = foreign * income
gen pinc = foreignp * income
ologit immpoor ideo educ age gndr europe income union foreign foreignp finc
ologit immpoor ideo educ age gndr europe income union foreign foreignp pinc
ologit immpoor ideo educ age gndr europe income union foreign foreignp finc pinc


* oprobit
oprobit immpoor ideo educ age gndr europe income union foreign foreignp

* OLS
reg immpoor ideo educ age gndr europe income union foreign foreignp



* immigrants of same group
ologit immsame ideo educ age gndr europe income union foreign foreignp
ologit immsame ideo educ age gndr europe income union foreign foreignp finc
ologit immsame ideo educ age gndr europe income union foreign foreignp pinc
ologit immsame ideo educ age gndr europe income union foreign foreignp finc pinc




* --- Multinomial Outcomes --- *

* multinomial outcomes: vote choice in last election `prtvtcdk`
tab prtvtcdk
tab prtvtcdk, nolab
clonevar partychoice = prtvtcdk
recode partychoice 10/99=.

* make a binary to represent left/red versus right/blue
recode partychoice 1=1 2=1 3=0 4=1 5=0 6=0 7=0 8=0 9=1, gen(redchoice)
logit redchoice ideo educ age gndr europe income union foreign foreignp

* mlogit model
* implicitly takes lowest coded outcome as base (in this case Social Democrats)
mlogit partychoice ideo educ age gndr europe income union foreign foreignp
* we can switch that with the `baseoutcome` option:
* this uses Venstre as the baseline
mlogit partychoice ideo educ age gndr europe income union foreign foreignp, baseoutcome(7)
* coefficients represent changes relative to baseline category


* we could alternatively model this as a binary outcome:

* make a binary to represent voting for social democrats rather than venstre
recode partychoice 1=1 2=. 3=. 4=. 5=. 6=. 7=0 8=. 9=., gen(sdchoice1)
logit sdchoice1 ideo educ age gndr europe income union foreign foreignp


* make a binary to represent voting for social democrats rather than everyone else
recode partychoice 1=1 2=0 3=0 4=0 5=0 6=0 7=0 8=0 9=0, gen(sdchoice2)
logit sdchoice2 ideo educ age gndr europe income union foreign foreignp



* --- Count Outcomes --- *

* count variable: household size `hhmmb`
poisson hhmmb age educ
prvalue


* count variable: physical activity in last 7 days `physact`
recode physact 88=. 99=., gen(physical)

poisson physical age educ
display exp(1.33125)
prvalue, x(age=0 educ=0)

* count variable: number of employees supervised
recode njbspv 66666=0 88888/99999=., gen(employees)

poisson employees age educ
nbreg employees age educ, dispersion(mean)
