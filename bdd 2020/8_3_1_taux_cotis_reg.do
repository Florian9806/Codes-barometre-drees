cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"


do 8_1_taux_cotis





********************************************************************************
* Régressions par branche
********************************************************************************

eststo clear

eststo : qui ologit ps13_a_1 tc_am i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_1, 1, 4)

eststo : qui ologit ps13_a_2 tc_retr_tot2 i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)

eststo: qui ologit ps13_a_3 tc_famille i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4)

eststo: qui ologit ps13_a_4 tc_chom i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_4, 1, 4)

esttab using ologit_tc.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform scalar(r2_p ll converged) compress longtable f  not star(* 0.1 ** 0.05 *** 0.01) replace
esttab using ologit_tc2.tex, label nonumbers mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform scalar(r2_p ll converged) compress longtable f  p star(* 0.1 ** 0.05 *** 0.01) keep(tc_*) replace

esttab , label mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") eform scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01)


eststo clear
eststo: qui ologit ps13_a_3 tc_famille i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4)
eststo: qui ologit ps13_a_3 tc_famille i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4) & sdstat!=3 & sdstat!=4
esttab , label mtitles("Modèle global" "Sans les indépendants") eform scalar(r2_p ll) star(* 0.1 ** 0.05 *** 0.01)


eststo clear
eststo : qui ologit ps13_a_2 tc_retr_tot2 i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)
eststo : qui ologit ps13_a_2 tc_retr_tot i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)
esttab , label mtitles("Avec T2" "Sans T2") eform scalar(r2_p ll converged) star(* 0.1 ** 0.05 *** 0.01) p
esttab using ologit_tc_retr.tex, label nonumbers mtitles("Retraite" "Retraite sans T2 régime général") eform scalar(r2_p ll) compress longtable f  p star(* 0.1 ** 0.05 *** 0.01) keep(tc_*) replace


* regression croisant taux de cotisation et statut d'emploi

eststo clear

eststo : qui reg ps13_a_1 c.tc_am#i.sdstat i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_1, 1, 4)

eststo : qui reg ps13_a_2 c.tc_retr_tot2#i.sdstat i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)

eststo: qui reg ps13_a_3 c.tc_famille#i.sdstat i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4)

eststo: qui reg ps13_a_4 c.tc_chom#i.sdstat i.sdstat c.annee i.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_4, 1, 4)

esttab , label mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") scalar(r2 ar2 ll) star(* 0.1 ** 0.05 *** 0.01)


* regression avec contrôle niveau de revenus

eststo clear
eststo : qui ologit ps13_a_1 tc_am i.sdstat c.sdrevtr c.annee c.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_1, 1, 4) & sdrevtr!=8
eststo : qui ologit ps13_a_2 tc_retr_tot2 i.sdstat c.sdrevtr c.annee c.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_2, 1, 4)  & sdrevtr!=8
eststo: qui ologit ps13_a_3 tc_famille i.sdstat c.sdrevtr c.annee c.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_3, 1, 4) & sdrevtr!=8
eststo: qui ologit ps13_a_4 tc_chom i.sdstat c.sdrevtr c.annee c.sdagetr i.diplome4 i.sdsexe if inrange(ps13_a_4, 1, 4) & sdrevtr!=8
esttab , label mtitles("Assurance maladie" "Retraite" "Alloc familiales" "Alloc chomages") scalar(r2 ar2 ll) star(* 0.1 ** 0.05 *** 0.01) eform p



g am_1316 = (inrange(annee, 2013, 2016))
g am17 = (inrange(annee, 2017, 2020))
g indep = (sdstat==3 | sdstat==4)

ologit ps13_a_1 ib0.indep##ib0.am_1316  c.annee c.sdagetr c.sdsexe c.sdrevtr if inrange(ps13_a_1, 1, 4)


g fam_15 = (annee>=2015)
ologit ps13_a_2 ib0.indep##ib0.fam_15  c.sdagetr c.sdsexe c.sdrevtr if inrange(ps13_a_2, 1, 4)
