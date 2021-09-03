cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do 9_2_self_interest



*******************************************************************************
******************* Regressions self interest**********************************
*******************************************************************************
* si retraité= membre d'un foyer qui recoit des pensions de retraite même s'il n'est pas retraité.
* effet individuel, intéressement, comparaison am/famille , proximité du chômage

eststo clear
xtset ident
eststo : xtologit Y i.bdd si if annee>=2013
eststo : xtologit Y i.bdd si_am si_retr si_fam2 si_chom si_dep si_handi si_logt if annee>=2013
xtset ident
eststo : xtreg Y i.bdd si if annee>=2013, fe
eststo : xtreg Y i.bdd si_am si_retr si_fam2 si_chom si_handi si_dep si_logt if annee>=2013, fe
esttab , label scalar(r ll converged) star(* 0.1 ** 0.05 *** 0.01)
esttab using reg_si_agreg.tex, nonumbers mtitles("SI agrégé ologit" "SI séparé ologit" "SI agrégé ols" "SI séparé ols") scalar(r2_p r2 r2_a) compress longtable f  not star(* 0.1 ** 0.05 *** 0.01) replace




eststo clear
forvalues i=1/7 {
	eststo: qui ologit Y c.sdagetr c.sdrevtr i.sdsexe i.statut c.diplome if bdd==`i' & sdrevtr!=8 & inrange(annee, 2013, 2020)
	}
esttab, label scalar(r2_p) star(* 0.1 ** 0.05 *** 0.01) eform

* Sauvegarde des résultats dans table logit_soutien.tex
esttab using logit_soutien.tex, nonumbers eform mtitles("AM" "Retraite" "Famille" "Chomage"  "Handicap" "Dépendance" " Logement") scalar(r2_p r2_a) compress longtable f star(* 0.1 ** 0.05 *** 0.01) label replace
esttab , label scalar(r2_p) star(* 0.1 ** 0.05 *** 0.01)


* or  du statut sur 5 branches (retiré AM car comme retraite et dépendance car comme handicap pour plus de lisibilité).


coefplot est2 est3 est4 est5 est7 , ///
	keep(*.statut) xline(0) eform ///
	legend(order(1 "Retraite" 3 "Famille" 5 "Chômage" 7 "Handicap" 9 "Logement")) ///
	headings(2.statut= "{bf: Base: salarié du public}")  ///
	title("Statut d'emploi et soutien à la protection sociale") subtitle(Odds ratio)

	
* statut AM retraite -> SI et statut -> pose pb d'identification
coefplot est1 est2, ///
	keep(*.statut) xline(1) eform ///
	legend(order(2 "Assurance maladie" 4 "Retraite")) ///
	headings(2.statut= "{bf: Base: salarié du public}")  ///
	title("Statut d'emploi et soutien à la protection sociale") subtitle(Odds ratio) 

* statut chomage famille
coefplot est3 est4, ///
	keep(*.statut) xline(1) eform ///
	legend(order(1 "Famille" 3 "Chômage")) ///
	headings(2.statut= "{bf: Base: salarié du public}")  ///
	title("Statut d'emploi et soutien à la protection sociale") subtitle(Odds ratio)

* autres variables 7 branches
coefplot est1 est2 est3 est4 est5 est6 est7 , ///
	keep(sdagetr sdrevtr *.sdsexe diplome) xline(1) eform ///
	legend(order(1 "Santé" 3 "Retraite" 5 "Famille" 7 "Chômage" 9 "Handicap" 11 " Dépendance" 13 "Logement")) ///
	title("") subtitle(Odds ratio) nolabel ///
	rename(2.sdsexe="Femme" diplome="Diplôme"  sdrevtr="Tranche de revenu" sdagetr = "Tranche d'âge")
	
* AM famille (oppositions entre am retraite vs famille logement avec handicap chomage et dépendance entre deux)
coefplot est1 est3, ///
	keep(sdagetr sdrevtr *.sdsexe diplome) xline(1) eform ///
	legend(order(1 "Santé" 3 "Famille")) ///
	title("Effets différenciés du revenu et du diplôme") subtitle(Odds ratio) ///
	nolabel rename(2.sdsexe="Femme" diplome="Diplôme"  sdrevtr="Tranche de revenu" sdagetr = "Tranche d'âge")

	
* la meme mais avec sdnivie

eststo clear
forvalues i=1/7 {
	eststo: qui ologit Y c.sdagetr c.sdnivie i.sdsexe i.statut c.diplome if bdd==`i' & sdnivie!=. & inrange(annee, 2013, 2020)
}

coefplot est1 est2 est3 est4 est5 est6 est7 , ///
	keep(sdagetr sdnivie *.sdsexe diplome) xline(1) eform ///
	legend(order(1 "Santé" 3 "Retraite" 5 "Famille" 7 "Chômage" 9 "Handicap" 11 " Dépendance" 13 "Logement")) ///
	title("") subtitle(Odds ratio) nolabel ///
	rename(2.sdsexe="Femme" diplome="Diplôme"  sdnivie="Quintile de niveau de vie" sdagetr = "Tranche d'âge")


* EM du self interest :


eststo clear
forvalues i=2/7 {
	qui ologit Y i.si c.sdagetr c.sdrevtr i.sdsexe c.diplome if bdd==`i' & sdrevtr!=8 & inrange(annee, 2013, 2020)
	eststo : margins si, predict(outcome(4)) post
	}
	
coefplot est1, bylabel(Retraite) || est2, bylabel(Famille) || est3, bylabel(Chômage) || est4, bylabel(Handicap) || est5, bylabel(Dépendance) || est6, bylabel(Logement) ||, recast(connected) vertical rename(1.si="{bf:Bénéficiaire actuel}" 0.si="Non-bénéficiaire") sort mlabel mlabpos(11) mlabstyle(format(%9.2f))



* sortie de la table de régression
eststo clear
forvalues i=2/7 {
	eststo : qui ologit Y i.si c.sdagetr c.sdrevtr i.sdsexe c.diplome if bdd==`i' & sdrevtr!=8 & inrange(annee, 2013, 2020)
	}
esttab using logit_SI.tex, nonumbers mtitles("Retraite" "Famille" "Chomage"  "Handicap" "Dépendance" " Logement") scalar(r2_p) compress longtable f star(* 0.1 ** 0.05 *** 0.01) label replace




qui ologit Y i.si c.sdagetr c.sdrevtr i.sdsexe i.statut c.diplome if bdd==4 & sdrevtr!=8 & inrange(annee, 2013, 2020)
margins sdsexe, predict(outcome(1))
margins sdsexe, predict(outcome(4))


	
qui ologit Y i.si c.sdagetr i.sdrevtr i.sdsexe i.statut c.diplome if bdd==4 & sdrevtr!=8 & inrange(annee, 2013, 2020)
margins i.sdrevtr, predict(outcome(1))
margins i.sdrevtr, predict(outcome(4))

********************************************************************************
* Hiérarchie des effets ((pas très intéressant)
********************************************************************************

/*
eststo clear
forvalues i=1/7 {
	eststo est_si_`i' : qui ologit Y si if bdd==`i' & sdrevtr!=8 & inrange(annee, 2015, 2020)
}

forvalues i=1/7 {
	eststo est_age_`i' : qui ologit Y c.sdagetr if bdd==`i' & sdrevtr!=8 & inrange(annee, 2015, 2020)
}

forvalues i=1/7 {
	eststo est_rev_`i' : qui ologit Y c.sdrevtr if bdd==`i' & sdrevtr!=8 & inrange(annee, 2015, 2020)
}


forvalues i=1/7 {
	eststo est_sexe_`i' : qui ologit Y sdsexe if bdd==`i' & sdrevtr!=8 & inrange(annee, 2015, 2020)
}

forvalues i=1/7 {
	eststo est_statut_`i' : qui ologit Y i.statut if bdd==`i' & sdrevtr!=8 & inrange(annee, 2015, 2020)
}

forvalues i=1/7 {
	eststo est_dipl_`i' : qui ologit Y diplome if bdd==`i' & sdrevtr!=8 & inrange(annee, 2015, 2020)
}

forvalues i=1/7 {
	eststo est_nivi_`i' : qui ologit Y sdnivie if bdd==`i' & sdrevtr!=8 & inrange(annee, 2015, 2020)
}

esttab est_*_1, scalar(aic bic ar2 pr2 ll)
esttab est_*_2, scalar(aic bic ar2 pr2 ll)
esttab est_*_3, scalar(aic bic ar2 pr2 ll)
esttab est_*_4,scalar(aic bic ar2 pr2 ll)
esttab est_*_5, scalar(aic bic ar2 pr2 ll)
esttab est_*_6, scalar(aic bic ar2 pr2 ll)
esttab est_*_7, scalar(aic bic ar2 pr2 ll)
***** Effet diplome et revenu dominant. Mais pas hyper intéressant non plus: 
* le diplome explique + de variance que le revenu mais a fortiori 
* c'est du fait de l'effet revenu approximé par l'effet diplôme
*/



* Effet marginaux de l'intéressement 
* Graphe important
eststo clear
eststo: ologit Y i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==1 & sdrevtr!=8 & annee>=2013
margins sdagetr, pr(outcome(1)) pr(outcome(2)) pr(outcome(3)) pr(outcome(4))
marginsplot
margins sdrevtr, pr(outcome(1)) pr(outcome(2)) pr(outcome(3)) pr(outcome(4))
marginsplot
margins sdsexe, pr(outcome(1)) pr(outcome(2)) pr(outcome(3)) pr(outcome(4))
marginsplot



******************************************************************************
**************************effet marginaux, logit binaire.*************************
***************************************************************************

* Effet marginaux du self interest
eststo clear
forvalues i=2/7 {
	qui : logit Y_bin si c.sdagetr c.sdrevtr i.sdsexe i.statut c.diplome if bdd==`i' & sdrevtr!=8
	eststo ma`i' : margins, dydx(si) post
}
esttab ma*, label scalar(r2_p) star(* 0.1 ** 0.05 *** 0.01) mtitles("Retraite" "Famille" "Chomage"  "Handicap" "Dépendance" " Logement")
esttab using margins_si.tex, nonumbers eform mtitles("Retraite" "Famille" "Chomage"  "Handicap" "Dépendance" " Logement") scalar(r2_p r2_a) compress longtable f star(* 0.1 ** 0.05 *** 0.01) label replace
esttab , label scalar(r2_p) star(* 0.1 ** 0.05 *** 0.01)


eststo clear
forvalues i=1/4{
qui: ologit Y_bin i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_age: margins sdagetr, pr(outcome(1)) post
qui: ologit Y_bin i.sdagetr i.diplome i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_dipl: margins diplome, pr(outcome(1)) post
qui: ologit Y_bin i.sdagetr i.sdrevtr i.diplome i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_diplrev: margins diplome sdrevtr, pr(outcome(1)) post
qui : ologit Y_bin i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_rev: margins sdrevtr, pr(outcome(1)) post
qui: ologit Y_bin i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_sexe: margins sdsexe, pr(outcome(1)) post
qui : ologit Y_bin i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_statut: margins statut, pr(outcome(1)) post
}

coefplot em*_sexe, recast(connected) vertical ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(, labcolor(black))

coefplot em*_age, recast(connected) vertical ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(, labcolor(black))
	
coefplot em*_rev, recast(connected) ///
	vertical xlabel(,  labsize(tiny) labcolor(black) angle(45)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) 
	
coefplot em*_statut,  recast(connected) vertical ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(,  labsize(small) labcolor(black) angle(10)) sort

coefplot em*_dipl, recast(connected) ///
	vertical xlabel(,  labsize(tiny) labcolor(black) angle(45)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) 

*
coefplot em*_diplrev, keep(*diplome) ///
	vertical xlabel(,  labsize(tiny) labcolor(black) angle(45)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) recast(connected) 
coefplot em*_diplrev, keep(*sdrevtr) ///
	vertical xlabel(,  labsize(tiny) labcolor(black) angle(45)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) recast(connected) 

	
* effets marginaux ologit, predict outcome(4)
	
	
eststo clear
forvalues i=1/4{
qui: ologit Y i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_age: margins sdagetr, pr(outcome(4)) post
qui : ologit Y i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_rev: margins sdrevtr, pr(outcome(4)) post
qui: ologit Y i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_sexe: margins sdsexe, pr(outcome(4)) post
qui : ologit Y i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_statut: margins statut, pr(outcome(4)) post
}

coefplot em*_sexe, recast(connected) vertical ///
	title("Effet marginal du sexe" "Probabilité de refuser strictement une baisse de prestations" , size(medium)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(, labcolor(black)) 

coefplot em*_age, recast(connected) vertical ///
	title("Effet marginal de l'âge" "Probabilité de refuser strictement une bausse de prestations", size(medium)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(, labcolor(black)) 
	
coefplot em*_rev, recast(connected) ///
	title("Effet marginal du revenu" "Probabilité de refuser strictement une bausse de prestations", size(medium)) ///
	vertical xlabel(,  labsize(tiny) labcolor(black) angle(45)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) 
	
coefplot em*_statut,  recast(connected) vertical ///
	title("Effet marginal du statut" "Probabilité de refuser strictement une baisse de prestations", size(medium)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(,  labsize(small) labcolor(black) angle(10)) sort
	
	
	
	


*********************************************************************************
* Effets marginaux du revenu et de l'âge (AM / Famille)*************************
* puis chomage statut
*********************************************************************************
eststo clear
logit Y_bin si c.sdagetr i.sdrevtr i.sdsexe i.statut c.diplome if bdd==1 & sdrevtr!=8 & annee>=2013
eststo em1 : margins, dydx(sdrevtr) post

logit Y_bin si c.sdagetr i.sdrevtr i.sdsexe i.statut c.diplome if bdd==3 & sdrevtr!=8 & annee>=2013
eststo em2 : margins, dydx(sdrevtr) post

coefplot em1 em2, baselevels keep(*sdrevtr) recast(connected) vertical yline(0) xlabel(,  labsize(tiny) labcolor(black) angle(30)) ytitle(Effets marginaux) title("Effet du revenu sur le soutien à l'Assurance maladie" "et aux allocations familiales") legend(order(2 "Assurance maladie" 4 "Allocations familiales"))


eststo clear
logit Y_bin si i.sdagetr c.sdrevtr i.sdsexe c.diplome if bdd==1 & sdrevtr!=8 & annee>=2013
eststo em1: margins, dydx(sdagetr) post

logit Y_bin si i.sdagetr c.sdrevtr i.sdsexe c.diplome if bdd==3 & sdrevtr!=8 & annee>=2013
eststo em2 : margins, dydx(sdagetr) post

logit Y_bin si i.sdagetr c.sdrevtr i.sdsexe c.diplome if bdd==4 & sdrevtr!=8 & annee>=2013
eststo em3 : margins, dydx(sdagetr) post

coefplot em1 em2 em3, baselevels keep(*sdagetr) recast(connected) vertical yline(0) xlabel(,  labcolor(black) angle(20)) ytitle(Effets marginaux) title("Effet de l'âge sur le soutien à l'Assurance maladie" "et aux allocations familiales et chômage") legend(order(2 "Assurance maladie" 4 "Allocations familiales" 6 "Allocations chômage"))


* chomage et statut d'emploi: 
* puis "connaissez-vous qq'un qui est au chômage?"
* sans contrôle par l'âge

eststo clear
logit Y_bin i.statut c.diplome c.sdrevtr c.sdagetr i.sdsexe if bdd==4 & sdrevtr!=8
eststo em1 : margins, dydx(*statut) post
coefplot em1, baselevels keep(*statut) recast(connected) vertical ylin(0) xlabel(, labcolor(black) angle(20)) ytitle(Effets marginaux) title("Effet du statut sur le soutien aux allocations chômage") sort name(g2, replace)

* proxim_chom : Connaissez-vous quelqu'un au chômage indemnisé ou non?

eststo clear
logit Y_bin proxim_chom i.statut c.diplome c.sdrevtr c.sdagetr i.sdsexe if bdd==4 & sdrevtr!=8
eststo em1 : margins, dydx(proxim_chom *statut) post
coefplot (em1, keep(proxim_chom) ) (em1, keep(*statut) recast(connected)), baselevels  vertical ylin(0) xlabel(, labsize(vsmall) labcolor(black) angle(30)) ytitle(Effets marginaux) title("Conception élargi des personnes concernées" "par les allocations chômage") sort rename(proxim_chom="{bf: Connaissances au chômage} ")



eststo clear
logit Y_bin i.proxim_chom_2 i.statut c.diplome c.sdrevtr c.sdagetr i.sdsexe if bdd==4 & sdrevtr!=8
eststo em1 : margins, dydx(proxim_chom *statut) post
coefplot (em1, keep(*statut) recast(connected)) (em1, keep(*proxim_chom_2) recast(connected)) , baselevels  vertical ylin(0) xlabel(, labsize(vsmall) labcolor(black) angle(30)) ytitle(Effets marginaux) title("Conception élargi des personnes concernées" "par les allocations chômage") rename(0.proxim_chom_2="Ne connait pas de chômeur" 1.proxim_chom_2="{bf: Connaissances au chômage indemnisé} " 2.proxim_chom_2="{bf: Connaissances au chômage non-indemnisé}")






