cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"


do 8_1_taux_cotis

do 8_3_0_taux_cotis_did



********************************************************************************
* Régressions par branche
********************************************************************************

eststo clear

eststo : qui ologit ps13_a_1 tc_am i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_1, 1, 4)

eststo : qui ologit ps13_a_2 tc_retr_tot2 i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)

eststo: qui ologit ps13_a_3 tc_famille i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4)

eststo: qui ologit ps13_a_4 tc_chom i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_4, 1, 4)

esttab using ologit_tc.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform scalar(r2_p ll converged) compress longtable f  not star(* 0.1 ** 0.05 *** 0.01) replace
esttab using ologit_tc2.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform scalar(r2_p ll converged) compress longtable f  p star(* 0.1 ** 0.05 *** 0.01) keep(tc_*) replace

esttab , label mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01)


eststo clear
eststo: qui ologit ps13_a_3 tc_famille i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4)
eststo: qui ologit ps13_a_3 tc_famille i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4) & sdstat!=3 & sdstat!=4
esttab , label mtitles("Modèle global" "Sans les indépendants") eform scalar(r2_p ll) star(* 0.1 ** 0.05 *** 0.01)


eststo clear
eststo : qui ologit ps13_a_2 tc_retr_tot2 i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)
eststo : qui ologit ps13_a_2 tc_retr_tot i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)
esttab , label mtitles("Avec T2" "Sans T2") eform scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01) p
esttab using ologit_tc_retr.tex, label nonumbers mtitles("Retraite" "Retraite sans T2 régime général") eform scalar(r2_p ll) compress longtable f  p star(* 0.1 ** 0.05 *** 0.01) keep(tc_*) replace


* regression croisant taux de cotisation et statut d'emploi

eststo clear

eststo : qui reg ps13_a_1 c.tc_am#i.sdstat i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_1, 1, 4)

eststo : qui reg ps13_a_2 c.tc_retr_tot2#i.sdstat i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)

eststo: qui reg ps13_a_3 c.tc_famille#i.sdstat i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4)

eststo: qui reg ps13_a_4 c.tc_chom#i.sdstat i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_4, 1, 4)

esttab , label mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") scalar(r2 ar2 ll) star(* 0.1 ** 0.05 *** 0.01)


* regression avec contrôle niveau de revenus

eststo clear
eststo : qui ologit ps13_a_1 tc_am i.sdstat c.sdrevtr c.annee c.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_1, 1, 4) & sdrevtr!=8
eststo : qui ologit ps13_a_2 tc_retr_tot2 i.sdstat c.sdrevtr c.annee c.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)  & sdrevtr!=8
eststo: qui ologit ps13_a_3 tc_famille i.sdstat c.sdrevtr c.annee c.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4) & sdrevtr!=8
eststo: qui ologit ps13_a_4 tc_chom i.sdstat c.sdrevtr c.annee c.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_4, 1, 4) & sdrevtr!=8
esttab , label mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") scalar(r2 ar2 ll) star(* 0.1 ** 0.05 *** 0.01) eform p




ologit ps13_a_1 ib0.indep##ib0.am_1316  c.annee c.sdagetr c.sdsexe c.sdrevtr if inrange(ps13_a_1, 1, 4)


ologit ps13_a_2 ib0.indep##ib0.fam_15  c.sdagetr c.sdsexe c.sdrevtr if inrange(ps13_a_2, 1, 4)



********************************************************************************
* DID sur les chocs 
********************************************************************************


********************************************************************************
******************Choc chomage 2003*********************************************


eststo : ologit ps13_a_4 traitement_chom2003##traité_chom2003 i.sdrevtr if inrange(annee, 2000, 2008) & inrange(ps13_a_2,1,4) & sdrevtr!=8 & inrange(ps13_a_4, 1,4) & inrange(statut, 1 , 2)
eststo : ologit ps13_a_4 traitement_chom2003##traité_chom2003 i.sdrevtr ps13_a_2 if inrange(annee, 2000, 2008) & inrange(ps13_a_2,1,4) & sdrevtr!=8 & inrange(ps13_a_4, 1,4) & inrange(statut, 1 , 2)
esttab using chocchom_2003.tex, nonumbers scalar(r2_p r2 r2_a) compress longtable f p star(* 0.1 ** 0.05 *** 0.01) replace
coefplot, keep(*traitement* *traité*) xline(0) rename(1.traitement_chom2003="Effet conjoncturel de la durée du traitement" 1.traité_chom2003="Effet du groupe traité (salarié du privé)" 1.traitement_chom2003#1.traité_chom2003="Effet du traitement sur les traités")

ologit ps13_a_4 traitement_chom2003##traité_chom2003 2001.annee i.sdrevtr ps13_a_2 if inrange(annee, 2000, 2008) & inrange(ps13_a_4, 1,4) & inrange(statut, 1 , 2), or
eststo: margins traitement_chom2003#traité_chom2003, pr(outcome(4)) post
coefplot, vertical recast(connected)
*contrôle tendance commune
ologit ps13_a_4 traité_chom2003##i.annee if  inrange(ps13_a_4, 1,4) &  inrange(statut, 1 , 2)
coefplot, vertical recast(connected) keep(1.traité_chom2003*) nolabel xlabel(1 "2000" 10 "2010" 20 "2020") xline(3.5)

* pb de tendance commune avant le choc .... peut être le mettre en binaire pour avoir les margins predict? 
* Sinon solution : dummy en 2001, neutralise complètement le choc qui devient nul.





********************************************************************************
******************Choc chomage 2018*********************************************
********************************

ologit ps13_a_4 traitement_chom18##traité_chom18 c.annee 2019.annee i.sdagetr i.ps13_a_2 ///
	if inrange(annee, 2014, 2020)  	& 	inrange(ps13_a_4, 1,4) 	& 	inrange(statut, 1, 3), or
coefplot, eform keep(*traitement* *traité*) baselevels xline(1)
margins traitement_chom18##traité_chom18, predict(outcome(4)) post
pwcompare traitement_chom18##traité_chom18, pv


ologit ps13_a_4 traité_chom18##i.annee i.sdrevtr if inrange(ps13_a_4, 1,4)  & inrange(statut, 1, 3) 

/* effet positif plutôt robuste, restreindre au actif en emploi ne change rien à l'effet en question */

ologit ps13_a_2 traitement_chom18##traité_chom18 i.sdrevtr i.sdagetr c.annee if inrange(annee, 2010, 2020)  & inrange(ps13_a_2, 1,4)  & inrange(statut, 1, 3)
coefplot, eform keep(*traitement* *traité*) baselevels xline(1)
* effet faiblement significatif sans prise en compte des réponses aux chômages

ologit ps13_a_2 traitement_chom18##traité_chom18 i.sdrevtr i.sdagetr c.annee i.ps13_a_4 if inrange(annee, 2010, 2020)  & inrange(ps13_a_2, 1,4)  & inrange(statut, 1, 3) 
coefplot, eform keep(*traitement* *traité*) baselevels xline(1)

ologit ps13_a_2 traité_chom18##i.annee i.sdrevtr if inrange(ps13_a_2, 1,4)
* placebo: l'effet du traitement sur les retraite n'est pas significatif lorsqu'on contrôle par les réponses pour la branche chômage. On peut donc déduire que la modification vient bien de la réforme des allocations chômages.
* (possible bruit avec les allocations familiales)


********************************************************************************
******************Choc CSG 2018*************************************************


ologit ps13_a_4 traitement_csg##traité_csg i.sdrevtr i.sdagetr if inrange(annee, 2014, 2020)  & inrange(ps13_a_4, 1,4), or

ologit ps13_a_4 traitement_csg##traité_csg i.sdrevtr i.sdagetr if inrange(annee, 2014, 2020)  & inrange(ps13_a_4, 1,4) & statut!=2, or

eststo est1: margins traitement_csg#traité_csg , predict(outcome(4))  post

coefplot (est1, keep(0.traitement_csg#1.traité_csg 1.traitement_csg#1.traité_csg) label(Population touchée par la hausse de csg) rename(0.traitement_csg#1.traité_csg="Avant 2018" 1.traitement_csg#1.traité_csg="Après 2018")) ///
	(est1, keep(0.traitement_csg#0.traité_csg 1.traitement_csg#0.traité_csg) label(Population de contrôle) rename(0.traitement_csg#0.traité_csg="Avant 2018" 1.traitement_csg#0.traité_csg="Après 2018")) ///
	, recast(connected) vertical yline(0.498391)
pwcompare traitement_csg#traité_csg , pv

* je sais plus à quoi sert ce bout de code qui a l'air très similaire à celui du dessus
ologit ps13_a_4 traitement_csg##traité_csg i.sdrevtr i.sdagetr if inrange(annee, 2014, 2020)  & inrange(ps13_a_4, 1,4) & statut!=2, or
eststo est1: margins traitement_csg#traité_csg , predict(outcome(1))  post

coefplot (est1, keep(0.traitement_csg#1.traité_csg 1.traitement_csg#1.traité_csg) label(Population touchée par la hausse de csg) rename(0.traitement_csg#1.traité_csg="Avant 2018" 1.traitement_csg#1.traité_csg="Après 2018")) ///
	(est1, keep(0.traitement_csg#0.traité_csg 1.traitement_csg#0.traité_csg) label(Population de contrôle) rename(0.traitement_csg#0.traité_csg="Avant 2018" 1.traitement_csg#0.traité_csg="Après 2018")) ///
	, recast(connected) vertical yline(0.498391)
pwcompare traitement_csg#traité_csg , pv


ologit ps13_a_3 traitement_csg##traité_csg i.sdrevtr i.sdagetr ps13_a_2 if inrange(annee, 2014, 2020)  & inrange(ps13_a_3, 1,4)





ologit ps13_a_4 traité_csg##i.annee i.sdrevtr if inrange(ps13_a_2, 1,4)
* effet non significatif assez robuste sur le soutien au retraite
* même si on manque de recul (année 2018/2019 GJ et 2020 covid), on peut justifier empiriquement une dummy sur 2020.
* en fait la branche retraite n'est pas pertinente car la csg sert à refinancer le chômage et la famille



********************************************************************************
******************Crossover choc csg chomage 2018*******************************


eststo clear
* Sans contrôle ps13_a_2
eststo : ologit ps13_a_4 1.traitement_csg#1.traité_csg 1.traitement_csg#1.traité_chom18 ///
	traitement_csg traité_csg traité_chom18 ///
	i.sdrevtr if inrange(annee, 2014, 2020)  & inrange(ps13_a_4, 1,4) & sdrevtr!=8
	
* Avec contrôle ps13_a_2
eststo : ologit ps13_a_4 1.traitement_csg#1.traité_csg 1.traitement_csg#1.traité_chom18 ///
	traitement_csg traité_csg traité_chom18 ///
	i.sdrevtr i.ps13_a_2 ///
	if inrange(annee, 2014, 2020)  & inrange(ps13_a_4, 1,4) & sdrevtr!=8 & inrange(ps13_a_2,1,4)

* choc csg , retirer les salarié du privé dans le gr controle
eststo : ologit ps13_a_4 1.traitement_csg#1.traité_csg ///
	traitement_csg traité_csg ///
	i.sdrevtr i.ps13_a_2 ///
	if inrange(annee, 2014, 2020)  & inrange(ps13_a_4, 1,4) & sdrevtr!=8 & statut!=2 & inrange(ps13_a_2,1,4)
	
* chomage 2018 suelement, controle=salarié public
eststo : ologit ps13_a_4 1.traitement_csg#1.traité_chom18 ///
	traitement_csg traité_chom18 ///
	i.sdrevtr i.ps13_a_2 ///
	if inrange(annee, 2014, 2020)  & inrange(ps13_a_4, 1,4) & sdrevtr!=8 & inrange(statut, 1, 2) & inrange(ps13_a_2,1,4)
esttab using choccsgchom.tex, nonumbers scalar(r2_p) compress longtable f p star(* 0.1 ** 0.05 *** 0.01) replace

	
	

ologit ps13_a_4 1.traitement_csg#1.traité_csg 1.traitement_csg#1.traité_chom18 ///
	traitement_csg traité_csg traité_chom18 ///
	i.sdrevtr if inrange(annee, 2014, 2020)  & inrange(ps13_a_4, 1,4) & sdrevtr!=8
eststo est1: margins traitement_csg#traité_csg traitement_csg#traité_chom18 traitement_csg#traité_csg#traité_chom18, predict(outcome(4))  post

* Proba prédite: permet de calculer à la main l'effet de double diff sur la proba predite
pwcompare traitement_csg#traité_csg#traité_chom18, pv

* graphe des proba predite
coefplot (est1, keep(0.traitement_csg#1.traité_csg#0.traité_chom18 1.traitement_csg#1.traité_csg#0.traité_chom18) label(Population touchée par la hausse de csg) rename(0.traitement_csg#1.traité_csg#0.traité_chom18="Avant 2018" 1.traitement_csg#1.traité_csg#0.traité_chom18="Après 2018")) ///
	(est1, keep(0.traitement_csg#0.traité_csg#1.traité_chom18 1.traitement_csg#0.traité_csg#1.traité_chom18) label(Population favorisée par la baisse des cotisations chômage) rename(0.traitement_csg#0.traité_csg#1.traité_chom18="Avant 2018" 1.traitement_csg#0.traité_csg#1.traité_chom18="Après 2018"))  ///
	(est1, keep(0.traitement_csg#0.traité_csg#0.traité_chom18 1.traitement_csg#0.traité_csg#0.traité_chom18) label(Population de contrôle) rename(0.traitement_csg#0.traité_csg#0.traité_chom18="Avant 2018" 1.traitement_csg#0.traité_csg#0.traité_chom18="Après 2018")) ///
	, recast(connected) vertical legend(rows(3)) mlabel mlabstyle(format(%9.2f)) mlabpos(11)


coefplot est1, keep(0.traitement_csg#0.traité_csg#0.traité_chom18 1.traitement_csg#0.traité_csg#0.traité_chom18) bylabel(Population de contrôle) rename(0.traitement_csg#0.traité_csg#0.traité_chom18="Avant 2018" 1.traitement_csg#0.traité_csg#0.traité_chom18="Après 2018") || ///
	est1, keep(0.traitement_csg#1.traité_csg#0.traité_chom18 1.traitement_csg#1.traité_csg#0.traité_chom18) bylabel(Population touchée par la hausse de csg) rename(0.traitement_csg#1.traité_csg#0.traité_chom18="Avant 2018" 1.traitement_csg#1.traité_csg#0.traité_chom18="Après 2018") || ///
	est1, keep(0.traitement_csg#0.traité_csg#1.traité_chom18 1.traitement_csg#0.traité_csg#1.traité_chom18) bylabel(Population favorisée par la baisse des cotisations chômage) rename(0.traitement_csg#0.traité_csg#1.traité_chom18="Avant 2018" 1.traitement_csg#0.traité_csg#1.traité_chom18="Après 2018") ||  ///
	, recast(connected) vertical byopt(rows(3)) mlabel mlabstyle(format(%9.2f)) mlabpos(11)





* Tendance commune :
eststo clear
eststo : ologit ps13_a_4 traité_csg##i.annee traité_chom18##i.annee i.sdrevtr if inrange(ps13_a_4, 1,4) & inrange(annee,2013, 2017), or
coefplot (est1, eform keep(*traité_chom18#*annee)) (est1, eform keep(*traité_csg#*annee)), nolabel xline(1) baselevels





********************************************************************************
******************Choc famille 2018*********************************************

/*
Population concernée: Indépendant et salariés du privé. 
Pose pb pour l'identification au dessus car on a mis les indépendants dans le groupe de contrôle pour chomage.
A priori ça ne peut pas inverser le résultat seulement biais potentiel:
sous-estimation de l'effet réel.
*/



ologit ps13_a_3 traitement_famille##traité_famille i.sdrevtr i.sdagetr if inrange(annee, 2014, 2020)  & inrange(ps13_a_3, 1,4) & inrange(statut, 1,3), or
coefplot, eform keep(*traitement* *traité*) baselevels xline(1)
ologit ps13_a_3 traité_famille##i.annee i.sdrevtr if inrange(ps13_a_3, 1,4)
* ne sort pas du tout



********************************************************************************
******************Choc retraite agirc 2007-2008*********************************************


ologit ps13_a_2 traité_agirc##i.annee i.sdrevtr if inrange(ps13_a_2, 1,4) & inrange(annee, 2004, 2014)
coefplot, baselevels eform drop(*sdrevtr)
ologit ps13_a_2 1.traitement_agirc##1.traité_agirc 1.traité_agirc 1.traitement_agirc i.sdrevtr i.sdagetr i.ps13_a_4 ib3.pcs8 if inrange(annee, 2004, 2009)  & inrange(ps13_a_2, 1,4) & inrange(ps13_a_4, 1, 4) , or
coefplot, eform keep(*traitement* *traité*) baselevels xline(1)
ologit ps13_a_2 1.traitement_agirc##1.traité_agirc 1.traité_agirc 1.traitement_agirc i.sdrevtr i.sdagetr i.ps13_a_4 i.pcs8 if inrange(annee, 2004, 2011)  & inrange(ps13_a_2, 1,4) & inrange(ps13_a_4, 1, 4) , or
coefplot, eform keep(*traitement* *traité*) baselevels xline(1)
* ne sort que sans contrôle du chomage ou de l'AM 
* + question de ce qui sort car le choc n'a pas l'air d'être permanent 
* alors qu'on s'attend à un choc permanent.



***************Choc agirc 2016-2017

* même population traité que ci-dessus
ologit ps13_a_2 traité_agirc##i.annee i.sdrevtr if inrange(ps13_a_2, 1,4) & inrange(annee, 2013, 2020)
coefplot, baselevels eform drop(*sdrevtr)
ologit ps13_a_2 1.traitement_agirc##1.traité_agirc 1.traité_agirc 1.traitement_agirc c.annee i.sdrevtr i.sdagetr ib3.pcs8 if inrange(annee, 2013, 2020)  & inrange(ps13_a_2, 1,4) , or

* pas d'effet lol, plus j'en cherche moins j'en trouve







********************************************************************************
******************Choc retraite public et rsi 2012 et 2014*********************************************
* début du choc = 2012 voir 2011 pour le public et 2014pour les indépendants



ologit ps13_a_2 traité_ret_fp##i.annee i.sdrevtr if inrange(ps13_a_2, 1,4) & inrange(annee, 2008, 2020)
coefplot, baselevels eform drop(*sdrevtr)

ologit ps13_a_2 traitement_ret_fp##traité_ret_fp i.sdrevtr c.annee i.sdagetr if inrange(annee, 2008, 2018)  & inrange(ps13_a_2, 1,4) , or
* ne sors pas du tout quel que soit les bornes temporelles

ologit ps13_a_2 c.traitement_ret_fp2##traité_ret_fp i.sdrevtr c.annee i.sdagetr if inrange(annee, 2008, 2018)  & inrange(ps13_a_2, 1,4) , or
* résultat reste non significatif avec un effet linéaire de traitement linéaire entre 2012 et 2018

ologit ps13_a_2 c.traitement_ret_fp3##traité_ret_fp i.sdrevtr c.annee i.sdagetr i.ps13_a_3 if inrange(annee, 2010, 2018)  & inrange(ps13_a_2, 1,4) & inrange(ps13_a_3, 1,4) , or
* significatif pour une borne sup allant de 2016 à 2018 
* mais pas significatif lorsqu'on contrôle par une autre ps13


* choc rsi 2014

ologit ps13_a_2 traité_ret_ind##i.annee i.sdrevtr if inrange(ps13_a_2, 1,4) & inrange(annee, 2008, 2020)
coefplot, baselevels eform drop(*sdrevtr)
ologit ps13_a_2 1.traitement_ret_ind#1.traité_ret_ind 1.traité_ret_ind  i.sdrevtr i.annee i.sdagetr if inrange(annee, 2010, 2019)  & inrange(ps13_a_2, 1,4) , or
* difficile à contrôler efficacement avec une simple tendance.
* en prenant les années en quali ça sort pas.

* Pour les retraite prendre les années en quali car grosse tendance à partir de 2013/2014 seulement.


eststo clear

ologit ps13_a_2 2014.annee#1.traité_ret_ind 2015.annee#1.traité_ret_ind ///
	2012.annee#1.traité_ret_fp 2013.annee#1.traité_ret_fp ///
	1.traité_ret_ind#1.traitement_ret_ind2 1.traité_ret_ind ///
	1.traité_ret_fp#1.traitement_ret_fp3 1.traité_ret_fp ///
	1.traité_agirc#1.traitement_agirc 1.traité_agirc ///
	1.traitement_agirc2#1.traité_agirc /// * même traité que la ligne dessus
	i.sdrevtr i.sdagetr i.ps13_a_4 i.annee ///
	if inrange(ps13_a_2, 1,4) & inrange(ps13_a_4, 1,4) & inrange(annee, 2004, 2019) , or
	
eststo est1 : margins 1.traité_ret_fp#0.traitement_ret_fp3 1.traité_ret_fp#1.traitement_ret_fp3  ///
	1.traité_agirc#0.traitement_agirc 1.traité_agirc#1.traitement_agirc	 ///
	1.traité_agirc#0.traitement_agirc2 1.traité_agirc#1.traitement_agirc2 ///
	1.traité_ret_ind#0.traitement_ret_ind2 1.traité_ret_ind#1.traitement_ret_ind2, ///
	predict(outcome(4))  post


coefplot (est1, keep(1.traité_agirc#0.traitement_agirc 1.traité_agirc#1.traitement_agirc)) ///
	(est1, keep(1.traité_ret_fp*)) ///
	(est1, keep(1.traité_ret_ind*)) ///
	(est1, keep(1.traité_agirc#0.traitement_agirc2 1.traité_agirc#1.traitement_agirc2)), ///
	recast(connected) nolabel  ///
	heading("Fonction publique avant 2012"="{bf: Choc fonction publique 2012}" ///
	"Cadre avant*"="{bf: Choc Agirc 2008}" ///
	"Indépendant avant*"="{bf: Choc RSI 2014}") ///
	legend(off) xline(0.474) ///
	rename(1.traité_agirc#0.traitement_agirc="Cadre avant 2008"1.traité_agirc#1.traitement_agirc="Cadre après 2008"  ///
	1.traité_ret_fp#0.traitement_ret_fp3="Fonction publique avant 2012" 1.traité_ret_fp#1.traitement_ret_fp3="Fonction publique après 2014"  ///
	1.traité_ret_ind#0.traitement_ret_ind2="Indépendant avant 2014" 1.traité_ret_ind#1.traitement_ret_ind2="Indépendant après 2016" ///
	1.traité_agirc#0.traitement_agirc2="Cadre avant 2016" 1.traité_agirc#1.traitement_agirc2="Cadre après 2016") ///
	mlabel mlabstyle(format(%9.3f)) mlabpos(11)

pwcompare traité_ret_fp#traitement_ret_fp  ///
	traité_agirc#traitement_agirc	 ///
	traité_ret_ind#traitement_ret_ind ///
	traité_agirc#traitement_agirc2, pv
* pas de résultats significatifs sur les 3 chocs de cotisations.


eststo clear

eststo : ologit ps13_a_2 2014.annee#1.traité_ret_ind 2015.annee#1.traité_ret_ind ///
	2012.annee#1.traité_ret_fp 2013.annee#1.traité_ret_fp ///
	1.traité_ret_ind#1.traitement_ret_ind2 1.traité_ret_ind ///
	1.traité_ret_fp#1.traitement_ret_fp3 1.traité_ret_fp ///
	1.traité_agirc#1.traitement_agirc 1.traité_agirc ///
	1.traitement_agirc2#1.traité_agirc /// * même traité que la ligne dessus
	i.sdrevtr i.sdagetr i.ps13_a_4 i.annee ///
	if inrange(ps13_a_2, 1,4) & inrange(ps13_a_4, 1,4) & inrange(annee, 2004, 2019) , or
esttab using did_retraite.tex, label eform scalar(r2_p) compress longtable f  not star(* 0.1 ** 0.05 *** 0.01) replace


eststo clear

eststo : ologit ps13_a_2 ///
	1.traité_agirc#1.traitement_agirc 1.traité_agirc ///
	1.traitement_agirc2#1.traité_agirc /// * même traité que la ligne dessus
	1.traitement_agirc 1.traitement_agirc2 ///
	i.sdrevtr i.sdagetr i.ps13_a_4 c.annee ///
	if inrange(ps13_a_2, 1,4) & inrange(ps13_a_4, 1,4) & inrange(annee, 2004, 2019) , or

eststo : ologit ps13_a_2 ///
	2012.annee 2012.annee#1.traité_ret_fp 2013.annee 2013.annee#1.traité_ret_fp ///
	1.traité_ret_fp#1.traitement_ret_fp3 1.traité_ret_fp 1.traitement_ret_fp3 ///
	i.sdrevtr i.sdagetr i.ps13_a_4 c.annee ///
	if inrange(ps13_a_2, 1,4) & inrange(ps13_a_4, 1,4) & inrange(annee, 2004, 2019) , or

eststo : ologit ps13_a_2 2014.annee 2014.annee#1.traité_ret_ind 2015.annee 2015.annee#1.traité_ret_ind ///
	1.traité_ret_ind#1.traitement_ret_ind2 1.traité_ret_ind 1.traitement_ret_ind2 ///
	i.sdrevtr i.sdagetr i.ps13_a_4 i.annee ///
	if inrange(ps13_a_2, 1,4) & inrange(ps13_a_4, 1,4) & inrange(annee, 2004, 2019) , or
	

esttab using did_retraite_2.tex, label eform scalar(r2_p) compress longtable f keep(*traité* *traitement*) not star(* 0.1 ** 0.05 *** 0.01) replace





