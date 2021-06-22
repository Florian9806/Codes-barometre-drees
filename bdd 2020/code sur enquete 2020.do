cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

use Baromètre20, clear


********************************************************************************
* Package à installer si besoin
********************************************************************************

* ssc install catplot
*ssc install palettes,  replace
*ssc install colrspace, replace
*ssc install grstyle, replace
*net install grc1leg, from(http://www.stata.com/users/vwiggins)
* ssc install tabplot, replace
*findit svmat2
/*insatllation de svmat2 / commande : "findit svmat2" / puis clicking “dm79 from http://www.stata.com/stb/stb56&#8221 / and then “click here to install” */
*ssc install estout
*ssc install coefplot
*ssc install gologit2

********************************************************************************
*modification des labels et des variables
********************************************************************************

/*
label drop ps1_1
label define ps1_1 1 "Ceux qui cotisent" 2 "Pas les moyens" 3 "A tous" 4 "Davantage aux cotisants mais avec minima sociaux" 5 "NSP"
label values ps1_1 ps1_1
label value ps1_2 ps1_1
label value ps1_3 ps1_1
label value ps1_4 ps1_1
*/

gen diplome=1 if sddipl==1 | sddipl==2 | sddipl==3 | sddipl==4 /*inf bac*/
replace diplome=2 if sddipl==4 
replace diplome=3 if sddipl==5 | sddipl==6 /*niveau bac*/
replace diplome=4 if sddipl==7 /*bac+1 2*/
replace diplome=5 if sddipl==8 /* bac +3 ou plus */
label define diplome 1 "inférieur au bac" 2 "CAP BEP" 3 "bac pro ou général" 4 "Bac+1ou2" 5 "bac+3 ou plus"
label value diplome diplome



* codage de la situation familiale en séparant couple avec et sans enfant et en retirant les catégories marginales

gen sitfam=1 if sdsitfam==1
replace sitfam=2 if sdsitfam==2 & sdnbenf==1 /*couple sans enfant*/
replace sitfam=3 if sdsitfam==2 & sdnbenf>1 /*couple avec enfant*/
replace sitfam=4 if sdsitfam==3 /*parent monoparental*/
replace sitfam=5 if sdsitfam==4 /*enfant du foyer*/
label define sitfam 1 "Seul" 2 "Couple sans enfant" 3 "Couple avec enfant" 4 " Parent seul" 5 "Enfant du foyer"
label value sitfam sitfam
ta sdsitfam sitfam if annee==2019, missing /*vérif du code de la var sitfam*/


/*recodage de la situation d'activité de l'individu*/
gen situa=1 if sdsitua ==1
replace situa=2 if inrange(sdsitua, 2, 3) /*temps partiel*/
replace situa=3 if sdsitua==4 /*chomage*/
replace situa=4 if sdsitua==5 /*étudiant*/
replace situa=5 if sdsitua==6 /*retraité*/
replace situa=6 if sdsitua==7 /*autre inactif*/
*si pb de taille de catégorie mettre étudiant dans autre inactif.
label define situa 1 "Temps plein" 2 "Temps partiel, intermittent.e" 3 "Chomeur.euse" 4 "Etudiant.e" 5 "Retraité.e" 6 "Autre inactif.ve"
label value situa situa

/*recodage de la situation d'activité de la personne de réf du ménage, étudiant trop peu nombreux mis dans autre inactif*/
gen prsitua=1 if sdprsitua ==1
replace prsitua=2 if inrange(sdprsitua, 2, 3) /*temps partiel*/
replace prsitua=3 if sdprsitua==4 /*chomage*/
replace prsitua=4 if sdprsitua==6 /*retraité*/
replace prsitua=5 if sdprsitua==7 | sdprsitua==5 /*autre inactif*/
label define prsitua 1 "Temps plein" 2 "Temps partiel, intermittent.e" 3 "Chomeur.euse" 4 "Retraité.e" 5 "Autre inactif.ve"
label value prsitua prsitua

/*
* variable ps2 il est souhaitable que les entreprises cotisent + - =
label drop ps2
label define ps2 1 "+ de cotisations patronales" 2 "- de cotisations patronales" 3 "Autant de cotisations" 4 "NSP"
label value ps2 ps2
*/

* recodage label variable sa8 assurance maladie : variable d'intérêt = proposition de réforme de l'assurance maladie

label variable sa8_1 "Augmenter les cotisations"
label variable sa8_2 "Limiter le remboursement pour certaines prestations"
label variable sa8_3 "Réduire la prise en charge des longues maladies"
label variable sa8_5 "Modifier habitudes des médecins pour qu'ils prescrivent moins de médicaments"
label variable sa8_6 "Limiter les tarifs des professionnels de santé"
label variable sa8_7 "Taxer plus les fabricants de médicaments"
label variable sa8_9 "Permettre aux infirmiers ou aux pharmaciens de faire certaines tâches à la place des médecins, comme le renouvellement d’ordonnances"


*recodage de l'age en 4 catégories:
gen agetr=1 if sdage<30
replace agetr=2 if sdage>=30 & sdage<50
replace agetr=3 if sdage>=50 & sdage<65
replace agetr=4 if sdage>=65
label define agetr 1 "[18-29]" 2 "[30-49]" 3 "[50-64]" 4 "[65 +"
label value agetr agetr


*PCS de la PR en 8 catégories
gen prpcs8=1 if sdprpcs10==1 | sdprpcs10==2
replace prpcs8=sdprpcs10-1 if inrange(sdprpcs10, 3, 9)
replace prpcs8=8 if sdprpcs10==10
*pcs de l'enquêté en 8 catégories
gen pcs8=1 if sdpcs10==1 | sdpcs10==2
replace pcs8=sdpcs10-1 if inrange(sdpcs10, 3, 9)
replace pcs8=8 if sdpcs10==10
label define pcs8 1 "Agri, ACCE" 2 "CPIS" 3 "PI" 4 "Employe" 5 "Ouvrier" 6 "Chomeur" 7 "Retraite" 8 "Autre Inactif"
label value pcs8 pcs8
label value prpcs8 pcs8


g pcs6_1 = pcs8
replace pcs6_1=2 if pcs8==3
replace pcs6_1=3 if pcs8==4|pcs8==5
replace pcs6_1=pcs8-2 if pcs8==6 |pcs8==7 | pcs8==8
label define pcs6_1 1 "Indépendant" 2 "CSP+" 3 "CSP-" 4 "chomeur" 5 "retraité" 6 "Autre inactif"
label value pcs6_1 pcs6_1

g pcs6_2 = pcs8
replace pcs6_2=2 if inrange(pcs8, 2, 5) & sdsitua==1
replace pcs6_2=3 if inrange(pcs8, 2, 5) & (sdsitua==2 | sdsitua==3)
replace pcs6_2=pcs8-2 if pcs8==6 |pcs8==7 | pcs8==8
label define pcs6_2 1 "Indépendant" 2 "Temps plein" 3 "Temps partiel" 4 "chomeur" 5 "retraité" 6 "Autre inactif"
label value pcs6_2 pcs6_2

g pcs6_3 = pcs8
replace pcs6_3=2 if inrange(pcs8, 2, 5) & sdstat==2
replace pcs6_3=3 if inrange(pcs8, 2, 5) & sdstat==1
replace pcs6_3=pcs8-2 if pcs8==6 |pcs8==7 | pcs8==8
label define pcs6_3 1 "Indépendant" 2 "Salarié du privé" 3 "Salarié du public" 4 "chomeur" 5 "retraité" 6 "Autre inactif"
label value pcs6_3 pcs6_3

g pcs6_4 = 1 if pcs8==1
replace pcs6_4=2 if inrange(pcs8, 2, 5) & sdsitua==1 & sdstatemp==1
replace pcs6_4=3 if inrange(pcs8, 2, 5) & (sdsitua==2 | sdsitua==3 | inrange(sdstatemp, 2, 4))
replace pcs6_4=4 if pcs8==6
replace pcs6_4=5 if pcs8==7
replace pcs6_4=6 if pcs8==8
replace pcs6_4=1 if pcs8==2 & inrange(sdact,3,4) /*CPIS indépendant*/
label define pcs6_4 1 "Indépendant" 2 "CDI à temps plein" 3 "Contrat précaire" 4 "chomeur" 5 "retraité" 6 "Autre inactif"
label value pcs6_4 pcs6_4
* attention beaucoup de NA pour les années avant 2016

label drop ps16_ab ps16_cd
label define ps16 1 "Réduire le déficit" 2 "Maintenir les prestations" 3 "NSP"
label value  ps16_ab ps16
label value  ps16_cd ps16


*****
*codage sdres (origine des revenus)
*****

label variable sdres_1 "Salaires, traitements et primes"
label variable sdres_2 "Revenu mixte"
label variable sdres_3 "RSA"
label variable sdres_4 "Allocations chômage"
label variable sdres_5 "Retraite, pré-retraite"
label variable sdres_6 "Revenus d'actifs financiers"
label variable sdres_7 "Revenus de locations"
label variable sdres_8 "Prestations familiales"
label variable sdres_9 "Allocations de logement"
label variable sdres_10 "Prestations handicap"
label variable sdres_11 "Bourses d'études"
label variable sdres_12 "Pensions alimentaires (...)"



g pcs5 = pcs6_4
replace pcs5=3 if pcs6_4==4
replace pcs5=4 if pcs6_4==5
replace pcs5=5 if pcs6_4==6
label define pcs5 1 "Indépendant" 2 "CDI temps plein" 3 "Contrat précaire" 4 "Retraité" 5 "Autres inactifs"
label value pcs5 pcs5

g PCS=1 if sdpcs10==1 | sdpcs10==2
replace PCS=2 if sdpcs10==3 | sdpcs10==4
replace PCS=3 if sdpcs10==5 | sdpcs10==6
replace PCS=4 if sdpcs10==7 | sdpcs10==9 | sdpcs10==10
replace PCS=5 if sdpcs10==8
label define PCS 1 "Agri ACCE" 2 "Libéral Cadre et PI" 3 "Employé Ouvrier" 4 "Autre inactif" 5 "Retraité"
label value PCS PCS
ta PCS
ta PCS sdpcs10




g diplome4 = diplome
replace diplome4=4 if diplome==5
label define diplome4 1 "Inf bac" 2 "CAP BEP" 3 "Bac" 4 "Sup bac"
label value diplome4 diplome4

g diplome3 = 1 if diplome4==1 | diplome4==2
replace diplome3=2 if diplome4==3
replace diplome3=3 if diplome4==4
label define diplome3 1 "inf bac" 2 "bac" 3 "sup bac"
label value diplome3 diplome3



* création de la var y = accepte une baisse d'impot oui tout à fait =1 non pas du tout =4
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4{
	g y_`lab_`i'' = 1 if ps13_a_`i'==1 | ps13_b_`i'==4 | ps13_c_`i'==1 | ps13_d_`i'==4
	replace y_`lab_`i'' = 2 if ps13_a_`i'==2 | ps13_b_`i'==3 | ps13_c_`i'==2 | ps13_d_`i'==3
	replace y_`lab_`i'' = 3 if ps13_a_`i'==3 | ps13_b_`i'==2 | ps13_c_`i'==3 | ps13_d_`i'==2
	replace y_`lab_`i'' = 4 if ps13_a_`i'==4 | ps13_b_`i'==1 | ps13_c_`i'==4 | ps13_d_`i'==1
}

* y binaire
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4{
	g y_`lab_`i''_B = 0 if y_`lab_`i''==1 | y_`lab_`i''==2
	replace y_`lab_`i''_B = 1 if y_`lab_`i''==3 | y_`lab_`i''==4
}


* y en 3 catégories
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4{
*	drop y_`lab_`i''_3
*	label drop y_`lab_`i''_3
	g y_`lab_`i''_3 = 1 if (ps13_a_`i'==1 | ps13_a_`i'==2 | ps13_b_`i'==4 | ps13_c_`i'==1 | ps13_c_`i'==2 | ps13_d_`i'==4) & annee==2020
	replace y_`lab_`i''_3 = 2 if (ps13_a_`i'==3 | ps13_b_`i'==3 | ps13_c_`i'==3 | ps13_d_`i'==3) & annee==2020
	replace y_`lab_`i''_3 = 3 if (ps13_a_`i'==4 | ps13_b_`i'==1 | ps13_b_`i'==2 | ps13_c_`i'==4 | ps13_d_`i'==1 | ps13_d_`i'==2) & annee==2020
	label define y_`lab_`i''_3 1 "Soutien baisse" 2 "Refus -" 3 "Refus +"
	label value y_`lab_`i''_3  y_`lab_`i''_3
}

destring poids, generate(npoids) float dpcomma



* variable ps13 binaire pour croiser avec ps16
label define PS13 1 "Oui" 2 "Non" 3 "NSP/NC"
foreach k in ps13_a_1 ps13_a_2 ps13_a_3 ps13_a_4 ps13_b_1 ps13_b_2 ps13_b_3 ps13_b_4 ps13_c_1 ps13_c_2 ps13_c_3 ps13_c_4 ps13_d_1 ps13_d_2 ps13_d_3 ps13_d_4 {
	g `k'_bin = 1 if `k'== 1 | `k'== 2
	replace `k'_bin=2 if `k'==3 |`k'==4
	replace `k'_bin=3 if `k'==5 |`k'==6
	label value `k'_bin PS13
}





	


















