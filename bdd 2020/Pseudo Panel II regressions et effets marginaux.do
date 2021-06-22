cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"

*************************
* Regression pseudo panel
*************************

/* Variable:
y_AM = 4 catégories (1 oui+ à la baisse non + à la hausse -> 4 non+ à la baisse oui + à la hausse)
y_AM_3 = 3 catégories (oui non- non+) -> les labals sont données par rapport à la formulation A, 
il faut adapter la lecture en fonction du questionnaire
y_AM_B = binaire (0 = oui à la baisse non à la hausse) (1=non à la baisse oui à la hausse)
*/


* regression

reg y_AM i.sdsplit if annee==2020


eststo clear
eststo: qui reg y_AM i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Retraite i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Famille i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Chomage i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
esttab using REG_PP_1.tex, keep(*.sdsplit) f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) star(* 0.1 ** 0.05 *** 0.01) replace
pwcompare sdsplit, eff 

eststo clear
eststo: qui reg y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Retraite ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Famille ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Chomage ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
esttab, p eform star(* 0.1 ** 0.05 *** 0.01)

label define sdnivie 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5"
label value sdnivie sdnivie /* Inutile lorsqu'on utilise le revenu en var continu*/
label variable sdnivie "Quintiles niveau de vie"
* niveau de vie
eststo clear
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
esttab using ologit_1.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace

coefplot est1 est2 est3 est4, keep(*sdnivie) baselevel xline(0) legend(size(small))



*PCS modifier et sans niveau de vie
eststo clear
eststo: qui ologit y_AM ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite ib2.PCS i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01) p
esttab using ologit_2.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace


eststo clear
eststo: qui ologit y_AM i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
esttab using ologit_3.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace


* croisement de toute les variables
eststo clear
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
predict pred_AM_1 pred_AM_2 pred_AM_3 pred_AM_4 if annee==2020, pr
eststo: qui ologit y_Retraite ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2b.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or


esttab, nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01) noab label




*********************************************************************************
*gologit2
*********************************************************************************
eststo clear
eststo: qui gologit2 y_AM ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Retraite ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Famille ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui gologit2 y_Chomage ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
esttab, eform label star(* 0.1 ** 0.05 *** 0.01)







********************************************************************************
* ologit en 3 catégories
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

********************************
* gologit et effets marginaux
********************************

qui gologit2 y_AM_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
qui margins, dydx(sdnivie) over(sdsplit)
marginsplot, legend(order(1 "Accepte baisse/Refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse") size(small)) l(95) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) name(G1, replace) title(Assurance maladie)
qui gologit2 y_Chomage_3 i.diplome3 i.sdagetr i.sdsexe c.sdnivie c.sdnivie#i.sdsplit i.sdsplit if annee==2020
qui margins, dydx(sdnivie) over(sdsplit)
marginsplot, legend(order(1 "accepte baisse/refus hausse+" 2 "Refus baisse - /Refus hausse -" 3 "Refus baisse + / Accepte Hausse")) l(95) xlabel(1 "A" 2 "B" 3 "C" 4 "D") xtitle(Version du questionnaire) name(G2, replace) title(Allocations chômage)
grc1leg G1 G2, legendfrom(G1) title(Effets marginaux niveaux de vie par questionnaire) iscale(0.7) cols(2) rows(2)




* effets marginaux PCS
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


grstyle init
grstyle set mesh, compact
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



**********
* predict sur l'AM
**********
*ATTENTION DROP NE PAS ENREGISTREZ LES DONNEES EN FIN DE SESSIONS
drop if annee!=2020 | (sdsplit!=1 & sdsplit!=2)

replace ps2_ab=. if ps2_ab==4 & annee==2020
replace ps16_ab=. if ps16_ab==3 & annee==2020
replace ps1_ab_1=. if ps1_ab_1 ==5 & annee==2020
replace ps1_ab_2=. if ps1_ab_2 ==5 & annee==2020
replace ps1_ab_3=. if ps1_ab_3 ==5 & annee==2020
replace ps1_ab_4=. if ps1_ab_4 ==5 & annee==2020


ologit y_Chomage_3 i.diplome3 c.sdage i.sdsexe c.sdnivie if annee==2020 & sdsplit==1
predict prA_1 prA_2 prA_3
sort prA_1
gen id_prA_1 = _n if prA_1!=.
sort prA_2
gen id_prA_2 = _n if prA_2!=.
sort prA_3
gen id_prA_3 = _n if prA_3!=.

ologit y_Chomage_3 i.diplome3 c.sdage i.sdsexe c.sdnivie if annee==2020 & sdsplit==2
predict prB_1 prB_2 prB_3
sort prB_1
gen id_prB_1 = _n if prB_1!=.
sort prB_2
gen id_prB_2 = _n if prB_2!=.
sort prB_3 
gen id_prB_3 = _n if prB_3!=.

* incoherence A1 B3
* SQ B1 A3

tw (scatter id_prB_3 id_prA_3) (lfitci id_prB_3 id_prA_3)
tw (scatter id_prB_2 id_prA_2) (lfitci id_prB_2 id_prA_2)
tw (scatter id_prB_1 id_prA_1) (lfitci id_prB_1 id_prA_1)


scatter prA_1 prB_1 if sdsplit==2, by(y_AM_3)
tw (scatter prA_1 prB_3) (lfit prA_1 prB_3) if (sdsplit==1 | sdsplit==2) & annee==2020
tw (scatter prA_3 prB_1) (lfit prA_3 prB_1) if (sdsplit==1 | sdsplit==2) & annee==2020

tw (scatter prA_1 prB_1) (lfit prA_1 prB_1) (qfit prA_1 prB_1) if (sdsplit==1 | sdsplit==2) & annee==2020

tw (scatter prA_2 prB_2) (lfit prA_2 prB_2) if (sdsplit==1 | sdsplit==2) & annee==2020
tw (scatter prA_3 prB_3) (lfit prA_3 prB_3) if (sdsplit==1 | sdsplit==2) & annee==2020

gen incoherence = prA_1*prB_3
histogram incoherence if (sdsplit==1 | sdsplit==2) & annee==2020
sum incoherence
gen statuquo = prA_3*prB_1
histogram statuquo if (sdsplit==1 | sdsplit==2) & annee==2020
sum statuquo if (sdsplit==1 | sdsplit==2) & annee==2020 /* 0.30*/

histogram prB_1 if sdsplit==1 & y_AM_3==1 & annee==2020
histogram prA_3 if sdsplit==1 & y_AM_3==1 & annee==2020


ologit y_AM_3 i.ps2_ab i.ps16_ab i.ps1_ab_1 c.sdnivie if annee==2020 & sdsplit==1, or
estat ic
predict prA_1_bis prA_2_bis prA_3_bis if annee==2020
ologit y_AM_3 i.ps2_ab i.ps16_ab i.ps1_ab_1 i.sdnivie if annee==2020 & sdsplit==2
predict prB_1_bis prB_2_bis prB_3_bis if annee==2020
tw (scatter prA_1_bis prB_3_bis) (lfit prA_1_bis prB_3_bis) if (sdsplit==1 | sdsplit==2) & annee==2020
tw (lfit prA_1 prB_3) (lfit prA_1_bis prB_3_bis) if (sdsplit==1 | sdsplit==2) & annee==2020, legend(order(1 "modele 1" 2 "modele 2 sans variable socio-demographique"))
tw (lfit prA_3 prB_1) (lfit prA_3_bis prB_1_bis) if (sdsplit==1 | sdsplit==2) & annee==2020, legend(order(1 "modele 1" 2 "modele 2 sans variable socio-demographique"))
tw (lfit prA_1 prB_1) (lfit prA_1_bis prB_1_bis) if (sdsplit==1 | sdsplit==2) & annee==2020, legend(order(1 "modele 1" 2 "modele 2 sans variable socio-demographique"))
tw (lfit prA_2 prB_2) (lfit prA_2_bis prB_2_bis) if (sdsplit==1 | sdsplit==2) & annee==2020, legend(order(1 "modele 1" 2 "modele 2 sans variable socio-demographique"))
tw (lfit prA_3 prB_3) (lfit prA_3_bis prB_3_bis) if (sdsplit==1 | sdsplit==2) & annee==2020, legend(order(1 "modele 1" 2 "modele 2 sans variable socio-demographique"))


tw (scatter prA_1 prB_1) (lfit prA_1 prB_1) (lfitci prA_1 prB_1)  if (sdsplit==1 | sdsplit==2) & annee==2020


eststo clear
eststo: reg prB_1 i.y_AM_3 if (sdsplit==2 ) & annee==2020
eststo: reg prB_2 i.y_AM_3 if (sdsplit==2 ) & annee==2020
eststo: reg prB_3 i.y_AM_3 if (sdsplit==2 ) & annee==2020
eststo: reg prB_1_bis i.y_AM_3 if (sdsplit==2 ) & annee==2020
eststo: reg prB_2_bis i.y_AM_3 if (sdsplit==2 ) & annee==2020
eststo: reg prB_3_bis i.y_AM_3 if (sdsplit==2 ) & annee==2020
esttab, star(* 0.1 ** 0.05 *** 0.01)

eststo clear
eststo: reg id_prB_1 i.y_AM_3 if (sdsplit==2 ) & annee==2020
eststo: reg id_prB_2 i.y_AM_3 if (sdsplit==2 ) & annee==2020
eststo: reg id_prB_3 i.y_AM_3 if (sdsplit==2 ) & annee==2020
eststo: reg id_prA_1 i.y_AM_3 if (sdsplit==1 ) & annee==2020
eststo: reg id_prA_2 i.y_AM_3 if (sdsplit==1 ) & annee==2020
eststo: reg id_prA_3 i.y_AM_3 if (sdsplit==1 ) & annee==2020
esttab, star(* 0.1 ** 0.05 *** 0.01) p


eststo clear
eststo: reg prA_1 i.y_AM_3 if (sdsplit==1 ) & annee==2020
eststo: reg prA_2 i.y_AM_3 if (sdsplit==1 ) & annee==2020
eststo: reg prA_3 i.y_AM_3 if (sdsplit==1 ) & annee==2020
eststo: reg prA_1_bis i.y_AM_3 if (sdsplit==1 ) & annee==2020
eststo: reg prA_2_bis i.y_AM_3 if (sdsplit==1 ) & annee==2020
eststo: reg prA_3_bis i.y_AM_3 if (sdsplit==1 ) & annee==2020
esttab, star(* 0.1 ** 0.05 *** 0.01)

reg y_AM i.diplome i.sdagetr i.sdsexe c.sdnivie if annee==2020 & sdsplit==1
predict prOLS_A
reg y_AM_3 i.diplome i.sdagetr i.sdsexe c.sdnivie c.sdpol if annee==2020 & sdsplit==2
predict prOLS_B

reg y_AM_3 prOLS_A i.diplome i.sdagetr i.sdsexe c.sdnivie if (sdsplit==2 ) & annee==2020
reg prOLS_B y_AM_3 if (sdsplit==2) & annee==2020
reg prOLS_B prOLS_A if (sdsplit==1 | sdsplit==2) & annee==2020



reg y_AM_3 i.diplome i.sdagetr i.sdsexe c.sdnivie i.ps2_ab i.ps16_ab i.ps1_ab_1 if annee==2020 & sdsplit==1
predict prOLS_A2
reg y_AM_3 i.diplome i.sdagetr i.sdsexe c.sdnivie i.ps2_ab i.ps16_ab i.ps1_ab_1 if annee==2020 & sdsplit==2
predict prOLS_B2

tw (scatter prOLS_A2 prOLS_B2) (lfit prOLS_A2 prOLS_B2) if (sdsplit==1 | sdsplit==2) & annee==2020

reg prOLS_A2 y_AM_3 if (sdsplit==1 ) & annee==2020
reg prOLS_B2 y_AM_3 if (sdsplit==2) & annee==2020
reg prOLS_B2 prOLS_A2 if (sdsplit==1 | sdsplit==2) & annee==2020




logit y_AM_B i.diplome3 c.sdage i.sdsexe c.sdnivie i.ps2_ab i.ps16_ab i.ps1_ab_1 if annee==2020 & sdsplit==1
predict prA_B
sort prA_B
gen id_prA_B = _n if prA_B!=.


logit y_AM_B i.diplome3 c.sdage i.sdsexe c.sdnivie i.ps2_ab i.ps16_ab i.ps1_ab_1 if annee==2020 & sdsplit==2
predict prB_B
sort prB_B
gen id_prB_B = _n if prB_B!=.

tw (scatter id_prA_B id_prB_B) (lfit id_prA_B id_prB_B) (lfitci id_prA_B id_prB_B)

reg id_prA_B id_prB_B
eststo clear
eststo : reg id_prA_B y_AM_B if sdsplit==1
eststo : reg id_prB_B y_AM_B if sdsplit==2
esttab , star(* 0.1 ** 0.05 *** 0.01) p





***************************************************
* AvC
***************************************************

drop if annee!=2020 | (sdsplit!=1 & sdsplit!=3)

replace ps2_ab=. if ps2_ab==4 & annee==2020
replace ps16_ab=. if ps16_ab==3 & annee==2020
replace ps1_ab_1=. if ps1_ab_1 ==5 & annee==2020
replace ps1_ab_2=. if ps1_ab_2 ==5 & annee==2020
replace ps1_ab_3=. if ps1_ab_3 ==5 & annee==2020
replace ps1_ab_4=. if ps1_ab_4 ==5 & annee==2020

ologit y_Chomage_3 i.diplome3 c.sdage i.sdsexe c.sdnivie if annee==2020 & sdsplit==1
predict prA_1 prA_2 prA_3
sort prA_1
gen id_prA_1 = _n if prA_1!=.
sort prA_2
gen id_prA_2 = _n if prA_2!=.
sort prA_3
gen id_prA_3 = _n if prA_3!=.

ologit y_Chomage_3 i.diplome3 c.sdage i.sdsexe c.sdnivie if annee==2020 & sdsplit==3
predict prC_1 prC_2 prC_3
sort prC_1
gen id_prC_1 = _n if prC_1!=.
sort prC_2
gen id_prC_2 = _n if prC_2!=.
sort prC_3 
gen id_prC_3 = _n if prC_3!=.


tw (scatter id_prA_3 id_prC_3) (lfitci id_prA_3 id_prC_3)
tw (scatter id_prA_2 id_prC_2) (lfitci id_prA_2 id_prC_2)
tw (scatter id_prA_1 id_prC_1) (lfitci id_prA_1 id_prC_1)



********************************************************************
* réponses NSP NC
********************************************************************

local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4{
	g y_NCNSP_`lab_`i'' = ((ps13_a_`i'==5 | ps13_a_`i'==6 | ps13_b_`i'==5| ps13_b_`i'==6 | ps13_c_`i'==5 | ps13_c_`i'==6 | ps13_d_`i'==5 | ps13_d_`i'==6) & annee==2020)
}


eststo clear
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4{
	eststo: qui logit y_NCNSP_`lab_`i'' i.sdsplit if annee==2020
}
esttab using NCNSP1.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress longtable f star(* 0.1 ** 0.05 *** 0.01) p replace


eststo clear
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4{
	eststo: qui logit y_NCNSP_`lab_`i'' i.sdagetr i.diplome3 i.sdsplit if annee==2020
}
esttab using NCNSP2.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress longtable f star(* 0.1 ** 0.05 *** 0.01) p replace

eststo clear
local lab_1 "AM"
local lab_2 "Retraite"
local lab_3 "Famille"
local lab_4 "Chomage"
forvalues i=1/4{
	eststo: qui logit y_NCNSP_`lab_`i'' c.sdage#i.sdsplit i.sdsplit if annee==2020
}
esttab using NCNSP3.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress longtable f star(* 0.1 ** 0.05 *** 0.01) p replace






















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








