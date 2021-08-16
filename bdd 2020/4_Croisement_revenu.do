cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"


****************************************************************************
********************** Très exploratoire****************************
* croisement soutien protection sociale avec origine de revenus
* + test du chi2 en fin de programme
****************************************************************************

* [chomage -> sdres_4] [Rsa -> sdres_3]

catplot ps1_ab_4 if annee>=2016 & sdres_4!=3, over(sdres_4, label(labsize(vsmall) labcolor(black))) percent(sdres_4) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocation chômage" "chez les bénéficiaires des allocations chomages") vertical

catplot ps1_ab_4 if annee>=2016 & sdres_3!=3, over(sdres_3, label(labsize(vsmall) labcolor(black))) percent(sdres_3) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocation chômage" "chez les bénéficiaires des allocations chomages") vertical

catplot ps2_ab if annee<2016, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocation chômage" "chez les allocataires RSA et chomage") vertical stack

catplot ps16_ab if annee>=2016, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocation chômage" "chez les allocataires RSA et chomage") vertical stack

catplot ps13_a_4 if annee>=2016, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la baisse des allocations chomages" "chez les allocataires RSA et chomage") vertical stack

* rsa:

ta pe9_ab if annee!=2020
ta pe9_ab if annee==2020
ta pe9_cd /* formulation pdt la crise covid */
catplot pe9_ab, over(annee) percent(annee) asyvars vertical stack
catplot pe9_ab, over(pcs8) percent(pcs8) asyvars vertical
catplot pe9_ab, over(pcs6_4) percent(pcs6_4) asyvars vertical

* intéressant de voir que les catégories salariés de la pcs8 ne jouent pas beaucoup tandis que celle de la pcs6_4 si

catplot pe9_ab, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien au rsa" "chez les allocataires RSA et chomage") vertical



/* question filtré pe9=="augmenter le rsa" , acceptez-vous une augmentation des impôts*/
ta pe10 
catplot pe10, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Augmentation des impots pour augmenter le RSA" "chez les allocataires RSA et chomage") vertical

ta pe17_ab if annee!=2020 /*rsa jeune*/
ta pe17_ab if annee==2020
ta pe17_cd

catplot pe17_ab, over(chomrsa, label(labsize(vsmall) labcolor(black))) percent(chomrsa) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Ouverture du RSA au jeune" "chez les allocataires RSA et chomage") vertical

catplot pe17_ab, over(sdagetr, label(labsize(vsmall) labcolor(black))) percent(sdagetr) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Ouverture du RSA au jeune" "Par tranche d'âge") vertical

catplot pe17_ab if sdagetr!=1, over(pcs6_4, label(labsize(vsmall) labcolor(black))) percent(pcs6_4) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Ouverture du RSA au jeune" "Par PCS chez les plus de 25 ans") vertical


catplot pe13_ab, over(sdagetr, label(labsize(vsmall) labcolor(black))) percent(sdagetr) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la limitation des allocations chomages dans le temps") vertical
catplot pe13_cd, over(sdagetr, label(labsize(vsmall) labcolor(black))) percent(sdagetr) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la prolongation des allocations chomages en cas de crise") vertical





*Allocation familiale sdres_8

catplot ps13_a_3 if annee>=2016 & sdres_8!=3, over(sdres_8, label(labsize(vsmall) labcolor(black))) percent(sdres_8) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la baisse des allocations familiales" "chez les allocataires") vertical stack

catplot ps1_ab_3 if annee>=2016 & sdres_8!=3, over(sdres_8, label(labsize(vsmall) labcolor(black))) percent(sdres_8) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Soutien à la baisse des allocations familiales" "chez les allocataires") vertical stack

catplot fa13_ab, over(annee) percent(annee) asyvars vertical stack
* pas d'évolution dûe à la crise sanitaire


catplot fa13_cd if sdres_8!=3, over(sdres_8, label(labsize(vsmall) labcolor(black))) percent(sdres_8) asyvars blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Type d'allocations familiales" "chez les allocataires") vertical stack




*revenus financiers et de locations (sdres_6 sdres_7)




* test du chi2, analyse de la significativité des variations
* nb: catégorie chomeur trop faible donc retirée

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

* difficile de lire ces tests car trop peu de données


* graphes longitudinales (peu intéressant voir do-file 1)
catplot ps13_a_2, over(annee, label(labsize(vsmall) labcolor(black) angle(45))) percent(annee) asyvars legend(pos(1) color(black)) blabel(dot, position(center) format(%3.1f) color(white) size(vsmall)) vertical stack

catplot ps1_ab_3, over(annee, label(labsize(vsmall) labcolor(black) angle(45))) percent(annee) asyvars legend(pos(1) color(black)) blabel(dot, position(center) format(%3.1f) color(white) size(vsmall)) vertical stack


