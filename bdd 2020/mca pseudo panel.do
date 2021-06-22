cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"



*****************
*mca pseudo panel
*****************
replace ps2_ab=. if ps2_ab==4
replace ps16_ab=. if ps16_ab==3 
replace ps2_cd=. if ps2_cd==4 
replace ps16_cd=. if ps16_cd==3 
replace ps1_ab_1=. if ps1_ab_1==5 
replace ps1_ab_2=. if ps1_ab_2==5 
replace ps1_ab_3=. if ps1_ab_3==5 
replace ps1_ab_4=. if ps1_ab_4==5 
replace ps1_cd_1=. if ps1_cd_1==5
replace ps1_cd_2=. if ps1_cd_2==5 
replace ps1_cd_3=. if ps1_cd_3==5 
replace ps1_cd_4=. if ps1_cd_4==5
replace ps15_ab_1=. if ps15_ab_1==5
replace ps15_ab_2=. if ps15_ab_2==5
replace ps15_ab_3=. if ps15_ab_3==5
replace ps15_cd_1=. if ps15_cd_1==5
replace ps15_cd_2=. if ps15_cd_2==5
replace ps15_cd_3=. if ps15_cd_3==5

label drop ps1_ab_4
label define ps1_ab_4 1 "Contributif" 2 "Minima" 3 "Universel" 4 "Mixte"
label value ps1_ab_1 ps1_ab_4
label value ps1_ab_2 ps1_ab_4
label value ps1_ab_3 ps1_ab_4
label value ps1_ab_4 ps1_ab_4
label value ps1_cd_1 ps1_ab_4
label value ps1_cd_2 ps1_ab_4
label value ps1_cd_3 ps1_ab_4
label value ps1_cd_4 ps1_ab_4

label drop ps2_ab
label define ps2_ab 1 "Plus de cotise entreprises" 2 "Moins de cotise entreprise" 3 "Ni plus ni moins de cotise entreprise"
label value ps2_ab ps2_ab
label value ps2_cd ps2_ab

label define y_3 1 "Y=1" 2 "Y=2" 3 "Y=3"
label value  y_AM_3 y_3
label value  y_Chomage_3 y_3
label value  y_Retraite_3 y_3
label value  y_Famille_3 y_3

g retraite = (PCS==5)

grstyle init
grstyle set mesh, compact


mca ps1_ab_4 ps2_ab ps16_ab if sdsplit==1 & ps1_ab_4!=5, sup(y_Chomage_3 retraite)
mcaplot, overlay name(G1, replace) title(Questionnaire A) msize(vsmall) mlabsize(vsmall) origin

mca ps1_ab_4 ps2_ab ps16_ab if sdsplit==2 & ps1_ab_4!=5, sup(y_Chomage_3 retraite)
mcaplot, overlay name(G2, replace) title(Questionnaire B)  msize(vsmall) mlabsize(vsmall) origin

mca ps1_cd_4 ps2_cd ps16_cd if sdsplit==3 & ps1_ab_4!=5, sup(y_Chomage_3 retraite)
mcaplot, overlay name(G3, replace) title(Questionnaire C)  msize(vsmall) mlabsize(vsmall) origin

mca ps1_cd_4 ps2_cd ps16_cd if sdsplit==4 & ps1_ab_4!=5, sup(y_Chomage_3 retraite)
mcaplot, overlay name(G4, replace) title(Questionnaire D)  msize(vsmall) mlabsize(vsmall) origin

grc1leg G1 G2 G3 G4, legendfrom(G1)






mca ps1_ab_1 ps2_ab ps16_ab if sdsplit==1 & ps1_ab_1!=5, sup(y_AM_3 PCS)
mcaplot, overlay name(G1, replace) title(Questionnaire A)

mca ps1_ab_1 ps2_ab ps16_ab if sdsplit==2 & ps1_ab_1!=5, sup(y_AM_3 PCS)
mcaplot, overlay name(G2, replace) title(Questionnaire B)

grc1leg G1 G2, legendfrom(G1)



mca ps16_ab ps1_ab_2 ps2_ab if sdsplit==1 & ps1_ab_2!=5, sup(y_Retraite_3 PCS)
mcaplot, overlay name(G1, replace) title(Questionnaire A)

mca ps16_ab ps1_ab_2 ps2_ab if sdsplit==2 & ps1_ab_2!=5, sup(y_Retraite_3 PCS)
mcaplot, overlay name(G2, replace) title(Questionnaire B)

grc1leg G1 G2, legendfrom(G1)



mca ps1_ab_4 ps2_ab ps16_ab if annee==2020 , sup(PCS)
mcaplot, overlay name(G1, replace) title(Questionnaire A et B) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))

mca ps1_cd_4 ps2_cd ps16_cd if annee==2020 , sup(PCS)
mcaplot, overlay name(G2, replace) title(Questionnaire C et D) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))


g ps1ab4 = 1 if ps1_ab_4==1 /*contrib*/
replace ps1ab4 = 2 if ps1_ab_4==3 /*universel*/
replace ps1ab4 = 3 if ps1ab4==. /*autres*/
label define ps1ab4 1  "Contributif" 2 "Universel" 3 "Autre"
label value ps1ab4 ps1ab4


g ps1cd4 = 1 if ps1_cd_4==1 /*contrib*/
replace ps1cd4 = 2 if ps1_cd_4==3 /*universel*/
replace ps1cd4 = 3 if ps1cd4==. /*autres*/
label define ps1cd4 1  "Contributif" 2 "Universel" 3 "Autre"
label value ps1cd4 ps1cd4


mca ps1ab4 ps2_ab ps16_ab if annee==2020, sup(diplome3 sdnivie sdagetr)
mcaplot, overlay name(G1, replace) title(Questionnaire A et B) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
*predict ab1 ab2 if annee==2020 & (sdsplit==1 | sdsplit==2)
scatter ab2 ab1

mca ps1cd4 ps2_cd ps16_cd if annee==2020, sup(diplome3 sdnivie sdagetr)
mcaplot, overlay name(G2, replace) title(Questionnaire C et D) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
*predict cd1 cd2 if annee==2020 & (sdsplit==3 | sdsplit==4)
scatter cd2 cd1


mca ps1ab4 ps2_ab ps16_ab if annee==2019, sup(diplome3 sdnivie sdagetr)
mcaplot, overlay name(G3, replace) title(Questionnaire A et B) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
*predict ab19_1 ab19_2 if annee==2019
scatter ab19_2 ab19_1


tw (scatter ab2 ab1, mstyle(p1)) (scatter cd2 cd1, mstyle(p2)) (scatter ab19_2 ab19_1, mstyle(p3)), legend(order(1 "QAB 2020" 2 "QCD 2020" 3 "QAB2019"))


mca ps1ab4 ps2_ab ps16_ab if annee==2019 | annee==2020, sup(diplome3 sdnivie sdagetr)
mcaplot, overlay name(G3, replace) title(Questionnaire A et B 2019 2020) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
predict ab1920_1 ab1920_2 if annee==2019 | (annee==2020 & (sdsplit==1|sdsplit==2))
scatter ab1920_2 ab1920_1
tw (scatter ab1920_2 ab1920_1 ) (lfit ab1920_2 ab1920_1) (qfit ab1920_2 ab1920_1)
tw (histogram ab1920_1 if annee==2019, lcol(pink)) (histogram ab1920_1 if annee==2020, lcol(blue)), legend(order(1 "2019 " 2 "2020"))
tw (histogram ab1920_2 if annee==2019, lcol(pink)) (histogram ab1920_2 if annee==2020, lcol(blue)), legend(order(1 "2019 " 2 "2020"))

tw (kdensity ab1920_1 if PCS==1, lcol(pink)) (kdensity ab1920_1 if PCS==2, lcol(blue)) (kdensity ab1920_1 if PCS==3, lcol(green)) (kdensity ab1920_1 if PCS==4, lcol(orange)) (kdensity ab1920_1 if PCS==5, lcol(black)), legend(order(1 "Indep " 2 "Cadre" 3 "Ouvrier/employé" 4 "Autre inactif" 5 "Retraité"))
tw (kdensity ab1920_2 if PCS==1, lcol(pink)) (kdensity ab1920_2 if PCS==2, lcol(blue)) (kdensity ab1920_2 if PCS==3, lcol(green)) (kdensity ab1920_2 if PCS==4, lcol(orange)) (kdensity ab1920_2 if PCS==5, lcol(black)), legend(order(1 "Indep " 2 "Cadre" 3 "Ouvrier/employé" 4 "Autre inactif" 5 "Retraité"))

tw (histogram ab1920_1 if annee==2020 & sdsplit==1, lcol(pink)) (histogram ab1920_1 if annee==2020 & sdsplit==2, lcol(blue)), legend(order(1 "A " 2 "B"))




mca ps1ab4 ps2_ab ps16_ab if annee==2020, sup(diplome3 sdnivie sdagetr y_Chomage_3)
mcaplot, overlay name(G3, replace) title(Questionnaire A et B 2020) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
predict dimchom1 dimchom2 if annee==2020 & (sdsplit==1|sdsplit==2)

drop G H
mca ps15_ab_1 ps16_ab ps2_ab ps1ab4 if annee==2020, sup(ps15_ab_3)
mcaplot, overlay mlabgap(1) mlabpos(6) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3)) yneg
predict G H if annee==2020 & (sdsplit==1 | sdsplit==2)
tw (scatter H G if ps1ab4==1, msize(vsmall) m(square)) (scatter H G if ps1ab4==2, msize(vsmall) m(triangle)) (scatter H G if ps1ab4==3, msize(small) m(+))(lfit H G) (qfit H G)
tw (scatter H G if ps2_ab==1, msize(vsmall) m(square)) (scatter H G if ps2_ab==2, msize(vsmall) m(triangle)) (scatter H G if ps2_ab==3, msize(small) m(+))(lfit H G) (qfit H G)
tw (histogram H, vertical) (histogram G, horizontal)


