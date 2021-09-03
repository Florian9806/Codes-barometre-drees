cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do 8_1_taux_cotis

*************************
******SELF INTEREST******
*************************
do 9_1_1_self_interest_essai 






eststo clear
eststo: ologit Y i.bdd i.statut c.sdrevtr c.sdagetr i.sdsexe c.annee 1.bdd#c.tc_am si_am 2.bdd#c.tc_retr_tot2 si_retr 3.bdd#c.tc_famille si_fam 4.bdd#c.tc_chom si_chom   if sdrevtr!=8 & statut!=.
eststo: ologit Y i.bdd i.statut c.sdrevtr c.sdagetr i.sdsexe c.annee 1.bdd#c.tc_am si_am 2.bdd#c.tc_retr_tot si_retr 3.bdd#c.tc_famille si_fam_rev 4.bdd#c.tc_chom si_chom2   if sdrevtr!=8 & statut!=.
esttab using ologit_tc_si.tex, label nonumbers mtitles("") eform scalar(r2_p ll) compress longtable f star(* 0.1 ** 0.05 *** 0.01) keep(*tc_* si_* *bdd) replace

eststo clear
xtset id
eststo: xtologit Y i.bdd i.statut c.sdrevtr c.sdagetr i.sdsexe c.annee 1.bdd#c.tc_am si_am 2.bdd#c.tc_retr_tot2 si_retr 3.bdd#c.tc_famille si_fam 4.bdd#c.tc_chom si_chom   if sdrevtr!=8 & statut!=.
xtset id
eststo: xtologit Y i.bdd i.statut c.sdrevtr c.sdagetr i.sdsexe c.annee 1.bdd#c.tc_am si_am 2.bdd#c.tc_retr_tot si_retr 3.bdd#c.tc_famille si_fam_rev 4.bdd#c.tc_chom si_chom2 if sdrevtr!=8 & statut!=.
esttab using ologit_tc_si_ef.tex, label nonumbers mtitles("Modele 1" "Modele 2") eform scalar(r2_p ll) compress longtable f star(* 0.1 ** 0.05 *** 0.01) keep(*tc_* si_* *bdd) replace
esttab , label eform star(* 0.1 ** 0.05 *** 0.01)






eststo clear
xtset id
eststo: xtologit Y  i.statut c.sdrevtr c.sdagetr i.sdsexe i.bdd##c.annee si_am choc_am choc_tcam  si_retr si_fam choc_fam1 choc_tcfam1  si_chom choc_chom choc_tcchom if sdrevtr!=8 & statut!=.
eststo: ologit Y  i.statut c.sdrevtr c.sdagetr i.sdsexe i.bdd##c.annee si_am choc_am choc_tcam  si_retr si_fam choc_fam1 choc_tcfam1  si_chom choc_chom choc_tcchom if sdrevtr!=8 & statut!=.

/*esttab using ologit_tc_si_ef.tex, label nonumbers mtitles("Modele 1" "Modele 2") eform scalar(r2_p ll) compress longtable f star(* 0.1 ** 0.05 *** 0.01) keep(*tc_* si_* *bdd) replace */

esttab , label eform star(* 0.1 ** 0.05 *** 0.01)


/* modèle le plus aboutit : rien n'empêche de le faire tourner sur un logit
Question en matière de méthode: est ce qu'on interprète plus le modèle à effet fixe ou le modèle normal?
Peut être que ça vaudrait le coupe de faire tourner le modèle séparément sur chaque branche pour pouvoir ne pas utiliser d'effet fixe individuel rendant le contrôle des variables importantes plus difficile
Enfin dans une optique de pseudo panel on peut aussi essayer modèle effet fixe sur les statut */