* Outline of .do File for Session 07-02

* --- Some Covariates --- *

* left-right scale
recode lrscale 88=. 99=., gen(ideo)

* education
recode edulvlb 0=1 113=1 213=2 229=3 313=3 322=4 520=5 610=6 620=6 720=7 800=8 8888=. 9999=., gen(educ)

* age
gen age = agea

* gender is variable `gndr`

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

* Attitudes toward immigration levels
recode impcntr 1=4 2=3 3=2 4=1 8/9=., gen(immpoor)
recode imdfetn 1=4 2=3 3=2 4=1 8/9=., gen(immsame)
recode imsmetn 1=4 2=3 3=2 4=1 8/9=., gen(immdiff)

* ologit

* oprobit

* OLS


* --- Multinomial Outcomes --- *

* party choice
clonevar partychoice = prtvtcdk
recode partychoice 10/99=.

* mlogit


* new variable: 1sdchoice1
* logit

* new variable: 1sdchoice2
* logit



* --- Count Outcomes --- *

* count variable: number of employees supervised
recode njbspv 66666=0 88888/99999=., gen(employees)

* poisson

