cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"





**********
* predict sur l'AM
* pb de drop, vérifier le champ des predict, 
* peut être erroné et faussé le résultat ou le rendre illisible
**********

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
