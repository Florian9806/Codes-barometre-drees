cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"






********************************************************************************
* variable y en 3 catégories 
* (ps13 avec regroupement des oui tout à fait et oui plutôt)
********************************************************************************


*Stat desc AM et chomage sur la répartition des réponses (à utiliser  pour justifier le formatage de la variable en 3 catégories?)

catplot y_AM if annee==2020, over(sdsplit) vertical asyvars percent(sdsplit) blabel(bar, position(top) format(%3.1f) color(black)) legend(order(1 "Accepte baisse/Refus Hausse +" 2 "Accepte baisse/ Refus hause -" 3 "Refus baisse/Accepte hausse -" 4 "Refuse baisse/Accepte hausse +")) title(Variable de soutien en quatre catégories sur l'assurance maladie)
catplot y_AM_3 if annee==2020, over(sdsplit) vertical asyvars percent(sdsplit) blabel(bar, position(top) format(%3.1f) color(black))  legend(order(1 "(Accepte baisse) (Refus Hausse +)" 2 "Refus baisse et hausse -" 3 "(Refus baisse +) (Accepte hausse)")) title(Variable de soutien en trois catégories sur l'assurance maladie)
catplot y_Chomage if annee==2020, over(sdsplit) vertical asyvars percent(sdsplit) blabel(bar, position(top) format(%3.1f) color(black)) legend(order(1 "Accepte baisse/Refus Hausse +" 2 "Accepte baisse/ Refus hause -" 3 "Refus baisse/Accepte hausse -" 4 "Refuse baisse/Accepte hausse +")) title(Variable de soutien en quatre catégories sur les allocations chômages)
catplot y_Chomage_3 if annee==2020, over(sdsplit) vertical asyvars percent(sdsplit) blabel(bar, position(top) format(%3.1f) color(black))  legend(order(1 "(Accepte baisse) (Refus Hausse +)" 2 "Refus baisse et hausse -" 3 "(Refus baisse +) (Accepte hausse)")) title(Variable de soutien en trois catégories sur les allocations chômages)

eststo clear
eststo: reg y_AM_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Retraite_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Famille_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Chomage_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
esttab using regppy3.tex, keep(*.sdsplit) f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") star(* 0.1 ** 0.05 *** 0.01) scalar(r2) replace

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
eststo: qui ologit y_AM_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
esttab using ologit3_nivi.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace

coefplot est1 est2 est3 est4, keep(*sdnivie) baselevel xline(0) legend(size(small))

*PCS
eststo clear
eststo: qui ologit y_AM_3 ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite_3 ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille_3 ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage_3 ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01)
esttab using ologit3_csp.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace

coefplot est1 est2 est3 est4, keep(*1.PCS) baselevel xline(1) legend(size(small)) eform
coefplot est1 est2 est3 est4, keep(*4.PCS) baselevel xline(1) legend(size(small)) eform level(90)
coefplot est1 est2 est3 est4, keep(*3.PCS) baselevel xline(1) legend(size(small)) eform level(90)


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
esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01)
esttab using ologit3_dip.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace



*********************************************************************************
*gologit2 (logit ordonné généralisé) ; formulation X niveau de vie
*********************************************************************************
eststo clear
eststo: qui gologit2 y_AM ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Retraite ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Famille ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Chomage ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
esttab, eform label star(* 0.1 ** 0.05 *** 0.01)




********************************
* gologit et effets marginaux
********************************
* Effets marginaux et niveaux de vie AM et chômage. Résultats les + intéressants
qui gologit2 y_AM_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
qui margins, dydx(sdnivie) over(sdsplit)
marginsplot, legend(order(1 "Accepte baisse/Refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse") size(small)) l(95) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) name(G1, replace) title(Assurance maladie)
qui gologit2 y_Chomage_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
qui margins, dydx(sdnivie) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) name(G2, replace) title(Allocations chômage)
grc1leg G1 G2, legendfrom(G1) title(Effets marginaux niveaux de vie par questionnaire) iscale(0.7) cols(2) rows(2)




* effets marginaux PCS (moins clair)
qui gologit2 y_AM_3 ib2.PCS i.sdagetr i.sdsexe ib2.PCS#i.sdsplit i.sdsplit if annee==2020
margins, dydx(1.PCS) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) name(G1, replace) title(Indépendant) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
*qui margins, dydx(2.PCS) over(sdsplit)
*marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Baisse")) l(95) name(G2, replace) title(Indépendant) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
qui margins, dydx(3.PCS) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) name(G3, replace) title(Employé/ouvrier) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
qui margins, dydx(4.PCS) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) name(G4, replace) title(Autre inactif/Chomeur) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
qui margins, dydx(5.PCS) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) name(G5, replace) title(Retraité) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
grc1leg G1 G3 G4 G5, legendfrom(G1) title(Effets marginaux PCS par questionnaire AM) subtitle(ref: Cadre libéral prof. Intermédiaire) iscale(0.7) cols(2) rows(2)


qui gologit2 y_Chomage_3 ib2.PCS i.sdagetr i.sdsexe ib2.PCS#i.sdsplit i.sdsplit if annee==2020
margins, dydx(1.PCS) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) name(G1, replace) title(Indépendant) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
*qui margins, dydx(2.PCS) over(sdsplit)
*marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Baisse")) l(95) name(G2, replace) title(Indépendant) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
qui margins, dydx(3.PCS) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) name(G3, replace) title(Employé/ouvrier) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
qui margins, dydx(4.PCS) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) name(G4, replace) title(Autre inactif/Chomeur) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
qui margins, dydx(5.PCS) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) name(G5, replace) title(Retraité) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) nodraw
grc1leg G1 G3 G4 G5, legendfrom(G1) title(Effets marginaux PCS par questionnaire Allocations chômage) subtitle(ref: Cadre libéral prof. Intermédiaire) iscale(0.7) cols(2) rows(2)



qui gologit2 y_AM_3 ib2.PCS i.sdagetr i.sdsexe ib2.PCS#i.sdsplit i.sdsplit if annee==2020
margins, dydx(sdsplit) over(PCS)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) by(PCS) xtitle(Version du questionnaire) xlabel(2 "B" 3 "C" 4 "D")
qui gologit2 y_Chomage_3 ib2.PCS i.sdagetr i.sdsexe ib2.PCS#i.sdsplit i.sdsplit if annee==2020
margins, dydx(sdsplit) over(PCS)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) by(PCS) xtitle(Version du questionnaire) xlabel(2 "B" 3 "C" 4 "D")



/*
twoway (dot coef_`lab_`i''_sdnivie ident, mcolor(red) lpattern(solid) cmissing(n)) (line cil_`lab_`i''_sdnivie ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) (line ciu_`lab_`i''_sdnivie ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) in 1/5, yscale(range(-0.9 -0.5)) xlabel(200000001 "Q1" 200000002 "Q2" 200000003 "Q3" 200000004 "Q4" 200000005 "Q5") title("Soutien au statu quo (AvB) par quintile de niveau de vie" "Assurance Maladie") legend(order(1 "Proportion de soutien au satu quo" 2 "Intervalle de confiance"))

twoway (dot coef ident, mcolor(red) lpattern(solid) cmissing(n)) (line cil ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) (line ciu ident, lcolor(midblue%75) lpattern(dash) cmissing(n)) in 1/5, yscale(range(-0.9 -0.5)) xlabel(200000001 "Q1" 200000002 "Q2" 200000003 "Q3" 200000004 "Q4" 200000005 "Q5") title("Soutien au statu quo (AvB) par quintile de niveau de vie" "Assurance Maladie") legend(order(1 "Proportion de soutien au satu quo" 2 "Intervalle de confiance"))
*/
