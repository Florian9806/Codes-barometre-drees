
/*
Code pour fabriquer la bdd empiler sur les 7 branches. 
But avoir une seule variable PS13, nommée Y ou Y_bin (en binaire)
La variable est nettoyer des NSP ou NC
*/



do 6_0_ACM_codage_variables 

do 9_0_self_interest


gen bdd1=1
expand 2 if bdd1==1, gen(bdd2)
expand 2 if bdd2==1, gen(bdd3)
expand 2 if bdd3==1, gen(bdd4)
expand 2 if bdd4==1, gen(bdd5)
expand 2 if bdd5==1, gen(bdd6)
expand 2 if bdd6==1, gen(bdd7)


g bdd=1 if bdd1==1 & bdd2==0
forvalues i=2/6{
	local j = `i'+1
	replace bdd=`i' if bdd`i'==1 & bdd`j'==0
}
replace bdd=7 if bdd7==1


g Y = ps13_a_1 if bdd==1 & inrange(ps13_a_1,1,4)
forvalues i=2/7{
	replace Y = ps13_a_`i' if bdd==`i' & inrange(ps13_a_`i', 1, 4)
}

label define Y 1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout"
label value Y Y

g si_am=(bdd==1)

g si_retr= (bdd==2 & sdres_5==1) /* ou statut==7 ? */


g si_fam= (bdd==3 & inrange(sdnbenf,2,10) ) /* famille avec 2 enfants ou plus*/

* SI famille prenant en compte (approximativement) l'effet du revenu dans la répartition des allocations familiales
g si_fam_rev= (bdd==3 & (inrange(sdnbenf, 3, 10) | (sdrevtr!=7 & sdnbenf==2) | (sdnbenf==1 & sdrevtr==1)) )

g si_fam2 = (bdd==3 & sdres_8==1)

g si_chom= (bdd==4 & sdres_4==1)
g si_chom2 = (bdd==4 & statut==5)


g si_handi = (bdd==5 & sdres_10==1 & inrange(sdagetr, 1, 4))

g si_dep=(bdd==6 & sdres_10==1 & sdagetr==5)

g si_logt= (bdd==7 & sdres_9==1)

g si_f= (bdd==3 & inrange(sdnbenf,2,10) ) /* famille avec 2 enfants ou plus*/

g si = si_am + si_retr + si_fam2 + si_chom + si_handi + si_dep + si_logt


g Y_bin = (inrange(Y,3,4))
replace Y_bin=. if Y==.

* corrections dûes au manque de données
replace si=. if (bdd==3 | bdd==5) & inrange(annee, 2000, 2012)
replace si=. if bdd==6 & inrange(annee, 2000, 2003)
replace si=. if bdd==7 & inrange(annee, 2000, 2014)


* Proximité chomage (a des connaissances aux chômage indemnisé ou non)
g proxim_chom=(inrange(sdproxim_1, 2, 8) | inrange(sdproxim_2, 2,8))

g proxim_chom_2 = 0 if (sdproxim_1==1 | sdproxim_1==9) & (sdproxim_2==1 | sdproxim_2==9)
replace proxim_chom_2 =1 if inrange(sdproxim_1,2,8)
replace proxim_chom_2=2 if inrange(sdproxim_2, 2,8)

g revtr2 = 1 if inrange(sdrevtr,1,3)
replace revtr2 =2 if inrange(sdrevtr,4,5)
replace revtr2=3 if inrange(sdrevtr,6,7)


