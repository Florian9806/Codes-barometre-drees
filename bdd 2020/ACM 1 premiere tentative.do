cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"


* necessite package svmat2

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

