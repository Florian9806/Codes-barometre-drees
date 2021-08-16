cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"


do 8_1_taux_cotis



********************************************************************************
/* représentation graphique des taux de cotisations regroupé par branche ou par type*/
********************************************************************************

***** Graphe de tous les taux de cotisations*****

local taux_cotis_list : colnames financement
foreach i in `taux_cotis_list' {
	line `i' Annee, name(`i', replace) title(`i')
}



* Taux de cotisation agrégé (n'a aucun sens économique)
egen total = rowtotal(F_*)
line total Annee

/* allocations chômages total*/
g F_D = F_A + F_B + F_C 
line F_D Annee, xtitle("") ytitle("") title("Taux de cotisations allocations chômage" "(secteur privé seulement)")

* Complémentaire retraite du privé
tw (line F_U Annee) (line F_V Annee) (line F_W Annee), legend(order(1 "Arrco T1" 2 "Arrco T2" 3 "Agirc"))

* CSG retraité
tw (line F_R Annee) (line F_S Annee) (line F_T Annee)



/* famille régime indépendant */
tw (line F_AE Annee) (line F_AF Annee)


/* famille régime général*/
tw (line F_AK Annee) (line F_AL Annee) (line F_AM Annee)


/* famille sur l'ensemble des actifs en emploi */
tw (line F_AK Annee) (line F_AL Annee) (line F_AM Annee) (scatter F_AE Annee) ///
(scatter F_AF Annee, msymbol(triangle) msize(small)), name(CotisFam, replace)


** AM public et privé
tw (line tc_am annee if sdstat==1) (line tc_am annee if sdstat==2) (line tc_am annee if inrange(sdstat,3,4)), title(Taux de cotisation pour l'assurance maladie) xtitle("") ytitle("") legend(order(1 "Salarié du privé" 2 "Salarié du public" 3 "Indépendant")) /* petit choc en 2016*/

** Retraite public privé indépendant
tw (line tc_retr_tot2 annee if sdstat==1, yaxis(1)) (line tc_retr_tot2 annee if tc_retr_ind!=0, yaxis(2)) (line tc_retr_tot2 annee if tc_retr_t1!=0 & tc_retr_t2==0 , yaxis(2))(line tc_retr_tot2 annee if tc_retr_t2!=0 , yaxis(2)), legend(order(1 "Public (axe de gauche)" 2 "Indépendant" 3 "Privé T1" 4 "Privé T2"))

* Indep vérif codage
tw (line tc_retr_tot2 annee if tc_retr_ind!=0) (scatter F_AG Annee)
tw (line tc_retr_ind annee if inrange(sdstat, 3, 4)) (line F_AG Annee)

* Retraite privé et indépendant  (employeur et salarié séparé)
tw (line F_AG Annee) (line F_H Annee) (line F_I Annee)  (line F_J Annee) (line F_K Annee)

* retraite public
tw (line tc_retr_pub annee if sdstat==1) (line F_Z Annee) (line F_AA Annee), title(Cotisation retraite du publique) legend(order(1 "Taux de cotisations total" 2 "Taux de cotisations employeur (l'état)" 3 "Taux de cotisations salariales") rows(3)) name(ret_pub, replace)


* Vérification du codage tc_retr_t2
tw (line tc_retr_t2 annee if sdstat==2 & pss==1) (line F_J Annee) (line F_K Annee) /* Augmentation sup à 0.5 ppct entre 2013 et 2017*/
tw (line tc_retr_t1 annee if sdstat==2, yaxis(1)) (line tc_retr_t2 annee if sdstat==2 & pss==1, yaxis(2)), name(retr_priv, replace)
tw (line tc_retr_t1 annee if sdstat==2, yaxis(2)) (line F_H Annee, yaxis(1)) (line F_I Annee, yaxis(1))
*augmentation continue des cotisations, choc assez important en 2011 et 2013 (période 2011 à 2015) +0,6 ppct environ en 4 ans.
line tc_chom annee if sdstat==2 /* gros choc en 2018, petit choc en 2002*/

* Retraite total, graphique bien présenté
tw (line tc_retr_t1 annee if sdstat==2) (scatter tc_retr_tot2 annee if sdstat==2 & pss==1)  (line tc_retr_pub annee if sdstat==1) (line tc_retr_ind annee if inrange(sdstat, 3, 4)), legend(order(1 "Privé tranche 1" 2 "Privé tranche 2" 3 "Public" 4 "Indépendant")) xtitle("") title(Taux de cotisations régimes de retraite)
tw (line tc_retr_t1 annee if sdstat==2) (scatter tc_retr_tot2 annee if sdstat==2 & pss==1)   (line tc_retr_ind annee if inrange(sdstat, 3, 4)), legend(order(1 "Privé tranche 1" 2 "Privé tranche 2" 3 "Indépendant")) xtitle("") title(Taux de cotisations régimes de retraite)

* Alloc familiales (bien présenté)
tw (line F_AK Annee) (line F_AL Annee) (line F_AM Annee) (scatter F_AE Annee) ///
	(scatter F_AF Annee, msymbol(triangle) msize(small)), ///
	legend(order(1 "Régime général en dessous d'1,5 Smic" 2 "Régime général entre 1,5 et 3,5 Smic" ///
	3 "Régime général au dessus de 3,5 Smic" 4 "Régime indépendant en dessous du PSS" 5 "Régime indépendant au dessus du PSS")) ///
	xtitle("") ytitle("") title(Cotisations sociales allocations familiales)



* Cotisations secteurs privé:
* Taux bas (inclut baisse de cotisations Hollande similaire à des exo sur cotisations allocations familiales)
tw (line tc_am annee if sdstat==2) (line tc_retr_t1 annee if sdstat==2) (line F_AK Annee) (line tc_chom annee if tc_chom!=0), xtitle("") ytitle("") legend(order(1 "Assurance maladie" 2 "Retraite" 3 "Allocations familiales" 4 "Allocations chômage")) title(Taux de cotisations du secteur privé sur les bas salaire par branche)

* Taux de cotisations secteur public en dessous du PSS et sans complémentaire retraite
tw (line tc_am annee if sdstat==1) (line tc_retr_tot2 annee if sdstat==1) (line F_AK Annee), xtitle("") ytitle("") legend(order(1 "Assurance maladie" 2 "Retraite" 3 "Allocations familiales")) title(Taux de cotisations du secteur public sur les bas salaire par branche)

tw (line tc_am annee if inrange(sdstat, 3, 4)) (line tc_retr_tot2 annee if inrange(sdstat, 3, 4)) (line F_AE Annee) (scatter F_AF Annee), xtitle("") ytitle("") legend(order(1 "Assurance maladie" 2 "Retraite" 3 "Allocations familiales tranche 1" 4 "Allocations familiales tranche 2")) title(Taux de cotisations des indépendants)

