cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"




********************************************************************************
* nécessite les packages catplot et grstyle et grc1leg
* I- Effet formulation par branche
* II- Comparaison des formulations 2 à 2
* III- PS16 question sur le déficit
* IV - Aversion au risque (pas abouti)
* V - stat desc formulation ps13 par catégories sociodémo (peu intéressant)
*

* Graphique code: boucle pour sortir série de graph soc-dem

*******************************
* I- Effet formulation par branche
*******************************
****
* AM
****
catplot ps13_a_1 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations AM") vertical stack name(GA1, replace) nodraw
catplot ps13_b_1 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse impots AM") vertical stack name(GB1, replace) nodraw
catplot ps13_c_1 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse impots AM") vertical stack name(GC1, replace) nodraw
catplot ps13_d_1 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse prestation AM") vertical stack name(GD1, replace) nodraw
grc1leg GA1 GC1 GD1 GB1, legendfrom(GA1) iscale(0.6) row(1) col(4) name(AM, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13AM.png", replace

**********
* Retraite
**********
catplot ps13_a_2 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations retraite") vertical stack name(GA2, replace) nodraw
catplot ps13_b_2 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse impots retraite") vertical stack name(GB2, replace) nodraw
catplot ps13_c_2 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse impots retraite") vertical stack name(GC2, replace) nodraw
catplot ps13_d_2 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse prestation retraite") vertical stack name(GD2, replace) nodraw
grc1leg GA2 GC2 GD2 GB2, legendfrom(GA2) iscale(0.6) row(1) col(4) name(Retraite, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13Retraite.png", replace

**********
* Famille
**********
catplot ps13_a_3 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations famille") vertical stack name(GA3, replace) nodraw
catplot ps13_b_3 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse impots famille") vertical stack name(GB3, replace) nodraw
catplot ps13_c_3 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse impots famille") vertical stack name(GC3, replace) nodraw
catplot ps13_d_3 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse prestation famille") vertical stack name(GD3, replace) nodraw
grc1leg GA3 GC3 GD3 GB3, legendfrom(GA3) iscale(0.6) row(1) col(4) name(Famille, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13famille.png", replace

**********
* Chômage
**********
catplot ps13_a_4 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse prestations chomage") vertical stack name(GA4, replace) nodraw
catplot ps13_b_4 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse impots chomage") vertical stack name(GB4, replace) nodraw
catplot ps13_c_4 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Baisse impots chomage") vertical stack name(GC4, replace) nodraw
catplot ps13_d_4 if annee==2020, percent asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Hausse prestation chomage") vertical stack name(GD4, replace) nodraw
grc1leg GA4 GC4 GD4 GB4, legendfrom(GA4) iscale(0.6) row(1) col(4) name(chomage, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13chomage.png", replace

grc1leg AM Retraite Famille chomage, legendfrom(AM) iscale(0.6) row(2) col(2) name(total, replace)
graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/2020/ps13total.png", replace




********************************************************************************
* II- Comparaison des formulations 2 à 2
********************************************************************************

********************
/* Analyse AvB effet agrégé*/
********************
catplot y_AM if annee==2020 & (sdsplit==1 | sdsplit==2), over(sdsplit, relabel(1 "A: Accepte baisse prestations" 2 "B: Refuse hausse prestations") label(labsize(vsmall) labcolor(black) angle(10))) percent(sdsplit) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Branche assurance maladie") vertical legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt" 4 "Non pas du tout")) name(GA1, replace) nodraw

catplot y_Chomage if annee==2020 & (sdsplit==1 | sdsplit==2), over(sdsplit, relabel(1 "A: Accepte baisse prestations" 2 "B: Refuse hausse prestations") label(labsize(vsmall) labcolor(black) angle(10))) percent(sdsplit) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Branche allocations chômages") vertical name(GA2, replace) nodraw

grc1leg GA1 GA2, legendfrom(GA1) title(Soutien en fonction du questionnaire) iscale(0.9)

*****************************
/* Analyse AvB effet agrégé*/
*****************************

catplot ps13_a_1 if annee==2020 & ps13_a_1<5,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("A: Accepteriez-vous une baisse" "de l'assurance maladie" "en échange d’une baisse de vos " "impôts ou de vos cotisations ?", size(small)) vertical legend( pos(1) color(gs5))  yscale(range(0 60)) ylabel(0 20 40 60) name(GA1, replace)

catplot ps13_b_1 if annee==2020 & ps13_b_1<5 , percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("B: Accepteriez-vous une HAUSSE" "de vos impôts ou de vos cotisations" "pour financer l'augmentation" "de l'assurance maladie ?", size(small)) vertical legend( pos(1) color(gs5)) name(GA2, replace) nodraw yscale(range(0 60)) ylabel(0 20 40 60)

grc1leg GA1 GA2, legendfrom(GA1) title(Assurance maladie) name(G1, replace) 

catplot ps13_a_4 if annee==2020 & ps13_a_4<5,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("A: Accepteriez-vous une baisse" "des allocations chômage" "en échange d’une baisse de vos " "impôts ou de vos cotisations ?", size(small)) vertical legend( pos(1) color(gs5))  name(GA3, replace) nodraw yscale(range(0 60)) ylabel(0 20 40 60)

catplot ps13_b_4 if annee==2020 & ps13_b_4<5 , percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("B: Accepteriez-vous une HAUSSE" "de vos impôts ou de vos cotisations" "pour financer l'augmentation" "des allocations chômage ?", size(small)) vertical legend( pos(1) color(gs5)) name(GA4, replace) nodraw  yscale(range(0 60)) ylabel(0 20 40 60)

grc1leg GA3 GA4, legendfrom(GA3) title(Allocations chômage) iscale(0.9) name(G2, replace)

grc1leg G1 G2, legendfrom(G1) title("Comparaison des questionnaires A et B")


*****************************
/* Analyse AvC effet agrégé*/
****************************
catplot ps13_a_1 if annee==2020 & ps13_a_1<5,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("A: Accepteriez-vous une baisse" "de l'assurance maladie" "en échange d’une baisse de vos " "impôts ou de vos cotisations ?" "__", size(small)) vertical legend( pos(1) color(gs5))  yscale(range(0 60)) ylabel(0 20 40 60) name(GA1, replace)

catplot ps13_c_1 if annee==2020 & ps13_c_1<5 , percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("C: En contrepartie d’une baisse" "des impôts ou des cotisations," "trouveriez-vous acceptable" "de diminuer les remboursements" "de l'assurance maladie ?", size(small)) vertical legend( pos(1) color(gs5)) name(GA2, replace) nodraw yscale(range(0 60)) ylabel(0 20 40 60)
grc1leg GA1 GA2, legendfrom(GA1) title(Assurance maladie) iscale(0.9) name(G1, replace) 

catplot ps13_a_4 if annee==2020 & ps13_a_4<5,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("A: Accepteriez-vous une baisse" "des allocations chômage" "en échange d’une baisse de vos " "impôts ou de vos cotisations ?" "__", size(small)) vertical legend( pos(1) color(gs5))  name(GA3, replace) nodraw yscale(range(0 60)) ylabel(0 20 40 60)

catplot ps13_c_4 if annee==2020 & ps13_c_4<5 , percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("C: En contrepartie d’une baisse" "des impôts ou des cotisations," "trouveriez-vous acceptable" "de diminuer les allocations chômage ?" "__", size(small)) vertical legend( pos(1) color(gs5)) name(GA4, replace) nodraw  yscale(range(0 60)) ylabel(0 20 40 60)

grc1leg GA3 GA4, legendfrom(GA3) title(Allocations chômage) iscale(0.9) name(G2, replace)

grc1leg G1 G2, legendfrom(G1) title("Comparaison des questionnaires A et C")


*****
*BvD
*****
catplot ps13_d_1 if annee==2020 & ps13_d_1<5,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("D: Parmi les prestations suivantes" "lesquels vous semble-t-il nécessaire d'augmenter," "même sic ela implique une augmentation" "des impôts ou des cotisations", size(small)) vertical legend( pos(1) color(gs5))  yscale(range(0 60)) ylabel(0 20 40 60) name(GA1, replace)

catplot ps13_b_1 if annee==2020 & ps13_b_1<5 , percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("B: Accepteriez-vous une HAUSSE" "de vos impôts ou de vos cotisations" "pour financer l'augmentation" "de l'assurance maladie ?", size(small)) vertical legend( pos(1) color(gs5)) name(GA2, replace) nodraw yscale(range(0 60)) ylabel(0 20 40 60)
grc1leg GA2 GA1, legendfrom(GA1) title(Assurance maladie) name(G1, replace) 



*****
* Effet formulation A et B sur les retraités
******


catplot ps13_a_1 if annee==2020 & ps13_a_1<5 & sdpcs10==8,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("A: Accepteriez-vous une baisse" "de l'assurance maladie" "en échange d’une baisse de vos " "impôts ou de vos cotisations ?", size(small)) vertical legend( pos(1) color(gs5))  yscale(range(0 70)) ylabel(0 20 40 60) name(GA1, replace)

catplot ps13_b_1 if annee==2020 & ps13_b_1<5 & sdpcs10==8, percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("B: Accepteriez-vous une HAUSSE" "de vos impôts ou de vos cotisations" "pour financer l'augmentation" "de l'assurance maladie ?", size(small)) vertical legend( pos(1) color(gs5)) name(GA2, replace) nodraw yscale(range(0 70)) ylabel(0 20 40 60)

grc1leg GA1 GA2, legendfrom(GA1) title(Assurance maladie) iscale(0.9) name(G1, replace) 

catplot ps13_a_4 if annee==2020 & ps13_a_4<5 & sdpcs10==8,  percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("A: Accepteriez-vous une baisse" "des allocations chômage" "en échange d’une baisse de vos " "impôts ou de vos cotisations ?", size(small)) vertical legend( pos(1) color(gs5))  name(GA3, replace) nodraw yscale(range(0 70)) ylabel(0 20 40 60)

catplot ps13_b_4 if annee==2020 & ps13_b_4<5 & sdpcs10==8, percent asyvars legend(order(1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout")) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("B: Accepteriez-vous une HAUSSE" "de vos impôts ou de vos cotisations" "pour financer l'augmentation" "des allocations chômage ?", size(small)) vertical legend( pos(1) color(gs5)) name(GA4, replace) nodraw  yscale(range(0 70)) ylabel(0 20 40 60)

grc1leg GA3 GA4, legendfrom(GA3) title(Allocations chômage) iscale(0.9) name(G2, replace)

grc1leg G1 G2, legendfrom(G1) title("Comparaison des questionnaires A et B chez les retraités")



*************************
* III- PS16 question sur le déficit
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


* Croisement ps16 et ps13 en binaire (peut servir sur les questions d'aversion au risque mais n'a pas abouti)

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



****************************************************
* IV - Aversion au risque (pas abouti)
***************************************************

g PS1_1 = ps1_ab_1 if  annee!=2020 | (sdsplit==1| sdsplit==2)
replace PS1_1= ps1_cd_1 if annee==2020 & (sdsplit==3| sdsplit==4)
label value PS1_1 ps1_ab_1
g PS1_2 = ps1_ab_2 if  annee!=2020 | (sdsplit==1| sdsplit==2)
replace PS1_2= ps1_cd_2 if annee==2020 & (sdsplit==3| sdsplit==4)
label value PS1_2 ps1_ab_1
g PS1_3 = ps1_ab_3 if  annee!=2020 | (sdsplit==1| sdsplit==2)
replace PS1_3= ps1_cd_3  if annee==2020 & (sdsplit==3| sdsplit==4)
label value PS1_3 ps1_ab_1
g PS1_4 = ps1_ab_4 if  annee!=2020 | (sdsplit==1| sdsplit==2)
replace PS1_4= ps1_cd_4 if annee==2020 & (sdsplit==3| sdsplit==4)
label value PS1_4 ps1_ab_1

g split2 = 1 if sdsplit==1 | sdsplit==2
replace split2=2 if sdsplit==3 | sdsplit==4


g averse_a=(ps13_a_1==4)
forvalues i =2/7 {
	replace averse_a=averse_a+1 if ps13_a_`i'==4
	
}
g averse_b=(ps13_b_1==4)
forvalues i =2/7 {
	replace averse_b=averse_b+1 if ps13_b_`i'==4
	
}
g averse_c=(ps13_c_1==4)
forvalues i =2/7 {
	replace averse_c=averse_c+1 if ps13_c_`i'==4
	
}
g averse_d=(ps13_d_1==4)
forvalues i =2/7 {
	replace averse_d=averse_d+1 if ps13_d_`i'==4
	
}

 ta averse_a if annee==2020 & sdsplit==1
 ta averse_b if annee==2020 & sdsplit==2
 ta averse_c if annee==2020 & sdsplit==3
 ta averse_d if annee==2020 & sdsplit==4

 
 
 
 
 



*******************************************************************************
* V - stat desc formulation ps13 par catégories sociodémo (très détaillé mais peu intéressant)
*******************************************************************************

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





 
 
 
