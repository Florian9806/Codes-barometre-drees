cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"



*****************
*mca pseudo panel
*****************
replace ps2_ab=2 if ps2_ab==4
replace ps16_ab=. if ps16_ab==3 
replace ps2_cd=. if ps2_cd==4 
replace ps16_cd=. if ps16_cd==3 
/*replace ps1_ab_1=. if ps1_ab_1==5 
replace ps1_ab_2=. if ps1_ab_2==5 
replace ps1_ab_3=. if ps1_ab_3==5 
replace ps1_ab_4=. if ps1_ab_4==5 
replace ps1_cd_1=. if ps1_cd_1==5
replace ps1_cd_2=. if ps1_cd_2==5 
replace ps1_cd_3=. if ps1_cd_3==5 
replace ps1_cd_4=. if ps1_cd_4==5
*/
replace ps15_ab_1=. if ps15_ab_1==5
replace ps15_ab_2=. if ps15_ab_2==5
replace ps15_ab_3=. if ps15_ab_3==5
replace ps15_cd_1=. if ps15_cd_1==5
replace ps15_cd_2=. if ps15_cd_2==5
replace ps15_cd_3=. if ps15_cd_3==5
replace ps3_ab=2 if ps3_ab==4
replace ps3_cd=2 if ps3_cd==4
label drop ps1_ab_4
label define ps1_ab_4 1 "Contributif" 2 "Minima" 3 "Universel" 4 "Mixte"
label value ps1_ab_1 ps1_ab_4
label value ps1_ab_2 ps1_ab_4
label value ps1_ab_3 ps1_ab_4
label value ps1_ab_4 ps1_ab_4
label value ps1_cd_1 ps1_ab_4
label value ps1_cd_2 ps1_ab_4
label value ps1_cd_3 ps1_ab_4
label value ps1_cd_4 ps1_ab_4

label drop ps2_ab
label define ps2_ab 1 "Plus de cotise entreprises" 2 "Moins de cotise entreprise" 3 "Ni plus ni moins de cotise entreprise"
label value ps2_ab ps2_ab
label value ps2_cd ps2_ab

label define y_3 1 "Y=1" 2 "Y=2" 3 "Y=3"
label value  y_AM_3 y_3
label value  y_Chomage_3 y_3
label value  y_Retraite_3 y_3
label value  y_Famille_3 y_3

g retraite = (PCS==5)
*drop ps1ab4
g ps1ab4 = 1 if ps1_ab_4==1 /*contrib*/
replace ps1ab4 = 2 if ps1_ab_4==3 /*universel*/
replace ps1ab4 = 3 if ps1ab4==. & (annee!=2020 | (sdsplit==1 | sdsplit==2)) /*autres*/
replace ps1ab4 =. if ps1_ab_4==. & annee==2016
label define ps1ab4 1  "Contributif" 2 "Universel" 3 "Autre"
label value ps1ab4 ps1ab4


g ps1cd4 = 1 if ps1_cd_4==1 /*contrib*/
replace ps1cd4 = 2 if ps1_cd_4==3 /*universel*/
replace ps1cd4 = 3 if ps1cd4==. & (annee!=2020 | (sdsplit==3 | sdsplit==4)) /*autres*/
replace ps1cd4 =. if ps1_cd_4==. & annee==2016
label define ps1cd4 1  "Contributif" 2 "Universel" 3 "Autre"
label value ps1cd4 ps1cd4

replace pe13_ab =. if pe13_ab==3
replace pe14_1=. if pe14_1==3
replace pe14_2=. if pe14_2==3
replace pe14_3=. if pe14_3==3
replace pe14_4=. if pe14_4==3


g PS13A1 = ps13_a_1
replace PS13A1 = 5 if ps13_a_1==6 | ps13_a_1==.

g PS13B1 = ps13_b_1
replace PS13B1 = 5 if ps13_b_1==6 | ps13_b_1==.

g PS13A4 = 1 if ps13_a_4==1 | ps13_a_4==2
replace PS13A4 = 2  if ps13_a_4==3
replace PS13A4 = 3 if ps13_a_4==4
replace PS13A4 = 5 if ps13_a_4==6 | ps13_a_4==.
label define PS13A4 1 "Oui" 2 "Non -" 3 "Non +" 4 "x"
label value PS13A4 PS13A4

g PS13B4 = 1 if ps13_b_4==1 | ps13_b_4==2
replace PS13B4 = 2  if ps13_b_4==3
replace PS13B4 = 3 if ps13_b_4==4
replace PS13B4 = 5 if ps13_b_4==6 | ps13_b_4==.
label value PS13B4 PS13A4


replace sdnbenf=. if sdnbenf==999999999
g n2_enfants = (sdnbenf>=2)
replace n2_enfants =. if sdnbenf==.


g enfant=(sdnbenf>0)
g enfant2=0 if sdnbenf==0
replace enfant2=1 if sdnbenf==1
replace enfant2=2 if sdnbenf>1

label variable sdnivie "Quintile de niveau de vie"

replace sdstat=. if sdstat==7

replace sdres_1=. if sdres_1==3
replace sdres_2=. if sdres_2==3
replace sdres_3=. if sdres_3==3
replace sdres_4=. if sdres_4==3
replace sdres_5=. if sdres_5==3
replace sdres_6=. if sdres_6==3
replace sdres_7=. if sdres_7==3
replace sdres_8=. if sdres_8==3
replace sdres_9=. if sdres_9==3
replace sdres_10=. if sdres_10==3
replace og4_6=. if og4_6==5
replace og4_6=3 if og4_6==4
*replace ps13_a_4=5 if ps13_a_4==6



forvalues i=1/4{
 g PS1_`i'=ps1_ab_`i'
 replace PS1_`i'=4 if PS1_`i'==5 | PS1_`i'==4
}


grstyle init
grstyle set mesh, compact
