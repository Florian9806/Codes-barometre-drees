cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"

*************************
* Regression pseudo panel
*************************

/* Variables créer dans le do-file ci-dessus ci-dessus :
y_AM = 4 catégories (1 oui+ à la baisse ou non + à la hausse [ne soutien pas] -> 4 non + à la baisse oui + à la hausse [soutien à la hausse])
y_AM_3 = 3 catégories (oui non- non+) -> les labals sont données par rapport à la formulation A, 
il faut adapter la lecture en fonction du questionnaire
y_AM_B = binaire (0 = oui à la baisse non à la hausse) (1=non à la baisse oui à la hausse)
*/


* Regression linéaire, effet fixe du questionnaire


reg y_AM i.sdsplit if annee==2020


eststo clear
eststo: qui reg y_AM i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Retraite i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Famille i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Chomage i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit if annee==2020

* sortie REG_PP_1.tex
esttab using REG_PP_1.tex, keep(*.sdsplit) f label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) star(* 0.1 ** 0.05 *** 0.01) replace
pwcompare sdsplit, eff 


eststo clear
eststo: qui reg y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Retraite ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Famille ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
eststo: qui reg y_Chomage ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#i.sdsexe i.sdsplit#i.sdnivie i.sdsplit if annee==2020
esttab, p eform star(* 0.1 ** 0.05 *** 0.01)

**************************************
* Croisement formulation niveau de vie
****************************************
eststo clear
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.pcs5 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#c.sdnivie i.sdsplit if annee==2020, or

esttab using ologit_1.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace

coefplot est1 est2 est3 est4, keep(*sdnivie) baselevel xline(0) legend(size(small))


**************************************
* croisement formulation PCS modifiée et sans niveau de vie
**************************************

eststo clear
eststo: qui ologit y_AM ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite ib2.PCS i.sdagetr i.sdsexe c.sdnivie i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.PCS i.sdagetr i.sdsexe i.sdsplit#ib2.PCS i.sdsplit if annee==2020, or

esttab, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01) p

esttab using ologit_2.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace

**************************************
* croisement formulation diplôme
**************************************

eststo clear
eststo: qui ologit y_AM i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Retraite i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage i.diplome3 i.sdagetr i.sdsexe c.sdnivie i.sdsplit#i.diplome3 i.sdsplit if annee==2020, or

esttab using ologit_3.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) compress not longtable f star(* 0.1 ** 0.05 *** 0.01) replace


**************************************
* croisement formulation toutes variables
**************************************
eststo clear
eststo: qui ologit y_AM ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020
predict pred_AM_1 pred_AM_2 pred_AM_3 pred_AM_4 if annee==2020, pr
eststo: qui ologit y_Retraite ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or
eststo: qui ologit y_Famille ib2b.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or
eststo: qui ologit y_Chomage ib2.pcs5 i.sdagetr i.sdsexe i.sdnivie i.sdsplit#ib2.pcs5 i.sdsplit#i.sdnivie i.sdsplit#i.sdagetr i.sdsplit#i.sdsexe i.sdsplit if annee==2020, or


esttab, nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform addnote("Source: Baromètre Drees BVA 2020") scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01) noab label



