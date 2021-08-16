cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do 8_1_taux_cotis

*************************
******SELF INTEREST******
*************************


g si_am=(bdd==1)


g si_retr= (bdd==2 & sdres_5==1) /* ou statut==7 ? */

/* bénéf d'allocations familiales sont à 70% couple avec enfant, 
17 % familles monop (7.3% dans l'échantillon total)
64% des personnes avec 2enfants touchent des AF (prop augmente >2enfants)
Seul 25% des enquêtés ayant 1 enfant beneficie des AF
-> le plus déterminant pour séparer les familles 1 enfant 
n'est pas le nb de parent mais le niveau de revenu
*/
g si_fam= (bdd==3 & inrange(sdnbenf,2,10) ) /* famille avec 2 enfants ou plus*/

* SI famille prenant en compte (approximativement) l'effet du revenu dans la répartition des allocations familiales
g si_fam_rev= (bdd==3 & (inrange(sdnbenf, 3, 10) | (sdrevtr!=7 & sdnbenf==2) | (sdnbenf==1 & sdrevtr==1)) )



/* foyer bénéficiant des allocations chômage, 
n'inclut pas tous les chômeurs et n'inclut pas que des chômeurs, 
seulement 3472 individus en commun pour 6000 et 8000 individus concernés en fonction de la variable */
g si_chom= (bdd==4 & sdres_4==1)
g si_chom2 = (bdd==4 & statut==5)



/* branche handicap dépendance logement (à voir plus tard)

g si_dep


g si_handi


g si_lgt

*/

eststo clear
eststo: ologit Y i.bdd i.statut c.sdrevtr c.sdagetr i.sdsexe c.annee 1.bdd#c.tc_am si_am 2.bdd#c.tc_retr_tot2 si_retr 3.bdd#c.tc_famille si_fam 4.bdd#c.tc_chom si_chom   if sdrevtr!=8 & statut!=.
eststo: ologit Y i.bdd i.statut c.sdrevtr c.sdagetr i.sdsexe c.annee 1.bdd#c.tc_am si_am 2.bdd#c.tc_retr_tot si_retr 3.bdd#c.tc_famille si_fam_rev 4.bdd#c.tc_chom si_chom2   if sdrevtr!=8 & statut!=.
esttab using ologit_tc_si.tex, label nonumbers mtitles("") eform scalar(r2_p ll) compress longtable f star(* 0.1 ** 0.05 *** 0.01) keep(*tc_* si_* *bdd) replace

eststo clear
xtset id
eststo: xtologit Y i.bdd i.statut c.sdrevtr c.sdagetr i.sdsexe c.annee 1.bdd#c.tc_am si_am 2.bdd#c.tc_retr_tot2 si_retr 3.bdd#c.tc_famille si_fam 4.bdd#c.tc_chom si_chom   if sdrevtr!=8 & statut!=.
xtset id
eststo: xtologit Y i.bdd i.statut c.sdrevtr c.sdagetr i.sdsexe c.annee 1.bdd#c.tc_am si_am 2.bdd#c.tc_retr_tot si_retr 3.bdd#c.tc_famille si_fam_rev 4.bdd#c.tc_chom si_chom2 if sdrevtr!=8 & statut!=.
esttab using ologit_tc_si_ef.tex, label nonumbers mtitles("Modele 1" "Modele 2") eform scalar(r2_p ll) compress longtable f star(* 0.1 ** 0.05 *** 0.01) keep(*tc_* si_* *bdd) replace
esttab , label eform star(* 0.1 ** 0.05 *** 0.01)



g choc_tcam =(inrange(annee, 2013, 2016) & inrange(statut, 3, 4) & bdd==1) /* Ajouter une condition de revenu ? (le choc ne concerne a priori que les indép bas revenu) */
g choc_am=(inrange(annee, 2013, 2016) & bdd==1)
g pop_choc_am = ( inrange(statut, 3, 4) & bdd==1 )
* g choc_tcretr = 

g choc_tcfam1 = (inrange(annee, 2015, 2020) & inrange(statut, 1,4) & bdd==3)
replace choc_tcfam1=2 if (inrange(annee, 2018, 2020) & inrange(statut, 1,4) & bdd==3)

g choc_fam1 = (inrange(annee, 2015, 2020) & bdd==3)
replace choc_fam1=2 if (inrange(annee, 2018, 2020) & bdd==3)

g pop_choc_fam= (inrange(statut, 1,4) & bdd==3)

g choc_tcchom =(inrange(annee,2018, 2020) & statut==2 & bdd==4)
g choc_chom =(inrange(annee,2018, 2020) & bdd==4)
g pop_choc_chom=(statut==2 & bdd==4)


* pop choc




eststo clear
xtset id
eststo: xtologit Y  i.statut c.sdrevtr c.sdagetr i.sdsexe i.bdd##c.annee si_am choc_am choc_tcam  si_retr si_fam choc_fam1 choc_tcfam1  si_chom choc_chom choc_tcchom if sdrevtr!=8 & statut!=.
eststo: ologit Y  i.statut c.sdrevtr c.sdagetr i.sdsexe i.bdd##c.annee si_am choc_am choc_tcam  si_retr si_fam choc_fam1 choc_tcfam1  si_chom choc_chom choc_tcchom if sdrevtr!=8 & statut!=.

/*esttab using ologit_tc_si_ef.tex, label nonumbers mtitles("Modele 1" "Modele 2") eform scalar(r2_p ll) compress longtable f star(* 0.1 ** 0.05 *** 0.01) keep(*tc_* si_* *bdd) replace */

esttab , label eform star(* 0.1 ** 0.05 *** 0.01)


/* modèle le plus aboutit : rien n'empêche de le faire tourner sur un logit
Question en matière de méthode: est ce qu'on interprète plus le modèle à effet fixe ou le modèle normal?
Peut être que ça vaudrait le coupe de faire tourner le modèle séparément sur chaque branche pour pouvoir ne pas utiliser d'effet fixe individuel rendant le contrôle des variables importantes plus difficile
Enfin dans une optique de pseudo panel on peut aussi essayer modèle effet fixe sur les statut */

g Y3 = Y2*10
g Y4 = Y3_1*10

eststo clear
xtset id
eststo:  xtreg Y3  i.bdd c.annee si_retr  ///
	si_am choc_am choc_tcam pop_choc_am ///
	si_fam choc_fam1 choc_tcfam1  pop_choc_fam ///
	si_chom choc_chom choc_tcchom pop_choc_chom ///
	if sdrevtr!=8 & statut!=. , fe

eststo: reg Y3  i.statut c.sdrevtr c.sdagetr i.sdsexe i.bdd c.annee si_retr ///
	si_am choc_am choc_tcam pop_choc_am ///
	si_fam choc_fam1 choc_tcfam1  pop_choc_fam ///
	si_chom choc_chom choc_tcchom pop_choc_chom  ///
	if sdrevtr!=8 & statut!=.
	
esttab using reg_ca_did.tex, label nonumbers mtitles("Modele 1" "Modele 2") scalar(r2) compress longtable f star(* 0.1 ** 0.05 *** 0.01) replace

esttab , label star(* 0.1 ** 0.05 *** 0.01)


* hypothèse de tendance commune à vérifier 

eststo clear
xtset id
eststo:  xtologit Y i.bdd c.annee si_retr  ///
	si_am choc_am choc_tcam pop_choc_am ///
	si_fam choc_fam1 choc_tcfam1  pop_choc_fam ///
	si_chom choc_chom choc_tcchom pop_choc_chom ///
	if sdrevtr!=8 & statut!=.

eststo: ologit Y i.statut c.sdrevtr c.sdagetr i.sdsexe i.bdd c.annee si_retr ///
	si_am choc_am choc_tcam pop_choc_am ///
	si_fam choc_fam1 choc_tcfam1  pop_choc_fam ///
	si_chom choc_chom choc_tcchom pop_choc_chom  ///
	if sdrevtr!=8 & statut!=.
	
esttab using reg_olog_did.tex, label nonumbers mtitles("Modele 1" "Modele 2") scalar(r2) compress longtable f star(* 0.1 ** 0.05 *** 0.01) replace

esttab , label star(* 0.1 ** 0.05 *** 0.01) scalar(r2_p)



eststo clear
xtset id
eststo:  xtreg Y4  i.bdd c.annee si_retr  ///
	si_am choc_am choc_tcam pop_choc_am ///
	si_fam choc_fam1 choc_tcfam1  pop_choc_fam ///
	si_chom choc_chom choc_tcchom pop_choc_chom ///
	if sdrevtr!=8 & statut!=. , fe

eststo: reg Y4  i.statut c.sdrevtr c.sdagetr i.sdsexe i.bdd c.annee si_retr ///
	si_am choc_am choc_tcam pop_choc_am ///
	si_fam choc_fam1 choc_tcfam1  pop_choc_fam ///
	si_chom choc_chom choc_tcchom pop_choc_chom  ///
	if sdrevtr!=8 & statut!=.
	
esttab using reg_ca_did2.tex, label nonumbers mtitles("Modele 1" "Modele 2") scalar(r2) compress longtable f star(* 0.1 ** 0.05 *** 0.01) replace

esttab , label star(* 0.1 ** 0.05 *** 0.01)


reg Y4 i.annee
coefplot, xlabel(1 "2000" 3 "2002" 5 "2005" 7 "2007" 9 "2009" 11 "2011" 13 "20013" 15 "2015" 17 "2017" 19 "2019") vertical


reg  Y4  i.annee##i.bdd
coefplot, vertical keep(*.annee) name(AM, replace) xlabel(1 "2000" 5 "2005" 10 "2010" 15 "2015" 19 "2020") title(Assurance maladie)
coefplot, vertical keep(*.annee#2.bdd) name(retraite, replace)  xlabel(1 "2000" 5 "2005" 10 "2010" 15 "2015" 19 "2020") title(retraite)
coefplot, vertical keep(*.annee#3.bdd) name(famille, replace)  xlabel(1 "2000" 5 "2005" 10 "2010" 15 "2015" 19 "2020") title(Famille)
coefplot, vertical keep(*.annee#4.bdd) name(chomage, replace)  xlabel(1 "2000" 5 "2005" 10 "2010" 15 "2015" 19 "2020") title(Chômage)


xtset id
xtreg  Y4  i.annee##i.bdd, r
coefplot, vertical keep(*.annee) name(AM, replace) xlabel(1 "2000" 5 "2005" 10 "2010" 15 "2015" 19 "2020") title(Assurance maladie)
coefplot, vertical keep(*.annee#2.bdd) name(retraite, replace)  xlabel(1 "2000" 5 "2005" 10 "2010" 15 "2015" 19 "2020") title(retraite)
coefplot, vertical keep(*.annee#3.bdd) name(famille, replace)  xlabel(1 "2000" 5 "2005" 10 "2010" 15 "2015" 19 "2020") title(Famille)
coefplot, vertical keep(*.annee#4.bdd) name(chomage, replace)  xlabel(1 "2000" 5 "2005" 10 "2010" 15 "2015" 19 "2020") title(Chômage)


* influence du changement de questionnaire année paire/impaire à gérer/prendre en compte à partir de 2014.
