cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

use Baromètre20, clear

* ssc install catplot
*ssc install palettes,  replace
*ssc install colrspace, replace
*ssc install grstyle, replace
*net install grc1leg, from(http://www.stata.com/users/vwiggins)
* ssc install tabplot, replace
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


/* Modification a faire avant l'ACM: neutraliser les catégories trop petites, pour cela, suppression de la catégorie NSP pour variables PS1 et mixer la catégorie "nsp" et "non concerné" pour les variables PS13 */
/*
forvalues i = 1/4 {
	replace ps1_`i'=. if ps1_`i'==5 
	replace ps13_`i'=5 if ps13_`i'==6
}
*/

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
grstyle set color "70 50 127" "33 144 140" "159 218 58" , ipolate(4)


local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"


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


