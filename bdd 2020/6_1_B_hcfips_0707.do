cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "6_1_ACM_PP"




**************
* ACM hcfips
**************
label drop ps1_ab_4
label define ps1_ab_4 1 "A ceux qui cotisent" 2 "A ceux qui en ont besoin" 3 "A tout le monde" 4 "Ceux qui cotisent et minimum pour les autres"
label value ps1_ab_4 ps1_ab_4
label drop ps2_ab
label define ps2_ab 1 "plus de cotisations" 2 "moins de cotisations" 3 "pas de changement"
label value ps2_ab ps2_ab
replace ps13_a_4=5 if ps13_a_4==6
replace ps13_a_4=2 if ps13_a_4==1

label define sdnivie 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5"
label value sdnivie sdnivie
label drop sdstat
label define sdstat 1 "Salarié du public" 2 "Salarié du privé" 3 "Indépendant sans salarié" 4 "Employeur" 5 "Chomeur" 6 "Inactif" 7 "Autre"
label value sdstat sdstat
label drop ps13_a_4
label define ps13_a_4 2 "Oui" 3 "Non plutôt pas" 4 "Non pas du tout" 5 "NSP"
label value ps13_a_4 ps13_a_4

drop if sdstat==7

mca ps1_ab_4 ps2_ab ps3_ab ps16_ab ps13_a_4 if annee==2019 | annee==2020, dim(4) sup(sdstat sdnivie)
mcaplot (ps1_ab_4, mcol(red) mlabcol(red) msymbol(triangle) mlabpos(6)) (ps13_a_4, mcol(purple) mlabcol(purple) msymbol(D) mlabpos(12)), overlay title(Correspondance des réponses sur l'assurance chômage) msize(vsmall) origin legend(size(small) position(3)) maxlength(30) mlabsize(small) legend(order(1 "Selon vous, à qui doivent bénéficier les allocations chômage?" 2 "Accepteriez-vous une baisse des allocations chômage" "en échange d'une baisse de vos impôts" ) rows(2) cols(1) pos(6))
mcaplot (ps2_ab, mcol(blue) mlabcol(blue) msymbol(square) mlabpos(9)) (ps3_ab, mcol(red) mlabcol(red) msymbol(o)) (ps16_ab, mcol(black) mlabcol(black) msymbol(+) mlabpos(6)), overlay title("Correspondance des réponses sur les dépenses" "de protection sociale") msize(vsmall) origin legend(size(small) position(3)) maxlength(30) mlabsize(small) legend(order(1 "Actuellement, les entreprises cotisent pour la protection sociale." "Avec laquelle de ces propositions suivantes, êtes-vous le plus d’accord ?" 2 "La France consacre environ le tiers du revenu national au financement " "de la protection sociale. Considérez-vous que c'est?" 3 "Pour vous quel est le plus important?" ) rows(5) cols(1) pos(6))
mcaplot (sdstat, mcol(blue) mlabcol(blue) msymbol(square) mlabpos(10) mlabsize(vsmall) msize(tiny) mlabangle(20)) (sdnivie, mcol(red) mlabcol(red) msymbol(o) mlabpos(6) mlabsize(small) msize(small)), overlay title(Catégories socio-démographiques) origin legend(size(small) position(3)) maxlength(20) legend(order(1 "Statut d'emploi" 2  "Quintiles de niveau de vie mensuel imputé" ) rows(5) cols(1) pos(6))
predict A B C D if e(sample)
mcaplot (sdstat, mcol(blue) mlabcol(blue) msymbol(square) mlabpos(10) mlabsize(vsmall) msize(tiny) mlabangle(20)) (pcs8, mcol(red) mlabcol(red) msymbol(o) mlabpos(3) mlabsize(vsmall) msize(vsmall) mlabangle(20)) (sdres_6, mcol(green) mlabcol(green) msymbol(D) mlabpos(12) mlabsize(vsmall) msize(vsmall) mlabangle(0)) (sdres_7, mcol(black) mlabcol(black) msymbol(+) mlabpos(12) mlabsize(vsmall) msize(vsmall) mlabangle(0)), maxlength(20) origin legend(order(1 "Statut d'emploi" 2 "PCS" 3 "Actifs financiers" 4 "Revenus immobiliers")) overlay

cluster kmeans A B if annee==2019 | annee== 2020, k(3) measure(L2) start(krandom)
tw (scatter B A if _clus_1==1, mcolor(red) msize(vsmall)) (scatter B A if _clus_1==2, mcolor(green) msize(vsmall)) (scatter B A if _clus_1==3, mcolor(blue) msize(vsmall)), xline(0) yline(0)

*bdd acm sur R
/*
keep if annee==2019 | (annee==2020 & sdsplit==1)
save data_acmR.dta, replace
*/


* a changer de code /!\ /!\
replace ps13_a_1=5 if ps13_a_1==6
replace ps13_a_2=5 if ps13_a_2==6
replace ps13_a_3=5 if ps13_a_3==6
replace ps13_a_4=5 if ps13_a_4==6
replace ps13_a_1=2 if ps13_a_1==1
replace ps13_a_2=2 if ps13_a_2==1
replace ps13_a_3=2 if ps13_a_3==1
replace ps13_a_4=2 if ps13_a_4==1

forvalues i=1/4{
 g PS1_`i'=ps1_ab_`i'
 replace PS1_`i'=. if PS1_`i'==5 | PS1_`i'==4
}

