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
	g y_`lab_`i''_3 = 1 if ps13_a_`i'==1 | ps13_a_`i'==2 | ps13_b_`i'==4 | ps13_c_`i'==1 | ps13_c_`i'==2 | ps13_d_`i'==4
	replace y_`lab_`i''_3 = 2 if ps13_a_`i'==3 | ps13_b_`i'==3 | ps13_c_`i'==3 | ps13_d_`i'==3
	replace y_`lab_`i''_3 = 3 if ps13_a_`i'==4 | ps13_b_`i'==1 | ps13_b_`i'==2 | ps13_c_`i'==4 | ps13_d_`i'==1 | ps13_d_`i'==2
	label define y_`lab_`i''_3 1 "Soutien baisse" 2 "Refus -" 3 "Refus +"
	label value y_`lab_`i''_3  y_`lab_`i''_3
}

destring poids, generate(npoids) float dpcomma

/* Graphique code: boucle pour sortir série de graph soc-dem */

global sociodem1 "sdagetr sitfam  pcs8 diplome sdnivie pcs6_4"

colorpalette viridis, select(3 8 13) nograph


grstyle init
grstyle set mesh, compact
grstyle set color "70 50 127" "33 144 140" "159 218 58" , ipolate(5) 

foreach i in $sociodem1 {
    catplot ps1_ab_1  if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars 	blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) ///
	legend(pos(1) color(gs5)) ///
	b1title("Assurance maladie par `i' ") ///
	vertical stack name(G1, replace) nodraw

	catplot ps1_ab_2 if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars 	blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) legend(off) ///
	b1title("Système de retraite par `i' ") ///
	vertical stack name(G2, replace) nodraw

	catplot ps1_ab_3 if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars 	blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) legend(off) ///
	b1title("Allocation familiale par `i' ") ///
	vertical stack name(G3, replace) nodraw

	catplot ps1_ab_4 if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars 	blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) legend(off) ///
	b1title("Allocation chomage par `i'") ///
	vertical stack name(G4, replace) nodraw

	grc1leg G1 G2 G3 G4, legendfrom(G1) title(Type de système par prestation et par `i') iscale(0.7)
	graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps1_`i'.png", replace
    
}

foreach i in $sociodem1 {
    catplot ps1_cd_1  if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars 	blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) ///
	legend(pos(1) color(gs5)) ///
	b1title("Assurance maladie par `i' ") ///
	vertical stack name(G1, replace) nodraw

	catplot ps1_cd_2 if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars 	blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) legend(off) ///
	b1title("Système de retraite par `i' ") ///
	vertical stack name(G2, replace) nodraw

	catplot ps1_cd_3 if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars 	blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) legend(off) ///
	b1title("Allocation familiale par `i' ") ///
	vertical stack name(G3, replace) nodraw

	catplot ps1_cd_4 if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars 	blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) legend(off) ///
	b1title("Allocation chomage par `i'") ///
	vertical stack name(G4, replace) nodraw

	grc1leg G1 G2 G3 G4, legendfrom(G1) title(Type de système par prestation et par `i') iscale(0.7)
	graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps1covid_`i'.png", replace
    
}


* question 13 
grstyle init
grstyle set mesh, compact
*grstyle set color "70 50 127" "33 144 140" "159 218 58" , ipolate(4)


local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
/* analyse A vs B effet par catégories socio-dem*/
forvalues j=1/4{
	foreach i in $sociodem1 {
		catplot y_`lab_`j'' if annee==2020 & (sdsplit==1 | sdsplit==2), over(`i', label(labsize(vsmall) labcolor(black))) over(sdsplit) percent(`i') asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations") vertical stack
	}
}


/* Analyse AvB effet agrégé*/
catplot y_AM if annee==2020 & (sdsplit==1 | sdsplit==2), over(sdsplit, relabel(1 "A: Accepte baisse prestations" 2 "B: Refuse hausse prestations") label(labsize(vsmall) labcolor(black) angle(10))) percent(sdsplit) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Branche assurance maladie") vertical legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt" 4 "Non pas du tout")) name(GA1, replace) nodraw
catplot y_Chomage if annee==2020 & (sdsplit==1 | sdsplit==2), over(sdsplit, relabel(1 "A: Accepte baisse prestations" 2 "B: Refuse hausse prestations") label(labsize(vsmall) labcolor(black) angle(10))) percent(sdsplit) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Branche allocations chômages") vertical name(GA2, replace) nodraw
grc1leg GA1 GA2, legendfrom(GA1) title(Soutien en fonction du questionnaire) iscale(0.9)


/* Analyse AvB effet agrégé*/
catplot ps13_a_1 if annee==2020 & ps13_a_1<5,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("A: Accepte une baisse", size(vsmall)) vertical legend( pos(1) color(gs5))  name(GA1, replace) nodraw

catplot ps13_b_1 if annee==2020 & ps13_b_1<5 , percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("B: Accepte une hausse", size(vsmall)) vertical legend( pos(1) color(gs5)) name(GA2, replace) nodraw
grc1leg GA1 GA2, legendfrom(GA1) title(Soutien à l'assurance maladie) iscale(0.9) name(G1, replace)

catplot ps13_a_4 if annee==2020 & ps13_a_4<5,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("A: Accepte une baisse", size(vsmall)) vertical legend( pos(1) color(gs5))  name(GA3, replace) nodraw

catplot ps13_b_4 if annee==2020 & ps13_b_4<5 , percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("B: Accepte une hausse", size(vsmall)) vertical legend( pos(1) color(gs5)) name(GA4, replace) nodraw
grc1leg GA3 GA4, legendfrom(GA3) title(Soutien aux allocations chômages) iscale(0.9) name(G2, replace)
grc1leg G1 G2, legendfrom(G1) title("Comparaison des questionnaire A et B" "Chomage et maladie")








forvalues j=1/4{
	foreach i in $sociodem1 {
		catplot ps13_a_`j' if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations") vertical stack name(G1, replace) nodraw

		catplot ps13_b_`j' if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse d'impots") vertical stack name(G2, replace) nodraw

		catplot ps13_c_`j' if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse d'impots") vertical stack name(G3, replace) nodraw

		catplot ps13_d_`j' if annee==2020, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse de prestations") vertical stack name(G4, replace) nodraw

		grc1leg G1 G2 G3 G4, legendfrom(G1) title(branche `lab_`j'' par variable `i') iscale(0.6)
		graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13_`j'_`i'.png", replace
		
	}
}


catplot ps13_a_1 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations AM") vertical stack name(GA1, replace) nodraw
catplot ps13_b_1 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse impots AM") vertical stack name(GB1, replace) nodraw
catplot ps13_c_1 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse impots AM") vertical stack name(GC1, replace) nodraw
catplot ps13_d_1 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse prestation AM") vertical stack name(GD1, replace) nodraw
grc1leg GA1 GC1 GD1 GB1, legendfrom(GA1) iscale(0.6) row(1) col(4) name(AM, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13AM.png", replace


catplot ps13_a_2 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations retraite") vertical stack name(GA2, replace) nodraw
catplot ps13_b_2 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse impots retraite") vertical stack name(GB2, replace) nodraw
catplot ps13_c_2 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse impots retraite") vertical stack name(GC2, replace) nodraw
catplot ps13_d_2 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse prestation retraite") vertical stack name(GD2, replace) nodraw
grc1leg GA2 GC2 GD2 GB2, legendfrom(GA2) iscale(0.6) row(1) col(4) name(Retraite, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13Retraite.png", replace

catplot ps13_a_3 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations famille") vertical stack name(GA3, replace) nodraw
catplot ps13_b_3 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse impots famille") vertical stack name(GB3, replace) nodraw
catplot ps13_c_3 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse impots famille") vertical stack name(GC3, replace) nodraw
catplot ps13_d_3 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse prestation famille") vertical stack name(GD3, replace) nodraw
grc1leg GA3 GC3 GD3 GB3, legendfrom(GA3) iscale(0.6) row(1) col(4) name(Famille, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13famille.png", replace


catplot ps13_a_4 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations chomage") vertical stack name(GA4, replace) nodraw
catplot ps13_b_4 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse impots chomage") vertical stack name(GB4, replace) nodraw
catplot ps13_c_4 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse impots chomage") vertical stack name(GC4, replace) nodraw
catplot ps13_d_4 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse prestation chomage") vertical stack name(GD4, replace) nodraw
grc1leg GA4 GC4 GD4 GB4, legendfrom(GA4) iscale(0.6) row(1) col(4) name(chomage, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13chomage.png", replace

grc1leg AM Retraite Famille chomage, legendfrom(AM) iscale(0.6) row(2) col(2) name(total, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13total.png", replace


/*
catplot ps1_1 if annee>=2016, over(pcs8, label(labsize(vsmall) labcolor(black))) percent(pcs8) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Assurance maladie par PCS de la PR") vertical stack name(G1, replace)

catplot ps1_2 if annee>=2016, over(pcs8, label(labsize(vsmall) labcolor(black))) percent(pcs8) asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Système de retraite par PCS de la PR") vertical stack name(G2, replace)

catplot ps1_3 if annee>=2016, over(pcs8, label(labsize(vsmall) labcolor(black))) percent(pcs8) asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Allocation familiale par PCS de la PR") vertical stack name(G3, replace)

catplot ps1_4 if annee>=2016, over(pcs8, label(labsize(vsmall) labcolor(black))) percent(pcs8) asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Allocation chomage par PCS de la PR") vertical stack name(G4, replace)

grc1leg G1 G2 G3 G4, legendfrom(G1)
*/


*************************
* PS16 question sur le déficit
*************************
grstyle init
grstyle set mesh, compact
grstyle set color "70 50 127" "33 144 140" "159 218 58" , ipolate(3) 


catplot ps16_ab if annee==2020, percent asyvars legend(pos(1) color(black))blabel(bar, position(center) format(%3.1f) color(white) size(small)) b1title("2020") vertical stack name(G1, replace) nodraw
catplot ps16_cd if annee==2020, percent asyvars legend(pos(1) color(gs5))blabel(bar, position(center) format(%3.1f) color(white) size(small)) b1title("En temps de crise, 2020") vertical stack name(G2, replace) nodraw
catplot ps16_ab if annee<2020, percent asyvars legend(pos(1) color(gs5))blabel(bar, position(center) format(%3.1f) color(white) size(small)) b1title("Avant 2020") vertical stack name(G3, replace) nodraw
grc1leg G3 G1 G2, legendfrom(G1) row(1) col(3) title(Réduire le déficit ou maintenir les prestations)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps16total.png", replace

*********

catplot ps16_ab if annee==2020, over(pcs6_4, label(labsize(vsmall) labcolor(black) angle(45))) percent(pcs6_4) asyvars legend(pos(1) color(black))blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("2020") vertical stack name(G1, replace) nodraw

catplot ps16_cd if annee==2020, over(pcs6_4, label(labsize(vsmall) labcolor(black) angle(45))) percent(pcs6_4) asyvars legend(pos(1) color(gs5))blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("En temps de crise, 2020") vertical stack name(G2, replace) nodraw

catplot ps16_ab if annee<2020, over(pcs6_4, label(labsize(vsmall) labcolor(black) angle(45))) percent(pcs6_4) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Avant 2020") vertical stack name(G3, replace) nodraw

grc1leg G3 G1 G2, legendfrom(G1) row(1) col(3) title(Réduire le déficit ou maintenir les prestations)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps16pcs64.png", replace

**********
* variable ps13 binaire pour croiser avec ps16
label define PS13 1 "Oui" 2 "Non" 3 "NSP/NC"
foreach k in ps13_a_1 ps13_a_2 ps13_a_3 ps13_a_4 ps13_b_1 ps13_b_2 ps13_b_3 ps13_b_4 ps13_c_1 ps13_c_2 ps13_c_3 ps13_c_4 ps13_d_1 ps13_d_2 ps13_d_3 ps13_d_4 {
	g `k'_bin = 1 if `k'== 1 | `k'== 2
	replace `k'_bin=2 if `k'==3 |`k'==4
	replace `k'_bin=3 if `k'==5 |`k'==6
	label value `k'_bin PS13
}
/*
foreach k in ps13_a_1 ps13_a_2 ps13_a_3 ps13_a_4 ps13_b_1 ps13_b_2 ps13_b_3 ps13_b_4 ps13_c_1 ps13_c_2 ps13_c_3 ps13_c_4 ps13_d_1 ps13_d_2 ps13_d_3 ps13_d_4 {
	drop `k'_bin
}
*/

foreach k in ps13_a_1 ps13_a_2 ps13_a_3 ps13_a_4 ps13_b_1 ps13_b_2 ps13_b_3 ps13_b_4 {
	catplot ps16_ab if annee==2020 & `k'_bin!=3, over(`k'_bin, label(labsize(vsmall) labcolor(black) angle(45))) percent(`k'_bin) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title(`k') vertical stack name(G`k', replace) nodraw
}
foreach k in ps13_c_1 ps13_c_2 ps13_c_3 ps13_c_4 ps13_d_1 ps13_d_2 ps13_d_3 ps13_d_4 {
	catplot ps16_cd if annee==2020  & `k'_bin!=3, over(`k'_bin, label(labsize(vsmall) labcolor(black) angle(45))) percent(`k'_bin) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title(`k') vertical stack name(G`k', replace) nodraw
}

grc1leg Gps13_a_1 Gps13_b_1 Gps13_c_1 Gps13_d_1, legendfrom(Gps13_a_1) row(1) col(4)
grc1leg Gps13_a_2 Gps13_b_2 Gps13_c_2 Gps13_d_2, legendfrom(Gps13_a_2) row(1) col(4)
grc1leg Gps13_a_3 Gps13_b_3 Gps13_c_3 Gps13_d_3, legendfrom(Gps13_a_3) row(1) col(4)
grc1leg Gps13_a_4 Gps13_b_4 Gps13_c_4 Gps13_d_4, legendfrom(Gps13_a_4) row(1) col(4)


********************************************************************************
*pseudo panel approfondi
********************************************************************************

*Recodage des variables ps13 en dummy


forvalues i=1/4 {
	g oui_ps13_a_`i' = (inrange(ps13_a_`i',1,2)) if annee==2020 & sdsplit==1 /* accepte baisse prestation/impots */
	g non_ps13_b_`i' = (inrange(ps13_b_`i',3,4)) if annee==2020 & sdsplit==2
	g non_ps13_a_`i' = (inrange(ps13_a_`i',3,4)) if annee==2020 & sdsplit==1
	g non_ps13_c_`i' = (inrange(ps13_c_`i',3,4)) if annee==2020 & sdsplit==3
	g non_ps13_d_`i' = (inrange(ps13_d_`i',3,4)) if annee==2020 & sdsplit==4
}




local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4 {
	catplot oui_ps13_a_`i', percent asyvars legend(pos(1) color(gs5) order(1 "Non" 2 "Oui")) ytitle(%, size(vsmall)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien" "baisse des presta" `lab_`i'', size(vsmall)) vertical stack name(Goui_ps13_a_`i', replace) nodraw
	catplot non_ps13_b_`i' , percent asyvars legend(pos(1) color(gs5) order(1 "Non" 2 "Oui"))  ytitle(%, size(vsmall)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Refus" "hausse d'impots" `lab_`i'', size(vsmall)) vertical stack name(Gnon_ps13_b_`i', replace) nodraw
	catplot non_ps13_a_`i' , percent asyvars legend(pos(1) color(gs5) order(1 "Non" 2 "Oui"))  ytitle(%, size(vsmall)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Refus" "baisse de presta" `lab_`i'', size(vsmall)) vertical stack name(Gnon_ps13_a_`i', replace) nodraw
	catplot non_ps13_c_`i' , percent asyvars legend(pos(1) color(gs5) order(1 "Non" 2 "Oui"))  ytitle(%, size(vsmall)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Refus" "baisse d'impots" `lab_`i'', size(vsmall)) vertical stack name(Gnon_ps13_c_`i', replace) nodraw
	catplot non_ps13_d_`i' , percent asyvars legend(pos(1) color(gs5) order(1 "Non" 2 "Oui"))  ytitle(%, size(vsmall)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Refus" "hausse des presta" `lab_`i'', size(vsmall)) vertical stack name(Gnon_ps13_d_`i', replace) nodraw
}

grc1leg Goui_ps13_a_1 Gnon_ps13_b_1 Goui_ps13_a_2 Gnon_ps13_b_2 Goui_ps13_a_3 Gnon_ps13_b_3 Goui_ps13_a_4 Gnon_ps13_b_4, legendfrom(Goui_ps13_a_1) row(2) col(4) iscale(0.8) title(Statu quo 1)
grc1leg Goui_ps13_a_1 Gnon_ps13_d_1 Goui_ps13_a_2 Gnon_ps13_d_2 Goui_ps13_a_3 Gnon_ps13_d_3 Goui_ps13_a_4 Gnon_ps13_d_4, legendfrom(Goui_ps13_a_1) row(2) col(4) iscale(0.6) title(Statu quo 2)

grc1leg Goui_ps13_a_1 Gnon_ps13_b_1 Goui_ps13_a_2 Gnon_ps13_b_2 Goui_ps13_a_3 Gnon_ps13_b_3 Goui_ps13_a_4 Gnon_ps13_b_4 ///
Goui_ps13_a_1 Gnon_ps13_d_1 Goui_ps13_a_2 Gnon_ps13_d_2 Goui_ps13_a_3 Gnon_ps13_d_3 Goui_ps13_a_4 Gnon_ps13_d_4 ///
, legendfrom(Goui_ps13_a_1) row(2) col(8) iscale(0.65) title(Statu quo)


grc1leg Gnon_ps13_a_1 Gnon_ps13_c_1 Gnon_ps13_a_2 Gnon_ps13_c_2 Gnon_ps13_a_3 Gnon_ps13_c_3 Gnon_ps13_a_4 Gnon_ps13_c_4, legendfrom(Gnon_ps13_a_1) row(2) col(4) iscale(0.8) title(Changement de formulation 1)
grc1leg Gnon_ps13_b_1 Gnon_ps13_d_1 Gnon_ps13_b_2 Gnon_ps13_d_2 Gnon_ps13_b_3 Gnon_ps13_d_3 Gnon_ps13_b_4 Gnon_ps13_d_4, legendfrom(Gnon_ps13_b_1) row(2) col(4) iscale(0.8) title(Changement de formulation 2)

*drop if annee!=2020 /* attention à ne pas sauvegarder les données après avoir fait tourner drop*/
forvalues i=1/4 {
	foreach k in oui_ps13_a_`i' non_ps13_b_`i' non_ps13_a_`i' non_ps13_c_`i' non_ps13_d_`i' {
		bysort pcs5 sdsplit: egen M_`k'_pcs = mean(`k')
		bysort sdagetr sdsplit: egen M_`k'_age = mean(`k')
		bysort sdnivie sdsplit: egen M_`k'_revenu = mean(`k')
		bysort sdsexe sdsplit: egen M_`k'_sexe = mean(`k')
	}
}


graph dot (mean) M_oui_ps13_a_4_revenu M_non_ps13_b_4_revenu, over(sdnivie) vertical legend(order(1 "Accepte une baisse des allocations chômage" 2 "Refuse une hausse des impôts")) title(Par quintile de revenu)
graph dot (mean) M_oui_ps13_a_4_age M_non_ps13_b_4_age, over(sdagetr) vertical legend(order(1 "Accepte une baisse des allocations chômage" 2 "Refuse une hausse des impôts")) title(Par tranche d'age')

graph dot (mean) M_oui_ps13_a_1_pcs M_non_ps13_b_1_pcs M_oui_ps13_a_2_pcs M_non_ps13_b_2_pcs M_oui_ps13_a_3_pcs M_non_ps13_b_3_pcs M_oui_ps13_a_4_pcs M_non_ps13_b_4_pcs, over(pcs5) vertical legend(order(1 "Accepte baisse AM" 2 "refuse hausse impot AM" 3 "Accepte baisse Retraite" 4 " refuse hausse impots retraite" 5 "accepte baisse AF" 6 "Refuse hausse impots AF" 7 "Accepte baisse chômage" 8 "Refuse hausse impôts chom") size(small)) title(Par PCS)


graph dot (mean) M_oui_ps13_a_1_age M_non_ps13_b_1_age M_oui_ps13_a_2_age M_non_ps13_b_2_age M_oui_ps13_a_3_age M_non_ps13_b_3_age M_oui_ps13_a_4_age M_non_ps13_b_4_age, over(sdagetr) vertical legend(order(1 "Accepte baisse AM" 2 "refuse hausse impot AM" 3 "Accepte baisse Retraite" 4 " refuse hausse impots retraite" 5 "accepte baisse AF" 6 "Refuse hausse impots AF" 7 "Accepte baisse chômage" 8 "Refuse hausse impôts chom") size(small)) title(Par PCS)


*************************
* Regression pseudo panel
*************************




* regression

reg y_AM i.sdsplit if annee==2020


eststo clear
eststo: qui reg y_AM ib2.pcs6_4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Retraite ib2.pcs6_4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Famille ib2.pcs6_4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Chomage ib2.pcs6_4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit if annee==2020
esttab using REG_PP_1.tex, keep(*.sdsplit) f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) replace
pwcompare sdsplit, eff 

eststo clear
eststo: qui reg y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Retraite ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Famille ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Chomage ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
esttab

label define sdnivie 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5"
label value sdnivie sdnivie /* Inutile lorsqu'on utilise le revenu en var continu*/
label variable sdnivie "Quintiles niveau de vie"
* niveau de vie
eststo clear
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
esttab using ologit_1.csv, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) replace
esttab using ologit_1.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f replace

coefplot est1 est2 est3 est4, keep(*sdnivie) baselevel xline(0) legend(size(small))

*PCS
eststo clear
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit if annee==2020, or
esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged)
esttab using ologit_2.csv, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged)
esttab using ologit_2.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f replace


eststo clear
eststo: qui ologit y_AM i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged)
esttab using ologit_3.csv, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) replace
esttab using ologit_3.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f replace


* croisement de toue les variables
eststo clear
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
predict pred_AM_1 pred_AM_2 pred_AM_3 pred_AM_4 if annee==2020, pr
eststo: qui ologit y_Retraite ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2b.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or


esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged)

eststo clear
eststo: qui reg y_AM i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
eststo: qui reg y_AM  i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, vce(robust)
eststo: qui reg y_AM  i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, vce(cluster sdsplit)
esttab, scalar(r2_p ll converged)
coefplot est2, keep(*sdnivie) xline(0) baselevel levels(99)
coefplot est1, keep(*sdnivie) xline(0) baselevel levels(90)


eststo clear
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit if annee==2020, vce(cluster sdsplit)
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit if annee==2020
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit if annee==2020, vce(robust)
esttab, scalar(r2_p ll converged)
coefplot est2, keep(*sdnivie) xline(0) baselevel levels(99)
coefplot est1, keep(*sdnivie) xline(0) baselevel levels(90)


********
* Statu quo et quintile
********
grstyle init
grstyle set mesh, compact

program drop SQ_matrice

/* 4 paramètre à entrer: 1=variable présente dans la regression logit, 2=branche (AM, Retraite, Famille ou Chomage) 
3=1er type de questionnaire (=1/4), 4=2e type de questionnaire (=1/4)*/
program SQ_matrice 
	qui logit y_`2'_B ib2.pcs5 i.diplome4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.diplome4#i.sdsplit i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
	qui margins 1.`1'#`3'.sdsplit 1.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_1 = r(table_vs)
	qui margins 2.`1'#`3'.sdsplit 2.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_2 = r(table_vs)
	qui margins 3.`1'#`3'.sdsplit 3.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_3 = r(table_vs)
	qui margins 4.`1'#`3'.sdsplit 4.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_4 = r(table_vs)
	qui margins 5.`1'#`3'.sdsplit 5.`1'#`4'.sdsplit, pwcompare 
	mat SQ_`2'_`1'_5 = r(table_vs)
	mat SQ_`2'_`1' = SQ_`2'_`1'_1,SQ_`2'_`1'_2,SQ_`2'_`1'_3,SQ_`2'_`1'_4,SQ_`2'_`1'_5
	matrix rownames SQ_`2'_`1' = coef_`2' se_`2' z_`2' pvalue_`2' cil_`2' ciu_`2' df_`2' crit_`2' eform_`2'
	matrix SQ_`2'_`1' = -SQ_`2'_`1'
	matrix SQ_`2'_`1'_t = SQ_`2'_`1''
	svmat SQ_`2'_`1'_t, name(col)
end

/*pcs*/
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4 {
	SQ_matrice pcs5 `lab_`i'' 1 4
	twoway (dot coef_`lab_`i'' ident, mcolor(red) lpattern(solid) cmissing(n)) (line cil_`lab_`i'' ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) (line ciu_`lab_`i'' ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) in 1/5, xlabel(200000001 "Indép" 200000002 "CDI" 200000003 "Précaire" 200000004 "Retraité" 200000005 "Autres Inact") title(Branche `lab_`i'') legend(order(1 "Proportion de soutien au satu quo" 2 "Intervalle de confiance")) name(`lab_`i'', replace) xtitle(PCS) nodraw
	drop *_`lab_`i''
}
grc1leg AM Retraite Famille Chomage, legendfrom(AM) row(2) col(2) title(Soutien au statu quo par PCS)

*graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\2020\graph intéressant\statuquopcs.png", as(png) name("Graph") replace

/*age*/
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4 {
	SQ_matrice sdagetr `lab_`i'' 1 2
	twoway (dot coef_`lab_`i'' ident, mcolor(red) lpattern(solid) cmissing(n)) (line cil_`lab_`i'' ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) (line ciu_`lab_`i'' ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) in 1/5, xlabel(200000001 "18-25" 200000002 "25-35" 200000003 "35-45" 200000004 "45-65" 200000005 "65+") title(Branche `lab_`i'') legend(order(1 "Proportion de soutien au satu quo" 2 "Intervalle de confiance")) name(`lab_`i'', replace) xtitle(Tranche d'âge) nodraw
	drop *_`lab_`i''
}
grc1leg AM Retraite Famille Chomage, legendfrom(AM) row(2) col(2) title(Soutien au statu quo par tranche d'âge)

/*sexe*/
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4 {
	SQ_matrice sdsexe `lab_`i'' 1 2
	twoway (dot coef_`lab_`i'' ident, mcolor(red) lpattern(solid) cmissing(n)) (line cil_`lab_`i'' ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) (line ciu_`lab_`i'' ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) in 1/2, xlabel(200000001 "Homme" 200000002 "Femme") title(Branche `lab_`i'') legend(order(1 "Proportion de soutien au satu quo" 2 "Intervalle de confiance")) name(`lab_`i'', replace) xtitle(sexe) nodraw
	drop *_`lab_`i''
}
grc1leg AM Retraite Famille Chomage, legendfrom(AM) row(2) col(2) title(Soutien au statu quo par sexe)

/*diplome*/
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4 {
	SQ_matrice diplome4 `lab_`i'' 4 2
	twoway (dot coef_`lab_`i'' ident, mcolor(red) lpattern(solid) cmissing(n)) (line cil_`lab_`i'' ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) (line ciu_`lab_`i'' ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) in 1/4, xlabel(200000001 "inf bac" 200000002 "CAP BEP" 200000003 "Bac" 200000004 "Sup bac") title(Branche `lab_`i'') legend(order(1 "Proportion de soutien au satu quo" 2 "Intervalle de confiance")) name(`lab_`i'', replace) xtitle(diplome4) nodraw
	drop *_`lab_`i''
}
grc1leg AM Retraite Famille Chomage, legendfrom(AM) row(2) col(2) title(Incohérence 2 par diplome (BD))


*********************************************************************************
*gologit2
*********************************************************************************
eststo clear
eststo: qui gologit2 y_AM ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Retraite ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Famille ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Chomage ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
esttab, eform label







********************************************************************************
* ologit en 3 catégories
********************************************************************************


*Stat desc AM et chomage sur la répartition des réponses (à utiliser  pour justifier le formatage de la variable en 3 catégories?)
catplot y_AM if annee==2020, over(sdsplit) vertical asyvars percent(sdsplit) blabel(bar, position(top) format(%3.1f) color(black)) legend(order(1 "Accepte baisse/Refus Hausse +" 2 "Accepte baisse/ Refus hause -" 3 "Refus baisse/Accepte hausse -" 4 "Refuse baisse/Accepte hausse +")) title(Variable de soutien en quatre catégories sur l'assurance maladie)
catplot y_AM_3 if annee==2020, over(sdsplit) vertical asyvars percent(sdsplit) blabel(bar, position(top) format(%3.1f) color(black))  legend(order(1 "(Accepte baisse) (Refus Hausse +)" 2 "Refus baisse et hausse -" 3 "(Refus baisse +) (Accepte hausse)")) title(Variable de soutien en trois catégories sur l'assurance maladie)
catplot y_Chomage if annee==2020, over(sdsplit) vertical asyvars percent(sdsplit) blabel(bar, position(top) format(%3.1f) color(black)) legend(order(1 "Accepte baisse/Refus Hausse +" 2 "Accepte baisse/ Refus hause -" 3 "Refus baisse/Accepte hausse -" 4 "Refuse baisse/Accepte hausse +")) title(Variable de soutien en quatre catégories sur les allocations chômages)
catplot y_Chomage_3 if annee==2020, over(sdsplit) vertical asyvars percent(sdsplit) blabel(bar, position(top) format(%3.1f) color(black))  legend(order(1 "(Accepte baisse) (Refus Hausse +)" 2 "Refus baisse et hausse -" 3 "(Refus baisse +) (Accepte hausse)")) title(Variable de soutien en trois catégories sur les allocations chômages)

eststo clear
eststo: qui reg y_AM_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Retraite_3 ib2.pcs6_4 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Famille_3 ib2.pcs6_4 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Chomage_3 ib2.pcs6_4 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
esttab using regppy3.tex, keep(*.sdsplit) f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) replace

/*
eststo clear
eststo: qui ologit y_AM_3 ib2.pcs8 i.sdagetr i.sdsexe i.sdsplit if annee==2020
eststo: qui ologit y_Retraite_3 ib2.pcs8 i.sdagetr i.sdsexe i.sdsplit if annee==2020
eststo: qui ologit y_Famille_3 ib2.pcs8 i.sdagetr i.sdsexe i.sdsplit if annee==2020
eststo: qui ologit y_Chomage_3 ib2.pcs8 i.sdagetr i.sdsexe i.sdsplit if annee==2020
esttab, f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) eform


eststo clear
eststo: qui ologit y_AM_3 ib4.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020
eststo: qui ologit y_Retraite_3 ib4.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020
eststo: qui ologit y_Famille_3 ib4.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020
eststo: qui ologit y_Chomage_3 ib4.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020
esttab, f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) eform
*/

* niveau de vie
eststo clear
eststo: qui ologit y_AM_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
esttab using ologit3_nivi.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f replace

coefplot est1 est2 est3 est4, keep(*sdnivie) baselevel xline(0) legend(size(small))

*PCS
eststo clear
eststo: qui ologit y_AM_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit if annee==2020, or
esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged)
esttab using ologit3_csp.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f replace
/*
g diplome3 = 1 if diplome4==1 | diplome4==2
replace diplome3=2 if diplome4==3
replace diplome3=3 if diplome4==4
label define diplome3 1 "inf bac" 2 "bac" 3 "sup bac"
label value diplome3 diplome3
*/
eststo clear
eststo: qui ologit y_AM_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged)
esttab using ologit3_dip.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f replace

* gologit
eststo clear
eststo: qui gologit2 y_AM_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
eststo: qui gologit2 y_Retraite_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
eststo: qui gologit2 y_Famille_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
eststo: qui gologit2 y_Chomage_3 ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
esttab, f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) eform
margins, dydx(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Baisse"))
margins, dydx(sdnivie) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Baisse")) l(95)


eststo clear
eststo: qui gologit2 y_AM ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui gologit2 y_Retraite ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui gologit2 y_Famille ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui gologit2 y_Chomage ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
esttab, f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) eform
margins, dydx(sdsplit)
marginsplot, legend(order(1 "(accepte baisse/refus hausse) +" 2 "(Accepte baisse/Refus hausse) -" 3 "(Refus baisse/Accepte hausse) -" 4 "(Refus baisse/Accepte hausse) +" ))
margins, dydx(sdnivie sdsplit)
marginsplot, legend(order(1 "(accepte baisse/refus hausse) +" 2 "(Accepte baisse/Refus hausse) -" 3 "(Refus baisse/Accepte hausse) -" 4 "(Refus baisse/Accepte hausse) +" ))
margins sdnivie#sdsplit
marginsplot, legend(order(1 "(accepte baisse/refus hausse) +" 2 "(Accepte baisse/Refus hausse) -" 3 "(Refus baisse/Accepte hausse) -" 4 "(Refus baisse/Accepte hausse) +" ))
margins, dydx(sdnivie) over(sdsplit)
marginsplot, legend(order(1 "(accepte baisse/refus hausse) +" 2 "(Accepte baisse/Refus hausse) -" 3 "(Refus baisse/Accepte hausse) -" 4 "(Refus baisse/Accepte hausse) +" ))





/*
twoway (dot coef_`lab_`i''_sdnivie ident, mcolor(red) lpattern(solid) cmissing(n)) (line cil_`lab_`i''_sdnivie ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) (line ciu_`lab_`i''_sdnivie ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) in 1/5, yscale(range(-0.9 -0.5)) xlabel(200000001 "Q1" 200000002 "Q2" 200000003 "Q3" 200000004 "Q4" 200000005 "Q5") title("Soutien au statu quo (AvB) par quintile de niveau de vie" "Assurance Maladie") legend(order(1 "Proportion de soutien au satu quo" 2 "Intervalle de confiance"))

twoway (dot coef ident, mcolor(red) lpattern(solid) cmissing(n)) (line cil ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) (line ciu ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) in 1/5, yscale(range(-0.9 -0.5)) xlabel(200000001 "Q1" 200000002 "Q2" 200000003 "Q3" 200000004 "Q4" 200000005 "Q5") title("Soutien au statu quo (AvB) par quintile de niveau de vie" "Assurance Maladie") legend(order(1 "Proportion de soutien au satu quo" 2 "Intervalle de confiance"))
*/

g quintile="Q1" if ident==200000001
replace quintile="Q2" if ident==200000002
replace quintile="Q3" if ident==200000003
replace quintile="Q4" if ident==200000004
replace quintile="Q5" if ident==200000005

program drop SQ_matrice_agreg
program SQ_matrice_agreg

	qui mean(y_`1'_B) if sdsplit==`2' & annee==2020
	mat A = 1-e(b)
	qui mean(y_`1'_B) if sdsplit==`3' & annee==2020
	mat B = e(b)
	qui logit y_`1'_B ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit if annee==2020
	qui margins `2'.sdsplit `3'.sdsplit, pwcompare
	mat SQ_`1' = A,-r(b_vs),B
	mat SQ_`1' = SQ_`1''
	mat colnames SQ_`1' = `1'
	mat list SQ_`1'
	svmat SQ_`1', name(col)
	
end

local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4 {
	SQ_matrice_agreg `lab_`i'' 1 2
}


graph bar AM in 1/3, over(ident) stack asyvars legend(order(1 "Soutien à une baisse" 2 "Statu quo" 3 "Soutien à une hausse")) ///
	blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) ///
	nodraw name(AM, replace) title(Assurance maladie)
graph bar Retraite in 1/3, over(ident) stack asyvars legend(order(1 "Soutien à une baisse" 2 "Statu quo" 3 "Soutien à une hausse")) ///
	blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) ///
	nodraw name(Retraite, replace) title(Retraite)
graph bar Famille in 1/3, over(ident) stack asyvars legend(order(1 "Soutien à une baisse" 2 "Statu quo" 3 "Soutien à une hausse")) ///
	blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) ///
	nodraw name(Famille, replace) title(Famille)
graph bar Chomage in 1/3, over(ident) stack asyvars legend(order(1 "Soutien à une baisse" 2 "Statu quo" 3 "Soutien à une hausse")) ///
	blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) ///
	nodraw name(Chômage, replace) title(Chômage)
grc1leg AM Retraite Famille Chômage, legendfrom(AM) row(1) col(4) title(Soutien et statu quo par branche)





**********
* predict sur l'AM
**********
replace ps2_ab=. if ps2_ab==4 & annee==2020
replace ps16_ab=. if ps16_ab==3 & annee==2020
replace ps1_ab_1=. if ps1_ab_1 ==5 & annee==2020
ologit y_AM_3 i.diplome3 c.sdage i.sdsexe c.sdnivie i.ps2_ab i.ps16_ab i.ps1_ab_1 if annee==2020 & sdsplit==1
predict prA_1 prA_2 prA_3 if annee==2020
ologit y_AM_3 i.diplome3 c.sdage i.sdsexe c.sdnivie i.ps2_ab i.ps16_ab i.ps1_ab_1 if annee==2020 & sdsplit==2
predict prB_1 prB_2 prB_3 if annee==2020
scatter prA_1 prB_1 if sdsplit==2, by(y_AM_3)
tw (scatter prA_1 prB_3) (qfit prA_1 prB_3) if sdsplit==1 | sdsplit==2, by(diplome3)
tw (scatter prA_3 prB_1) (lfit prA_3 prB_1) if sdsplit==1 | sdsplit==2

tw (scatter prA_1 prB_1) (qfit prA_1 prB_1) if sdsplit==1 | sdsplit==2
scatter prA_2 prB_2 if sdsplit==1 | sdsplit==2
scatter prA_3 prB_3 if sdsplit==1 | sdsplit==2
gen incoherence = prA_1*prB_3
sum incoherence
sum prB_3 if sdsplit==1 & y_AM_3==1



*****
*****




program drop SQ_matrice2
program SQ_matrice2 

	
	qui mean(y_`2'_B) if sdsplit==`3' & `1'==1 & annee==2020
	mat A = 1-e(b)
	qui mean(y_`2'_B) if sdsplit==`4' & `1'==1 & annee==2020
	mat B = e(b)
	qui logit y_`2'_B ib2.pcs5 i.diplome4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.diplome4#i.sdsplit i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
	qui margins 1.`1'#`3'.sdsplit 1.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_1 = A,-r(b_vs),B
	mat list SQ_`2'_`1'_1
	
	qui mean(y_`2'_B) if sdsplit==`3' & `1'==2 & annee==2020
	mat A = 1-e(b)
	qui mean(y_`2'_B) if sdsplit==`4' & `1'==2 & annee==2020
	mat B = e(b)
	qui logit y_`2'_B ib2.pcs5 i.diplome4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.diplome4#i.sdsplit i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
	qui margins 2.`1'#`3'.sdsplit 2.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_2 = A,-r(b_vs),B
	mat list SQ_`2'_`1'_2

	qui mean(y_`2'_B) if sdsplit==`3' & `1'==3 & annee==2020
	mat A = 1-e(b)
	qui mean(y_`2'_B) if sdsplit==`4' & `1'==3 & annee==2020
	mat B = e(b)	
	qui logit y_`2'_B ib2.pcs5 i.diplome4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.diplome4#i.sdsplit i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
	qui margins 3.`1'#`3'.sdsplit 3.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_3 = A,-r(b_vs),B
	mat list SQ_`2'_`1'_3
	
	qui mean(y_`2'_B) if sdsplit==`3' & `1'==4 & annee==2020
	mat A = 1-e(b)
	qui mean(y_`2'_B) if sdsplit==`4' & `1'==4 & annee==2020
	mat B = e(b)
	qui logit y_`2'_B ib2.pcs5 i.diplome4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.diplome4#i.sdsplit i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
	qui margins 4.`1'#`3'.sdsplit 4.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_4 = A,-r(b_vs),B
	mat list SQ_`2'_`1'_4
	
	qui mean(y_`2'_B) if sdsplit==`3' & `1'==5 & annee==2020
	mat A = 1-e(b)
	qui mean(y_`2'_B) if sdsplit==`4' & `1'==5 & annee==2020
	mat B = e(b)
	qui logit y_`2'_B ib2.pcs5 i.diplome4 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.diplome4#i.sdsplit i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020	
	qui margins 5.`1'#`3'.sdsplit 5.`1'#`4'.sdsplit, pwcompare 
	mat SQ_`2'_`1'_5 = A,-r(b_vs),B
	mat list SQ_`2'_`1'_5

	mat SQ_`2'_`1' = SQ_`2'_`1'_1\SQ_`2'_`1'_2\SQ_`2'_`1'_3\SQ_`2'_`1'_4\SQ_`2'_`1'_5
	mat rownames SQ_`2'_`1' = 1 2 3 4 5
	mat colnames SQ_`2'_`1' = Baisse StatuQuo Hausse
	mat list SQ_`2'_`1'
*	mat SQ_`2'_`1'= SQ_`2'_`1''
	svmat SQ_`2'_`1', name(col)
	
end

/*quintile*/

SQ_matrice2 sdnivie AM 1 2
graph bar Baisse StatuQuo Hausse, over(quintile) stack asyvars blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) legend(order(1 "Baisse de prestation" 2 "Statu quo" 3 "Hausse de prestation")) nodraw name(AM, replace) title(Assurance maladie)
drop Baisse StatuQuo Hausse
SQ_matrice2 sdnivie Retraite 1 2
graph bar Baisse StatuQuo Hausse, over(quintile) stack asyvars blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) legend(order(1 "Baisse de prestation" 2 "Statu quo" 3 "Hausse de prestation")) nodraw name(Retraite, replace) title(Retraite)
drop Baisse StatuQuo Hausse
SQ_matrice2 sdnivie Famille 1 2
graph bar Baisse StatuQuo Hausse, over(quintile) stack asyvars blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) legend(order(1 "Baisse de prestation" 2 "Statu quo" 3 "Hausse de prestation")) nodraw name(Famille, replace) title(Famille)
drop Baisse StatuQuo Hausse
SQ_matrice2 sdnivie Chomage 1 2
graph bar Baisse StatuQuo Hausse, over(quintile) stack asyvars blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) legend(order(1 "Baisse de prestation" 2 "Statu quo" 3 "Hausse de prestation")) nodraw name(Chomage, replace) title(Chomage)
grc1leg AM Retraite Famille Chomage, legendfrom(AM) row(2) col(2) title(Soutien et statu quo par branche et par niveau de revenu)
drop Baisse StatuQuo Hausse

/*pcs*/
SQ_matrice2 pcs5 AM 1 2
graph bar Baisse StatuQuo Hausse, over(quintile, relabel(1 "Indépendant" 2 "CDI" 3 "Précaire" 4 "Retraité" 5 "Autre inact")) stack asyvars blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) legend(order(1 "Baisse de prestation" 2 "Statu quo" 3 "Hausse de prestation")) nodraw name(AM, replace) title(Assurance maladie)
drop Baisse StatuQuo Hausse
SQ_matrice2 pcs5 Retraite 1 2
graph bar Baisse StatuQuo Hausse, over(quintile, relabel(1 "Indépendant" 2 "CDI" 3 "Précaire" 4 "Retraité" 5 "Autre inact")) stack asyvars blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) legend(order(1 "Baisse de prestation" 2 "Statu quo" 3 "Hausse de prestation")) nodraw name(Retraite, replace) title(Retraite)
drop Baisse StatuQuo Hausse
SQ_matrice2 pcs5 Famille 1 2
graph bar Baisse StatuQuo Hausse, over(quintile, relabel(1 "Indépendant" 2 "CDI" 3 "Précaire" 4 "Retraité" 5 "Autre inact")) stack asyvars blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) legend(order(1 "Baisse de prestation" 2 "Statu quo" 3 "Hausse de prestation")) nodraw name(Famille, replace) title(Famille)
drop Baisse StatuQuo Hausse
SQ_matrice2 pcs5 Chomage 1 2
graph bar Baisse StatuQuo Hausse, over(quintile, relabel(1 "Indépendant" 2 "CDI" 3 "Précaire" 4 "Retraité" 5 "Autre inact")) stack asyvars blabel(bar, position(center) format(%3.2f) color(white) size(vsmall)) legend(order(1 "Baisse de prestation" 2 "Statu quo" 3 "Hausse de prestation")) nodraw name(Chomage, replace) title(Chomage)
grc1leg AM Retraite Famille Chomage, legendfrom(AM) row(2) col(2) title(Soutien et statu quo par branche et par pcs)
drop Baisse StatuQuo Hausse



********************
*effets marginaux logit [code non fonctionnel]
********************
qui logit y_Chomage_B i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.diplome3#i.sdsplit i.sdsplit if annee==2020
margins, dydx(*) at(sdsplit=(1 2 3 4))


/* 4 paramètre à entrer: 1=variable présente dans la regression logit, 2=branche (AM, Retraite, Famille ou Chomage) 
3=1er type de questionnaire (=1/4), 4=2e type de questionnaire (=1/4)*/
program SQ_matrice 
	qui logit y_`2'_B i.diplome4 i.sdagetr i.sdsexe i.sdnivie i.diplome4#i.sdsplit i.sdsplit if annee==2020
	qui margins 1.`1'#`3'.sdsplit 1.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_1 = r(table_vs)
	qui margins 2.`1'#`3'.sdsplit 2.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_2 = r(table_vs)
	qui margins 3.`1'#`3'.sdsplit 3.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_3 = r(table_vs)
	qui margins 4.`1'#`3'.sdsplit 4.`1'#`4'.sdsplit, pwcompare
	mat SQ_`2'_`1'_4 = r(table_vs)
	qui margins 5.`1'#`3'.sdsplit 5.`1'#`4'.sdsplit, pwcompare 
	mat SQ_`2'_`1'_5 = r(table_vs)
	mat SQ_`2'_`1' = SQ_`2'_`1'_1,SQ_`2'_`1'_2,SQ_`2'_`1'_3,SQ_`2'_`1'_4,SQ_`2'_`1'_5
	matrix rownames SQ_`2'_`1' = coef_`2' se_`2' z_`2' pvalue_`2' cil_`2' ciu_`2' df_`2' crit_`2' eform_`2'
	matrix SQ_`2'_`1' = -SQ_`2'_`1'
	matrix SQ_`2'_`1'_t = SQ_`2'_`1''
	svmat SQ_`2'_`1'_t, name(col)
end
	

* test du chi2, analyse de la significativité des variations
* nb catégorie de chomage trop faible

ta ps16_ab pcs6_4 if annee==2020 & ps16_ab!=3, cchi2 chi2
ta ps16_cd pcs6_4 if annee==2020 & ps16_cd!=3, cchi2 chi2

ta ps16_ab ps13_a_1_bin if annee==2020 & ps16_ab!=3 & ps13_c_1_bin!=3 , cchi2 chi2
ta ps16_cd ps13_c_1_bin if annee==2020 & ps16_cd!=3 & ps13_c_1_bin!=3 , cchi2 chi2

ta ps16_ab pcs6_4 if ps16_ab!=3, cchi2 chi2
ta ps1_ab_1 pcs6_4 if ps1_ab_1!=5 & annee==2020 & pcs6_4!=4, cchi2 chi2
ta ps1_cd_1 pcs6_4 if ps1_cd_1!=5 & annee==2020 & pcs6_4!=4, cchi2 chi2


g indep = (pcs6_4==1)
ta ps16_ab indep if annee==2020 & ps16_ab!=3, cchi2 chi2
ta ps16_ab indep if annee==2019 & ps16_ab!=3, cchi2 chi2

ta ps13_a_1_bin pcs6_4 if annee==2020 & ps13_a_1_bin!=3 & pcs6_4!=4, cchi2 chi2
ta ps13_a_1_bin pcs6_4 if annee==2019 & ps13_a_1_bin!=3 & pcs6_4!=4, cchi2 chi2

ta ps13_b_2_bin pcs6_4 if annee==2020 & ps13_b_2_bin!=3 & pcs6_4!=4, cchi2 chi2
ta ps13_a_1_bin sdagetr if annee==2020 & ps13_a_1_bin!=3, cchi2 chi2


catplot ps13_a_2, over(annee, label(labsize(vsmall) labcolor(black) angle(45))) percent(annee) asyvars legend(pos(1) color(black)) blabel(dot, position(center) format(%3.1f) color(white) size(vsmall)) vertical stack

catplot ps1_ab_3, over(annee, label(labsize(vsmall) labcolor(black) angle(45))) percent(annee) asyvars legend(pos(1) color(black)) blabel(dot, position(center) format(%3.1f) color(white) size(vsmall)) vertical stack


********************************************************************************
* ACM de l'espace sociale avec ps13 en supplémentaire
********************************************************************************
global PS13 "ps13_a_1_bin ps13_a_2_bin ps13_a_3_bin ps13_a_4_bin ps13_b_1_bin ps13_b_2_bin ps13_b_3_bin ps13_b_4_bin ps13_c_1_bin ps13_c_2_bin ps13_c_3_bin ps13_c_4_bin ps13_d_1_bin ps13_d_2_bin ps13_d_3_bin ps13_d_4_bin"


foreach k in $PS13 {
    replace `k' = 4 if annee==2020 & `k'==.
}

g enfant = (sitfam==3 | sitfam==4)
label define enfant 0 "Sans enfant" 1 "Avec enfant(s)"
label value enfant enfant

label drop sdcouple
label define sdcouple 1 "couple oui" 2 "couple non"
label value sdcouple sdcouple

mca pcs8 sdagetr sdcouple enfant diplome if annee>=2016 & sdagetr!=1, sup($PS13)
mcaplot, overlay legend(off) xline(0) yline(0) scale(.8)
mcaplot pcs8 sdagetr sdcouple enfant diplome, overlay legend(off) xline(0) yline(0) scale(.8)
mcaplot ps13_a_1_bin ps13_b_1_bin ps13_c_1_bin ps13_d_1_bin, overlay xline(0) yline(0) mlabsize(vsmall)


mcaprojection ps13_a_1_bin ps13_b_1_bin ps13_c_1_bin ps13_d_1_bin, mlabsize(vsmall) row(1)
mcaprojection ps13_a_2_bin ps13_b_2_bin ps13_c_2_bin ps13_d_2_bin, mlabsize(vsmall) row(1)
mcaprojection ps13_a_3_bin ps13_b_3_bin ps13_c_3_bin ps13_d_3_bin, mlabsize(vsmall) row(1)
mcaprojection ps13_a_4_bin ps13_b_4_bin ps13_c_4_bin ps13_d_4_bin, mlabsize(vsmall) row(1)
* aucune conclusion facile à tirer



***********************
*pb de code
***********************
mat drop mcamat
drop dim1 dim2

mat mcamat=e(A)

mat list name
svmat2 name, name(name)
g idmca=name#varname
mat list mcamat
svmat2 mcamat, name(dim1 dim2)

local nr : rownames mcamat
scatter dim2 dim1, mlabsize(vsmall) mlabel(id)


mat sup1 = mcamat["ps13_a_1_bin:Oui" "ps13_b_1_bin:Oui" ."ps13_c_1_bin:Oui". "ps13_d_1_bin:Oui". "ps13_a_1_bin:Non". "ps13_b_1_bin:Non". "ps13_c_1_bin:Non". "ps13_d_1_bin:Non", "dim1:coord".."dim2:coord"]
mat sup2 = mcamat["ps13_a_2Oui"."ps13_b_2Oui"."ps13_c_2Oui"."ps13_d_2Oui"."ps13_a_2Non"."ps13_b_2Non"."ps13_c_2Non"."ps13_d_2Non",]
mat sup3 = mcamat["ps13_a_3Oui"."ps13_b_3Oui"."ps13_c_3Oui"."ps13_d_3Oui"."ps13_a_3Non"."ps13_b_3Non"."ps13_c_3Non"."ps13_d_3Non",]
mat sup4 = mcamat["ps13_a_4Oui"."ps13_b_4Oui"."ps13_c_4Oui"."ps13_d_4Oui"."ps13_a_4Non"."ps13_b_4Non"."ps13_c_4Non"."ps13_d_4Non",]

scatter coordim2 coordim1 if varname=="ps13_a_1_bin"

drop a1 a2
predict a1 a2
tw scatter a2 a1 if ps13_a_1==1, || scatter a2 a1 if ps13_a_1==2, || ///
scatter a2 a1 if ps13_a_1==3, || scatter a2 a1 if ps13_a_1==4, || ///
scatter a2 a1 if ps13_a_1==5 |  ps13_a_1==6, scale(.6) xline(0) yline(0)
mcaplot ps13_a_1_bin ps13_b_1_bin ps13_c_1_bin ps13_d_1_bin , overlay legend(off) xline(0) yline(0) scale(.8)





****************************************************************************
* croisement soutien protection sociale avec origine de revenus
****************************************************************************

* chomage  sdres_4 et Rsa  sdres_3


g chomrsa = 1 if sdres_3==1
replace chomrsa=2 if sdres_4==1
replace chomrsa=3 if sdres_3==1 & sdres_4==1
replace chomrsa=4 if sdres_3==2 & sdres_4==2
label define chomrsa 1 "RSA seulement" 2 "Chomage seulement" 3 "RSA et chomage" 4 "Aucun des deux"
label value chomrsa chomrsa

catplot ps1_ab_4 if annee>=2016 & sdres_4!=3, over(sdres_4, label(labsize(vsmall) labcolor(black))) percent(sdres_4) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocation chômage" "chez ceux qui touchent les allocations chomages") vertical

catplot ps1_ab_4 if annee>=2016 & sdres_3!=3, over(sdres_3, label(labsize(vsmall) labcolor(black))) percent(sdres_3) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocation chômage" "chez ceux qui touchent les allocations chomages") vertical

catplot ps2_ab if annee<2016, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocation chômage" "chez les allocataires RSA et chomage") vertical stack


catplot ps16_ab if annee>=2016, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocation chômage" "chez les allocataires RSA et chomage") vertical stack
* a faire -> dummy "bénéficie d'allocations"
* a faire -> variable de soutien au rsa

catplot ps13_a_4 if annee>=2016, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la baisse des allocations chomages" "chez les allocataires RSA et chomage") vertical stack

*rsa:

ta pe9_ab if annee!=2020
ta pe9_ab if annee==2020
ta pe9_cd
catplot pe9_ab, over(annee) percent(annee) asyvars vertical stack
catplot pe9_ab, over(pcs8) percent(pcs8) asyvars vertical
catplot pe9_ab, over(pcs6_4) percent(pcs6_4) asyvars vertical
* intéressant de voir que les catégories salariés de la pcs8 ne joue pas beaucoup tandis que celle de la pcs6_4 si
catplot pe9_ab, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien au rsa" "chez les allocataires RSA et chomage") vertical




ta pe10 /* filtre pe9=="augmenter le rsa" */
catplot pe10, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Augmentation des impots pour augmenter le RSA" "chez les allocataires RSA et chomage") vertical

ta pe17_ab if annee!=2020
ta pe17_ab if annee==2020
ta pe17_cd

catplot pe17_ab, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Ouverture du RSA au jeune" "chez les allocataires RSA et chomage") vertical

catplot pe17_ab, over(sdagetr, label(labsize(vsmall) labcolor(black))) percent(sdagetr) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Ouverture du RSA au jeune" "Par tranche d'âge") vertical

catplot pe17_ab if sdagetr!=1, over(pcs6_4, label(labsize(vsmall) labcolor(black))) percent(pcs6_4) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Ouverture du RSA au jeune" "Par PCS chez les plus de 25 ans") vertical


catplot pe13_ab, over(sdagetr, label(labsize(vsmall) labcolor(black))) percent(sdagetr) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la limitation des allocations chomages dans le temps") vertical
catplot pe13_cd, over(sdagetr, label(labsize(vsmall) labcolor(black))) percent(sdagetr) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la prolongation des allocations chomages en cas de crise") vertical





*Allocation familiale sdres_8

catplot ps13_a_3 if annee>=2016 & sdres_8!=3, over(sdres_8, label(labsize(vsmall) labcolor(black))) percent(sdres_8) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la baisse des allocations familiales" "chez les allocataires") vertical stack

catplot ps1_ab_3 if annee>=2016 & sdres_8!=3, over(sdres_8, label(labsize(vsmall) labcolor(black))) percent(sdres_8) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la baisse des allocations familiales" "chez les allocataires") vertical stack

catplot fa13_ab, over(annee) percent(annee) asyvars vertical stack
* pas d'évolution du à la crise sanitaire


catplot fa13_cd if sdres_8!=3, over(sdres_8, label(labsize(vsmall) labcolor(black))) percent(sdres_8) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocations familiales" "chez les allocataires") vertical stack




*revenus financiers et de locations sdres_6 sdres_7



