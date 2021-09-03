cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do 9_2_self_interest

*********************************

g traité2= (inrange(sdrevtr,6,7) & sdnbenf==1)
g traité3= (inrange(sdrevtr,6,7) & sdnbenf==0)
g traité4= (inrange(sdrevtr,6,7))




* test de différentes période de traitement
g traitement = (inrange(annee, 2015, 2019) )
g traitement2 = (inrange(annee, 2014, 2019) )
g traitement3 = (inrange(annee, 2015, 2016) )
g traitement4 = (inrange(annee, 2015, 2018) )

* traité
g traité = ( inrange(sdrevtr, 6, 7) & inrange(sdnbenf, 2, 10) )

* population avec 2 enfants ou plus
g n2_enf =(inrange(sdnbenf,2,10))



*******************************************************************************
* Choc d'éligibilité sur les allocations familiales (nov 2014 appliqué en 2015)
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


* revtr2 = tranche de revenu en 3 catégories: 1-2-3 / 4-5 / 6-7.

ologit Y  i.annee if annee>=2004 & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017
coefplot , keep(1.revtr2#*) xlabel(1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015" 13 "2016" 14 "2018" 15 "2019") recast(connected) name(g1, replace) eform level(95 90) baselevels vertical yscale(range(-0.5, 4.5)) ylabel(-0.5(1)4.5) yline(1)
coefplot , keep(2.revtr2#*) xlabel(1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015" 13 "2016" 14 "2018" 15 "2019") recast(connected) name(g2, replace) eform level(95 90) baselevels vertical yscale(range(-0.5, 4.5)) ylabel(-0.5(1)4.5) yline(1)
coefplot , keep(3.revtr2#*) xlabel(1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015" 13 "2016" 14 "2018" 15 "2019") recast(connected) name(g3, replace) eform level(95 90) baselevels vertical yscale(range(-0.5, 4.5)) ylabel(-0.5(1)4.5) yline(1)

* peu utile *
ologit Y  i.revtr2#i.annee if annee>=2004 & bdd==3 & sdnbenf>=2 & annee!=2020 & annee!=2017, or
pwcompare *revtr2#2013.annee, pv  mcompare(dunnett)
pwcompare *revtr2#2014.annee, pv
pwcompare *revtr2#2015.annee, pv
pwcompare *revtr2#2016.annee, pv
**** storer les pwcompare des OR puis les ploter ******





* traitement 4 pour famille et chomage
eststo clear
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & annee!=2017, or
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & annee!=2017, or
coefplot est1 est2 , keep(*traitement* traité) baselevels eform xline(1) level(99 95 90) legend(order(4 "Famille" 8 "Chômage"))

* traitement 3 4 et 1 pour famille
eststo clear
eststo: ologit Y c.traitement3#c.traité traitement3 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & annee!=2017, or
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & annee!=2017, or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & annee!=2017, or
coefplot est1 est2 est3, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(famille2, replace) title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux allocations familiales")


* traitement 3 4 et 1 pour chomage
eststo clear
eststo: ologit Y c.traitement3#c.traité traitement3 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & annee!=2017, or
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & annee!=2017, or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & annee!=2017, or
coefplot est1 est2 est3, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(chomage, replace)  title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux allocations chômage")

* traitement 3 4 et 1 pour retraite
eststo clear
eststo: ologit Y c.traitement3#c.traité traitement3 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==2 & annee>2001 & annee!=2017, or
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==2 & annee>2001 & annee!=2017, or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==2 & annee>2001 & annee!=2017, or
coefplot est1 est2 est3, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(retraite, replace)  title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux retraites")


* focus sur population 2 enfants ou plus  famille puis chomage :
eststo clear
eststo: ologit Y c.traitement3#c.traité traitement3 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdnbenf, 2,10) , or
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdnbenf, 2,10), or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdnbenf, 2,10), or
coefplot est1 est2 est3, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(famille2, replace) title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux allocations familiales")


eststo: ologit Y c.traitement3#c.traité traitement3 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdnbenf, 2,10), or
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdnbenf, 2,10), or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdnbenf, 2,10), or
coefplot est4 est5 est6, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(chomage, replace)  title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux allocations chômage")

* graphe traitement 2015 2019 famille et chomage, sous-population 2enf +
coefplot est3 est6, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "Famille" 6 "Chômage")) name(g2015_2019, replace)  title("Effet du traitement sur les traités 2015-2019")


* focus sur population moins de 2 enfant


eststo clear
eststo: ologit Y c.traitement3#c.traité2 traitement3 traité2 c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdnbenf, 0,1) , or
eststo: ologit Y c.traitement4#c.traité2 traitement4 traité2 c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdnbenf, 0,1), or
eststo: ologit Y c.traitement#c.traité2 traitement traité2 c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdnbenf, 0,1), or
coefplot est1 est2 est3, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(famille2, replace) title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux allocations familiales")

eststo: ologit Y c.traitement3#c.traité2 traitement3 traité2 c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdnbenf, 0,1), or
eststo: ologit Y c.traitement4#c.traité2 traitement4 traité2 c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdnbenf, 0,1), or
eststo: ologit Y c.traitement#c.traité2 traitement traité2 c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdnbenf, 0,1), or
coefplot est4 est5 est6, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(chomage, replace)  title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux allocations chômage")

* graphe traitement 2015 2019 famille et chomage, sous-population moins de 2enf
coefplot est3 est6, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "Famille" 6 "Chômage")) name(g2015_2019_inf, replace)  title("Effet du traitement sur les hauts revenus moins de deux enfants 2015-2019")

*********** sous population tranche 6 et 7
eststo clear
eststo: ologit Y c.traitement3#c.traité traitement3 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 6, 7) , or
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 6, 7), or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 6, 7), or
coefplot est1 est2 est3, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(famille2, replace) title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux allocations familiales")

eststo: ologit Y c.traitement3#c.traité traitement3 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdrevtr, 6, 7), or
eststo: ologit Y c.traitement4#c.traité traitement4 traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdrevtr, 6, 7), or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdrevtr, 6, 7), or
coefplot est4 est5 est6, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "2015-2016" 6 "2015-2018" 9 "2015-2019")) name(chomage, replace)  title("Effet du traitement sur les traités en fonction de la durée du traitement" "Soutien aux allocations chômage")

coefplot est3 est6, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "Famille" 6 "Chômage")) name(g2015_2019_t67, replace)  title("Effet du traitement sur les traités 2015-2019" "regression sur tranche 6 et 7")


**** sans les tranches 1 à 3 :
eststo clear
eststo: ologit Y c.traitement#c.traité traitement traité c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 4, 7) & inrange(sdnbenf, 2, 10), or
eststo: ologit Y c.traitement#c.traité traitement traité c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdrevtr, 4, 7) & inrange(sdnbenf, 2, 10), or
coefplot est1 est2, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "Famille" 6 "Chômage")) name(G1, replace)  title("Effet du traitement sur les traités 2015-2019" "regression sur tranche 3 à 7")

eststo clear
eststo: ologit Y c.traitement2#c.traité traitement2 traité c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 4, 7) & annee<2019 & inrange(sdnbenf, 2, 10), or
eststo: ologit Y c.traitement2#c.traité traitement2 traité c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==4 & annee>2001 & inrange(sdrevtr, 4, 7) & annee<2019 & inrange(sdnbenf, 2, 10), or
coefplot est1 est2, keep(*traitement*#*) baselevels eform xline(1) level(95 90) ylabel("") legend(order(3 "Famille" 6 "Chômage")) name(G2, replace)  title("Effet du traitement sur les traités 2014-2018" "regression sur tranche 3 à 7")



* maladie
ologit Y c.traitement#c.traité traitement traité c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==1, or
coefplot, keep(*traitement* traité) baselevels eform name(maladie, replace) xline(1)
*retraite
ologit Y c.traitement#c.traité traitement traité c.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==2, or
coefplot, keep(*traitement* traité) baselevels eform name(retraite, replace) xline(1)



/* Sortie pour rapport */
eststo clear
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 1, 7) & inrange(sdnbenf, 2, 10), or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 5, 7) & inrange(sdnbenf, 2, 10), or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr i.ps13_a_4 if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 1, 7) & inrange(ps13_a_4,1,4) & inrange(sdnbenf, 2, 10) , or
eststo: ologit Y c.traitement#c.traité traitement traité i.sdrevtr i.ps13_a_4 if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & inrange(sdrevtr, 5, 7)  & inrange(ps13_a_4,1,4) & inrange(sdnbenf, 2, 10) , or

esttab using logit_did_cond_ress.tex, nonumbers scalar(r2_p) compress longtable f  not star(* 0.1 ** 0.05 *** 0.01) replace
esttab , nonumbers scalar(r2_p) f p star(* 0.1 ** 0.05 *** 0.01)



* sortir regression de base (sans contrôle ps13). Comparer effet groupe traité normal vs groupe haut revenu 1 enfant vs groupe haut revenu sans enfant.



eststo clear
* traité: rev6 et 7 + 2enfants, controle: les autres
eststo: ologit Y c.traitement#c.traité traitement traité c.sdrevtr n2_enf if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 , or

* traité rev6 et 7 + 2enfants / controle: rev6 et 7 moins de 2 enfnats
eststo: ologit Y c.traitement#c.traité traitement traité c.sdrevtr n2_enf if annee!=2020 & inrange(sdrevtr,6,7) & bdd==3 & annee>2001 , or

* reg placebo traité=T6 et 7 1 enfant non traité les autres (moins les vrais traités)
eststo: ologit Y c.traitement#c.traité2 traitement traité2 c.sdrevtr n2_enf if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & (inrange(sdrevtr,1,5) | (inrange(sdrevtr,6,7) &inrange(sdnbenf, 0, 1)) ), or

* reg placebo traité=T6et7 0enfant, controle le rest moins les vrais traités.
eststo: ologit Y c.traitement#c.traité3 traitement traité3 c.sdrevtr n2_enf if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001 & (inrange(sdrevtr,1,5) | (inrange(sdrevtr,6,7) &inrange(sdnbenf, 0, 1) ) ), or

* reg placebo traité=T6et7, controle le reste
eststo: ologit Y c.traitement#c.traité4 traitement traité4 c.sdrevtr n2_enf if annee!=2020 & sdrevtr!=8 & bdd==3 & annee>2001, or

esttab using logit_did_cond_ress_placebo.tex, nonumbers scalar(r2_p) compress longtable f  not star(* 0.1 ** 0.05 *** 0.01) replace
esttab , nonumbers scalar(r2_p) f p star(* 0.1 ** 0.05 *** 0.01)










