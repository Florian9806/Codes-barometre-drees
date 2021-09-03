



********************************************************************************
* Code de création de la bdd modele économétrique
********************************************************************************


******************************
* Partie I: création des variables de financement et bénéficiaire
******************************

import excel "C:\Users\Utilisateur\Documents\StageLiepp\Var_taux_cotis.xls", sheet("Feuille1") firstrow clear

mkmat Annee F_* if Annee!=. , matrix(financement)


**************************
/* Fait tourner le do file de modif de variable initial puis celui aménageant les variables pour les ACM */
**************************

do 6_0_ACM_codage_variables 


svmat financement , names(col)

grstyle init
grstyle set mesh, compact


********************************************************************************
* Création des variables de taux de cotisations
********************************************************************************

/*Création d'une dummy PSS pour les ménages censé être au dessus du plafond de la sécurité sociale (il s'agit d'une approximation puisqu'on a pas de donnée précise sur les montants des revenus d'activité */

g pss = (sdrevtr >= 5 & sdrevtr!=8)
replace pss=0 if sdrevtr==5 & annee>2002
replace pss=. if sdrevtr==. | sdrevtr==8

/* Dummy approximation 1.5 smic et 3.5 smic */

g smic_1_5 = 1 if (sdrevtr==1 | sdrevtr==2 ) & inrange(annee, 2000, 2002)
replace smic_1_5=1 if inrange(sdrevtr, 1, 3) & inrange(annee, 2003, 2012)
replace smic_1_5=1 if inrange(sdrevtr, 1, 4) & inrange(annee, 2013, 2020)
replace smic_1_5=0 if smic_1_5==.

g smic_3_5 =1 if inrange(sdrevtr, 1, 5) & inrange(annee, 2000, 2002)
replace smic_3_5=1 if inrange(sdrevtr, 1, 6) & inrange(annee, 2003, 2020)
replace smic_3_5=0 if smic_3_5==.


* 3,5 smic = entre 1,5 et 3,5 smic



/* Regroupement cotisation CHOMAGE salarié employeur */


g tc_chom = financement[1,2]+financement[1,3]+financement[1,4] if sdstat==2 & annee==2000
replace tc_chom=0 if sdstat!=2 & annee==2000
forvalues i=1/20 {
	replace tc_chom=financement[`i'+1,2]+financement[`i'+1,3]+financement[`i'+1,4] if sdstat==2 & annee==2000+`i'
	replace tc_chom=0 if sdstat!=2 & annee==2000+`i'
}



*****************RETTRAITE**************************
 
/* H/I (tranche1) et J/K (tranche2) pour assurance vieillesse salarié du privé*/

g tc_retr_t1 = financement[1,8]+financement[1,9] if sdstat==2 & annee==2000
replace tc_retr_t1=0 if sdstat!=2 & annee==2000
forvalues i=1/20 {
	replace tc_retr_t1=financement[`i'+1,8]+financement[`i'+1,9] if sdstat==2 & annee==2000+`i'
	replace tc_retr_t1=0 if sdstat!=2 & annee==2000+`i'
}

* Vérification du codage tc_retr_t1

g tc_retr_t2 = financement[1,10]+financement[1,11] if sdstat==2 & annee==2000 & pss==1
replace tc_retr_t2=0 if tc_retr_t2==. & annee==2000 
forvalues i=1/20 {
	replace tc_retr_t2=financement[`i'+1,10]+financement[`i'+1,11] if sdstat==2 & annee==2000+`i' & pss==1
	replace tc_retr_t2=0 if tc_retr_t2==. & annee==2000+`i'
}



* Retraite du public

g tc_retr_pub = financement[1,25] + financement[1,26] if sdstat==1 & annee==2000
replace tc_retr_pub=0 if tc_retr_pub==. & annee==2000
forvalues i=1/20{
	replace tc_retr_pub=financement[1+`i',25] + financement[1+`i',26] if sdstat==1 & annee==2000+`i'
	replace tc_retr_pub=0 if tc_retr_pub==. & annee==2000+`i'
}


* Retraite indépendant

g tc_retr_ind= financement[1, 32] if inrange(sdstat, 3, 4) & annee==2000
replace tc_retr_ind=0 if tc_retr_ind==. & annee==2000
forvalues i=1/20{
	replace tc_retr_ind= financement[1 + `i', 32] if inrange(sdstat, 3, 4) & annee==2000+`i'
	replace tc_retr_ind=0 if tc_retr_ind==. & annee==2000+`i'
}


* retraites agrégées : tx public, tx privé t1, tx privé t2, tx privé complémentaire (agirc arrco), tx indépendant


gen tc_retr_tot= tc_retr_ind+ tc_retr_pub + tc_retr_t1 
/* TOTAL RETRAITE variable de taux de cotisation retraite de base public privé 
et indép excluant les retraite complémentaire et les taux spécifiques à 
des tranches de revenus */

/* TOTAL RETRAITE 2 Addition des deux taux du privé*/

gen tc_retr_tot2 = tc_retr_ind+ tc_retr_pub + tc_retr_t1  + tc_retr_t2
scatter tc_retr_tot2 annee



******************
/* complémentaire : 20 - 21 -22*/
*****************

g tc_arrco1 = financement[1, 20] if sdstat==2 & pcs8!=2 & annee==2000
g tc_arrco2 = financement[1, 21] if sdstat==2 & pcs8!=2 & pss==1 & annee==2000
g tc_agirc = financement[1, 22] if sdstat==2 & pcs8==2 & annee==2000
forvalues i = 1/20{
	replace tc_arrco1 = financement[`i'+1, 20] if sdstat==2 & pcs8!=2 & annee==2000+`i'
	replace tc_arrco2 = financement[`i'+1, 21] if sdstat==2 & pcs8!=2 & pss==1 & annee==2000+`i'
	replace tc_agirc = financement[`i'+1, 22] if sdstat==2 & pcs8==2 & annee==2000+`i'
}

* choc arrco T2 2003-2004




**************************Assurance maladie************************

/* F et G  + N? questions du périmètre des cotisations maladies du régime général */ 


g tc_am = financement[1, 6] + financement[1,7] if sdstat==2 & annee==2000 /*privé*/
replace tc_am=financement[1,23] if sdstat==1 & annee==2000 /* fonction publique d'état*/
replace tc_am=financement[1,28] if inrange(sdstat, 3,4) & annee==2000 /*indépendant*/
replace tc_am=0 if tc_am==. & annee==2000
forvalues i=1/20 {
	replace tc_am = financement[`i'+1, 6] + financement[`i'+1, 7] if sdstat==2 & annee==2000+`i'
	replace tc_am=financement[`i'+1,23] if sdstat==1 & annee==2000+`i'
	replace tc_am=financement[`i'+1,28] if inrange(sdstat, 3,4) & annee==2000+`i'
	replace tc_am = 0 if tc_am==. & annee==2000+`i'
}





* variable taux de cotisations famille par individus
g tc_famille = financement[1, 38] if annee==2000 & inrange(sdstat, 1, 2) & smic_1_5==1 /*général en dessous d'1,5smic*/
replace tc_famille=financement[1,37] if annee==2000 &  inrange(sdstat, 1, 2) & smic_1_5==0 & smic_3_5==1 /* général entre 1,5 et 3,5 smic*/
replace tc_famille= financement[1,36] if annee==2000 & inrange(sdstat, 1, 2) & smic_3_5==0 /* au dessus de 3,5 smic*/
replace tc_famille = financement[1, 30] if annee==2000 & inrange(sdstat, 3,4) /* inf PSS indépendant -> sup pss = autre variable */

forvalues i=1/20{
	replace tc_famille = financement[`i'+1, 38] if annee==2000+`i' & inrange(sdstat, 1, 2) & smic_1_5==1
	replace tc_famille= financement[`i'+1,37] if annee==2000+`i' &  inrange(sdstat, 1, 2) & smic_1_5==0 & smic_3_5==1
	replace tc_famille= financement[`i'+1,36] if annee==2000+`i' & inrange(sdstat, 1, 2) & smic_3_5==0
	replace tc_famille = financement[`i', 30] if annee==2000+`i' & inrange(sdstat, 3,4)
}
replace tc_famille=0 if tc_famille==.









