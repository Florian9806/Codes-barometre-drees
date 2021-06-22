cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"

* packages catplot et grc1leg

********************************************************************************
*pseudo panel I
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