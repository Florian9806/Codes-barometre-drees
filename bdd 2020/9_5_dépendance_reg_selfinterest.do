cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do 9_2_self_interest




* Dépendance par age et sexe

g agesexe=1 if (sdagetr==1 | sdagetr==2) & sdsexe ==1
replace agesexe=2 if (sdagetr==1 | sdagetr==2) & sdsexe ==2
replace agesexe=3 if (sdagetr==3 | sdagetr==4) & sdsexe ==1
replace agesexe=4 if (sdagetr==3 | sdagetr==4) & sdsexe ==2
replace agesexe=5 if sdagetr==5 & sdsexe ==1
replace agesexe=6 if sdagetr==5 & sdsexe ==2



label define agesexe 1 "Homme 18-35ans" 2 "Femme 18-35ans" 3 "Homme 35-65ans" 4 "Femme 35-65ans" 5 "Homme +65ans" 6 "Femme +65ans"
label value agesexe agesexe

eststo clear
ologit Y i.agesexe c.sdrevtr i.statut c.diplome if bdd==6 & sdrevtr!=8
eststo em1 : margins, dydx(agesexe) post
coefplot em1, baselevels keep(*agesexe) recast(connected) vertical ylin(0) xlabel(, labsize(small) labcolor(black) angle(30)) ytitle(Effets marginaux) title() order(1.agesexe 3.agesexe 5.agesexe 2.agesexe 4.agesexe 6.agesexe sdsexe)


eststo clear
ologit Y i.sdagetr c.sdrevtr i.statut c.diplome if bdd==6 & sdrevtr!=8 & sdsexe==1
eststo em1 : margins, dydx(sdagetr) post
ologit Y i.sdagetr c.sdrevtr i.statut c.diplome if bdd==6 & sdrevtr!=8 & sdsexe==2
eststo em2 : margins, dydx(sdagetr) post
est store em2
coefplot em1 em2, baselevels keep(*.sdagetr) recast(connected) vertical ylin(0) xlabel(, labsize(small) labcolor(black) angle(30)) ytitle(Effets marginaux) title("Effet de l'âge sur le soutien à la dépendance" "par sexe") legend(order(2 "Homme" 4 "Femme"))
* pas de gros effets observé permettant d'induire les "bénéficiaires" des aide pour la dépendance (ou les futurs aides)



eststo clear
forvalues i=1/4{
eststo: reg Y2 i.sdagetr i.sdrevtr sdsexe i.diplome if bdd==`i'
}
coefplot est1 est2 est3 est4, keep(*sdagetr) recast(connected) baselevels xline(0) vertical
coefplot est1 est2 est3 est4, keep(*diplome) recast(connected) baselevels xline(0) vertical



**************************************************************************
**************** Regression Dépendance intéressement *********************
**************************************************************************
label variable sdrevtr "Tranche de revenus"

g aidant=(de7==1)
replace aidant=. if de7==.

eststo clear
eststo : ologit Y si_dep aidant#i.sdsexe c.sdrevtr i.sdagetr i.sdsexe i.sitfam if bdd==6 & (annee==2011 | inrange(annee, 2013, 2020)) & sdrevtr!=8
esttab using dependance_aidantes.tex, nonumbers eform mtitles("Aidantes et intéressement dépendance") scalar(r2_p r2_a) compress longtable f star(* 0.1 ** 0.05 *** 0.01) label replace


eststo clear
logit Y_bin si_dep i.aidant#i.sdsexe c.sdrevtr i.sdagetr i.sdsexe i.sitfam if bdd==6 & (annee==2011 | inrange(annee, 2013, 2020)) & sdrevtr!=8
eststo mar1 : margins, dydx(*) post
coefplot, xline(0) baselevels name(em, replace) drop(_cons)

eststo clear
ologit Y_bin i.si_dep aidant#i.sdsexe i.revtr2 i.sdagetr i.sdsexe i.sitfam if bdd==6 & (annee==2011 | inrange(annee, 2013, 2020))
eststo mar1 : margins si_dep aidant#sdsexe sdagetr revtr2, pr(outcome(1)) post
coefplot, name(predict_em, replace) headings("Pas bénéficiaire"="{bf: Bénéficiaire prestations}" Homme="{bf: Aidant.e par sexe}" 1.sdagetr="{bf:Tranche d'âge}" "Moins de 1900€ mensuel"="{bf: Tranche de revenus}") rename(0.si_dep="Pas bénéficiaire" 1.si_dep="Bénéficiaire" 0.aidant#1.sdsexe="Homme" 0.aidant#2.sdsexe="Femme" 1.aidant#1.sdsexe="Homme aidant" 1.aidant#2.sdsexe="Femme aidante" 1.revtr2="Moins de 1900€ mensuel" 2.revtr2="Entre 1900 et 3800€" 3.revtr2="Plus de 3800€") title("Probabilité prédite de reffuser une baisse des prestations" "dépendance", size(medium)) xline(.7631155)
* moyenne P(Y_bin=1)=.7631155


g fed=(de1==1)
replace fed=. if de1==.

eststo clear
logit fed i.si_dep aidant#i.sdsexe i.revtr2 i.sdagetr i.sdsexe i.sitfam if bdd==6
eststo mar1 : margins, dydx(*) post
coefplot mar1, baselevels xline(0) headings("Pas bénéficiaire"="{bf: Bénéficiaire prestations}" 1.sdagetr="{bf:Tranche d'âge}" "Moins de 1900€ mensuel"="{bf: Tranche de revenus}" 0.aidant="{bf:Aidant.e}" 1.sdsexe="{bf:Sexe}" 1.sitfam="{bf: Situation familiale}") rename(0.si_dep="Pas bénéficiaire" 1.si_dep="Bénéficiaire" 0.aidant#1.sdsexe="Homme" 0.aidant#2.sdsexe="Femme" 1.aidant#1.sdsexe="Homme aidant" 1.aidant#2.sdsexe="Femme aidante" 1.revtr2="Moins de 1900€ mensuel" 2.revtr2="Entre 1900 et 3800€" 3.revtr2="Plus de 3800€") 