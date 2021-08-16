cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"


replace ps2_ab=. if ps2_ab==4 & annee==2020
replace ps16_ab=. if ps16_ab==3 & annee==2020
replace ps1_ab_1=. if ps1_ab_1 ==5 & annee==2020
replace ps1_ab_2=. if ps1_ab_2 ==5 & annee==2020
replace ps1_ab_3=. if ps1_ab_3 ==5 & annee==2020
replace ps1_ab_4=. if ps1_ab_4 ==5 & annee==2020

****************************************************
* Utilisation des résultats de la régression pour estimer une approximation du soutien au statu quo par catégories socio-démographiques
* Pas terminé et pas forcément le plus simple, interpréter les effets marginaux des régressions est probablement plus simple
****************************************************

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