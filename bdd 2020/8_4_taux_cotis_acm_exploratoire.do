cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"


do 8_1_taux_cotis


* Peu utilisé dans le rapport, exploratoire

********************************************************************************
* CA pour les 4 branches (création des variables latentes)
********************************************************************************





* générer une autre variable pour garder la ps13 intact pour les autres régressions


/*
g ps13_1=ps13_a_1 if inrange(ps13_a_1,1,4)
g ps13_2= ps13_a_2 if inrange(ps13_a_2,1,4)
g ps13_3=ps13_a_3 if inrange(ps13_a_3,1,4)
g ps13_4=ps13_a_4  if inrange(ps13_a_4,1,4)



replace ps13_1=2 if ps13_a_1==1
replace ps13_2=2 if ps13_a_2==1
replace ps13_3=2 if ps13_a_3==1
replace ps13_4=2 if ps13_a_4==1
*/

replace ps13_a_1=5 if ps13_a_1==6
replace ps13_a_2=5 if ps13_a_2==6
replace ps13_a_3=5 if ps13_a_3==6
replace ps13_a_4=5 if ps13_a_4==6



mca ps13_a_1 PS1_1 ps2_ab, sup(sdagetr) normalize(principal)
mcaplot, overlay origin mlabsize(small) name(AM, replace)
predict AMdim1 AMdim2 if e(sample)

mca ps13_a_2 PS1_2 ps2_ab, sup(sdagetr) normalize(principal)
mcaplot, overlay origin mlabsize(small) name(retr, replace)
predict retraitedim1 retraitedim2 if e(sample)

mca ps13_a_3 PS1_3 ps2_ab, sup(sdagetr) normalize(principal)
mcaplot, overlay origin mlabsize(small) name(famille, replace)
predict famdim1 famdim2 if e(sample)

mca ps13_a_4 PS1_4 ps2_ab, sup(sdagetr) normalize(principal)
mcaplot, overlay origin mlabsize(small) name(chomage, replace)
predict chomdim1 chomdim2 if e(sample)


do 8_3_2_taux_cotis_agrégé_reg

g Y_ps1 = PS1_1 if bdd==1
replace Y_ps1 = PS1_2 if bdd==2
replace Y_ps1 = PS1_3 if bdd==3
replace Y_ps1 = PS1_4 if bdd==4

mca Y_ps1 Y ps3_ab
mcaplot, overlay
predict Y3_1 Y3_2 if e(sample)


label define bdd 1 "AM" 2 "Retraite" 3 "Famille" 4 "Chômage"
label value bdd bdd
histogram Y3_1, by(bdd, title("Répartition des points sur la première dimension par branche" "(en pourcentage)") legend(off) note("")) bin(10) percent addlabel addlabopts(mlabsize(small) mlabformat(%9.0f))  ytitle("") xtitle("") 
* resortir les regressions là dessus




g Y2= AMdim1 if bdd==1
replace Y2=retraitedim1 if bdd==2
replace Y2=famdim1 if bdd==3
replace Y2=chomdim1 if bdd==4






