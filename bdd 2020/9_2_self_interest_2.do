cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do 6_0_ACM_codage_variables 




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


g si_handi = (bdd==5 & sdres_10==1)

g si_dep=(bdd==6 & sdage>80)

g si_logt= (bdd==7 & sdres_9==1)

g si = si_am + si_retr + si_fam2 + si_chom + si_handi + si_dep + si_logt


g si_f= (bdd==3 & inrange(sdnbenf,2,10) ) /* famille avec 2 enfants ou plus*/
g Y_bin = (inrange(Y,3,4))
replace Y_bin=. if Y==.

* corrections dûes au manque de données
replace si=. if (bdd==3 | bdd==5) & inrange(annee, 2000, 2012)
replace si=. if bdd==6 & inrange(annee, 2000, 2003)
replace si=. if bdd==7 & inrange(annee, 2000, 2014)




*******************************************************************************
******************* Regressions **************************************
*******************************************************************************



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
	eststo: ologit Y si c.sdagetr c.sdrevtr i.sdsexe i.statut c.diplome if bdd==`i' & sdrevtr!=8
}
esttab, label scalar(r2_p) star(* 0.1 ** 0.05 *** 0.01) eform
esttab using logit_soutien.tex, nonumbers eform mtitles("AM" "Retraite" "Famille" "Chomage"  "Handicap" "Dépendance" " Logement") scalar(r2_p r2_a) compress longtable f star(* 0.1 ** 0.05 *** 0.01) label replace
esttab , label scalar(r2_p) star(* 0.1 ** 0.05 *** 0.01)

* or  du statut sur 5 branches (retiré AM car comme retraite et dépendance car comme handicap pour plus de lisibilité). 
coefplot est2 est3 est4 est5 est7 , ///
	keep(*.statut) xline(0) eform ///
	legend(order(1 "Retraite" 3 "Famille" 5 "Chômage" 7 "Handicap" 9 "Logement")) ///
	headings(2.statut= "{bf: Base: salarié du public}")  ///
	title("Statut d'emploi et soutien à la protection sociale") subtitle(Odds ratio)

* statut AM retraite	
coefplot est1 est2, ///
	keep(*.statut) xline(1) eform ///
	legend(order(2 "AM" 4 "Retraite")) ///
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
	legend(order(1 "AM" 3 "Retraite" 5 "Famille" 7 "Chômage" 9 "Handicap" 11 " Dépendance" 13 "Logement")) ///
	title("Caractéristique socio-démographique " " et soutien à la protection sociale") subtitle(Odds ratio) ///
	nolabel rename(2.sdsexe="Femme" diplome="Diplôme"  sdrevtr="Tranche de revenu" sdagetr = "Tranche d'âge")
	
* AM famille (oppositions entre am retraite vs famille logement avec handicap chomage et dépendance entre deux)
coefplot est1 est3, ///
	keep(sdagetr sdrevtr *.sdsexe diplome) xline(1) eform ///
	legend(order(1 "Assurance maladie" 3 "Famille")) ///
	title("Effets différenciés du revenu et du diplôme") subtitle(Odds ratio) ///
	nolabel rename(2.sdsexe="Femme" diplome="Diplôme"  sdrevtr="Tranche de revenu" sdagetr = "Tranche d'âge")


coefplot est2 est3 est4 est5 est6 est7, ///
	keep(si) rename(si="Bénéficiaire") eform ///
	legend(order(1 "Retraite" 3 "Famille" 5 "Chômage" 7 "Handicap" 9 " Dépendance" 11 "Logement")) ///
	xline(1) title(Odds ratio d'être bénéficiaire par branche) 


eststo clear
eststo: ologit Y i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==1 & sdrevtr!=8 & annee>=2013
margins sdagetr, pr(outcome(1)) pr(outcome(2)) pr(outcome(3)) pr(outcome(4))
marginsplot
margins sdrevtr, pr(outcome(1)) pr(outcome(2)) pr(outcome(3)) pr(outcome(4))
marginsplot
margins sdsexe, pr(outcome(1)) pr(outcome(2)) pr(outcome(3)) pr(outcome(4))
marginsplot

*************************
*
*************************
eststo clear
forvalues i=1/4{
qui: ologit Y_bin i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_age: margins sdagetr, pr(outcome(1)) post
qui : ologit Y_bin i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_rev: margins sdrevtr, pr(outcome(1)) post
qui: ologit Y_bin i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_sexe: margins sdsexe, pr(outcome(1)) post
qui : ologit Y_bin i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
eststo em`i'_statut: margins statut, pr(outcome(1)) post
}

coefplot em*_sexe, recast(connected) vertical ///
	title("Effet marginal du sexe" "Probabilité de refuser une baisse de prestations" , size(medium)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(, labcolor(black))

coefplot em*_age, recast(connected) vertical ///
	title("Effet marginal de l'âge" "Probabilité de refuser une bausse de prestations", size(medium)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(, labcolor(black))
	
coefplot em*_rev, recast(connected) ///
	title("Effet marginal du revenu" "Probabilité de refuser une bausse de prestations", size(medium)) ///
	vertical xlabel(,  labsize(tiny) labcolor(black) angle(45)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) 
	
coefplot em*_statut,  recast(connected) vertical ///
	title("Effet marginal du statut" "Probabilité de refuser une baisse de prestations", size(medium)) ///
	legend(order(2 "Assurance maladie" 4 "Retraite" 6 "Famille" 8 "Allocations Chomage")) ///
	xlabel(,  labsize(small) labcolor(black) angle(10)) sort



*************
/*
eststo clear
forvalues i=1/7 {
	eststo: ologit Y i.si i.sdagetr i.sdrevtr i.sdsexe i.statut if bdd==`i' & sdrevtr!=8 & annee>=2013
	margins, pr(outcome(1))
	marginsplot
}	
	marginsplot, name(em_si_`i', replace)
	margins, dydx(sdagetr)
	marginsplot, name(em_age_`i', replace)
	margins, dydx(sdrevtr)
	marginsplot, name(em_rev_`i', replace)
	margins, dydx(statut)
	marginsplot, name(em_statut_`i', replace)
	margins, dydx(sdsexe)
	marginsplot, name(em_sdsexe_`i', replace)
*/

********************************************************
* Effets marginaux du revenu et de l'âge (AM / Famille) 
* puis chomage statut
********************************************************
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


* chomage et statut d'emploi: (testé ensuite le fait de se sentir concerné ie question subjective puis "connaissez-vous qq'un qui est au chômage?")
* sans contrôle par l'âge

eststo clear
logit Y_bin i.statut c.diplome c.sdrevtr c.sdagetr i.sdsexe if bdd==4 & sdrevtr!=8
eststo em1 : margins, dydx(*statut) post
coefplot em1, baselevels keep(*statut) recast(connected) vertical ylin(0) xlabel(, labcolor(black) angle(20)) ytitle(Effets marginaux) title("Effet du statut sur le soutien aux allocations chômage") sort name(g2, replace)


g proxim_chom=(inrange(sdproxim_1, 2, 8) | inrange(sdproxim_2, 2,8))

eststo clear
logit Y_bin proxim_chom i.statut c.diplome c.sdrevtr c.sdagetr i.sdsexe if bdd==4 & sdrevtr!=8
eststo em1 : margins, dydx(proxim_chom *statut) post
coefplot (em1, keep(proxim_chom) ) (em1, keep(*statut) recast(connected)), baselevels  vertical ylin(0) xlabel(, labsize(vsmall) labcolor(black) angle(30)) ytitle(Effets marginaux) title("Conception élargi des personnes concernées" "par les allocations chômage") sort rename(proxim_chom="{bf: Connaissances au chômage} ")

g proxim_chom_2 = 0 if (sdproxim_1==1 | sdproxim_1==9) & (sdproxim_2==1 | sdproxim_2==9)
replace proxim_chom_2 =1 if inrange(sdproxim_1,2,8)
replace proxim_chom_2=2 if inrange(sdproxim_2, 2,8)

eststo clear
logit Y_bin i.proxim_chom_2 i.statut c.diplome c.sdrevtr c.sdagetr i.sdsexe if bdd==4 & sdrevtr!=8
eststo em1 : margins, dydx(proxim_chom *statut) post
coefplot (em1, keep(*statut) recast(connected)) (em1, keep(*proxim_chom_2) recast(connected)) , baselevels  vertical ylin(0) xlabel(, labsize(vsmall) labcolor(black) angle(30)) ytitle(Effets marginaux) title("Conception élargi des personnes concernées" "par les allocations chômage") rename(0.proxim_chom_2="Ne connait pas de chômeur" 1.proxim_chom_2="{bf: Connaissances au chômage indemnisé} " 2.proxim_chom_2="{bf: Connaissances au chômage non-indemnisé}")


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



*******************************************************************************
* Essai famille avant 2013 après 2015 (effet mise sous condition de ressource). 
* Détails de l'effet revenu
*******************************************************************************


eststo clear
eststo: ologit Y si_f c.sdagetr c.sdrevtr i.sdsexe i.statut if bdd==3 & sdrevtr!=8 & inrange(annee,2000, 2007)
*eststo: ologit Y si_f c.sdagetr c.sdrevtr i.sdsexe i.statut if bdd==3 & sdrevtr!=8 & inrange(annee,2011, 2012)
eststo: ologit Y si_f c.sdagetr c.sdrevtr i.sdsexe i.statut if bdd==3 & sdrevtr!=8 & inrange(annee,2008, 2015)
eststo: ologit Y si_f c.sdagetr c.sdrevtr i.sdsexe i.statut if bdd==3 & sdrevtr!=8 & inrange(annee,2016, 2020)
coefplot est1 est2 est3 , eform keep(sdrevtr) xline(1) nolabel

eststo clear

forvalues i=2004/2020{
	eststo: ologit Y si_f c.sdagetr c.sdrevtr i.sdsexe i.statut if bdd==3 & sdrevtr!=8 & annee==`i'
}
coefplot est*, keep(sdrevtr) nolabel eform vertical legend(off)

eststo clear
forvalues i=2014/2020{
	eststo: ologit Y si_f c.sdagetr c.sdnivie i.sdsexe i.statut if bdd==3 & sdrevtr!=8 & annee==`i'
}
coefplot est1, bylabel(2014) || est2 , bylabel(2015)|| est3 , bylabel(2016) || est4 , bylabel(2017) || est5 , bylabel(2018) || est6 , bylabel(2019)  || est7 , bylabel(2020)  ||,  keep(sdnivie) nolabel eform legend(off) vertical byopts(rows(1)) xlabel("")

eststo clear
forvalues i=1/7 {
qui : ologit Y i.annee if annee>=2004 & sdrevtr==`i' & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017
eststo mar`i' : margins, dydx(annee) post
}
coefplot mar*, recast(connected) vertical nolabel xlabel(,angle(20)) legend(order(2 "T1" 4 "T2" 6 "T3" 8 "T4" 10 "T5" 12 "T6" 14 "T7")) name(sup2enf, replace)

eststo clear
forvalues i=1/7 {
ologit Y i.annee if annee>=2004 & sdrevtr==`i' & bdd==3 & sdnbenf<2 & annee!=2020 & annee!=2017
eststo mar`i' : margins, dydx(annee) post
}
coefplot mar*, recast(connected) vertical nolabel xlabel(,angle(20)) legend(order(2 "T1" 4 "T2" 6 "T3" 8 "T4" 10 "T5" 12 "T6" 14 "T7")) name(inf2enf, replace)



eststo clear
qui : logit Y_bin i.annee if annee>=2004 & inrange(sdrevtr, 1, 3) & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017
eststo mar1 : margins, dydx(annee) post

qui : logit Y_bin i.annee if annee>=2004 & inrange(sdrevtr, 4, 5) & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017
eststo mar2 : margins, dydx(annee) post

qui : logit Y_bin i.annee if annee>=2004 & inrange(sdrevtr, 6, 7) & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017
eststo mar3 : margins, dydx(annee) post

coefplot mar*, recast(connected) vertical xlabel(,angle(20)) legend(order( 2 "Tranche 1 à 3" 4 "Tranche 4 et 5" 6 "Tranche 6 et 7")) name(sup2enf_2, replace)


eststo clear
qui : logit Y_bin i.annee if annee>=2004 & inrange(sdrevtr, 1, 3) & bdd==3 & sdnbenf<2 & annee!=2020 & annee!=2017
eststo mar1_b : margins, dydx(annee) post

qui : logit Y_bin i.annee if annee>=2004 & inrange(sdrevtr, 4, 5) & bdd==3 & sdnbenf<2 & annee!=2020 & annee!=2017
eststo mar2_b : margins, dydx(annee) post

qui : logit Y_bin i.annee if annee>=2004 & inrange(sdrevtr, 6, 7) & bdd==3 & sdnbenf<2 & annee!=2020 & annee!=2017
eststo mar3_b : margins, dydx(annee) post

coefplot mar*_b, recast(connected) vertical xlabel(,angle(20)) legend(order( 2 "Tranche 1 à 3" 4 "Tranche 4 et 5" 6 "Tranche 6 et 7")) name(inf2enf_2, replace)



eststo clear
eststo ora1 : ologit Y i.annee if annee>=2004 & inrange(sdrevtr, 1, 3) & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017

eststo ora2 : qui : ologit Y i.annee if annee>=2004 & inrange(sdrevtr, 4, 5) & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017

eststo ora3 : qui : ologit Y i.annee if annee>=2004 & inrange(sdrevtr, 6, 7) & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017

coefplot ora*, recast(connected) vertical xlabel(,angle(20)) legend(order( 3 "Tranche 1 à 3" 6 "Tranche 4 et 5" 9 "Tranche 6 et 7")) name(ora, replace) eform level(95 90)  xlabel(1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015" 13 "2016" 14 "2018" 15 "2019") yline(1) baselevels

eststo orb1 : qui : ologit Y i.annee if annee>=2004 & inrange(sdrevtr, 1, 3) & bdd==3 & sdnbenf<2 & annee!=2020 & annee!=2017

eststo orb2 : qui : ologit Y i.annee if annee>=2004 & inrange(sdrevtr, 4, 5) & bdd==3 & sdnbenf<2 & annee!=2020 & annee!=2017

eststo orb3 : qui : ologit Y i.annee if annee>=2004 & inrange(sdrevtr, 6, 7) & bdd==3 & sdnbenf<2 & annee!=2020 & annee!=2017

coefplot orb*, recast(connected) vertical xlabel(,angle(20)) legend(order( 3 "Tranche 1 à 3" 6 "Tranche 4 et 5" 9 "Tranche 6 et 7")) name(orb, replace) eform level(95 90)  xlabel(1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015" 13 "2016" 14 "2018" 15 "2019") yline(1) baselevels



g revtr2 = 1 if inrange(sdrevtr,1,3)
replace revtr2 =2 if inrange(sdrevtr,4,5)
replace revtr2=3 if inrange(sdrevtr,6,7)

ologit Y  i.annee if annee>=2004 & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017
coefplot , keep(1.revtr2#*) xlabel(1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015" 13 "2016" 14 "2018" 15 "2019") recast(connected) name(g1, replace) eform level(95 90) baselevels vertical yscale(range(-0.5, 4.5)) ylabel(-0.5(1)4.5) yline(1)
coefplot , keep(2.revtr2#*) xlabel(1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015" 13 "2016" 14 "2018" 15 "2019") recast(connected) name(g2, replace) eform level(95 90) baselevels vertical yscale(range(-0.5, 4.5)) ylabel(-0.5(1)4.5) yline(1)
coefplot , keep(3.revtr2#*) xlabel(1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015" 13 "2016" 14 "2018" 15 "2019") recast(connected) name(g3, replace) eform level(95 90) baselevels vertical yscale(range(-0.5, 4.5)) ylabel(-0.5(1)4.5) yline(1)


ologit Y  i.revtr2#i.annee if annee>=2004 & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017
pwcompare *revtr2#2013.annee
pwcompare *revtr2#2014.annee
pwcompare *revtr2#2015.annee
pwcompare *revtr2#2016.annee



