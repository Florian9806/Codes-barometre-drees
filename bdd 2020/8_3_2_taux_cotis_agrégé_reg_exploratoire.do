
* Code peu utilse par rapport aux éléments du rapport, exploratoire



*******************************************************************************
* Taux de cotisation agrégé
*******************************************************************************


g TC = tc_am + tc_chom + tc_retr_tot2 + tc_famille



gen bdd1=1
expand 2 if bdd1==1, gen(bdd2)
expand 2 if bdd2==1, gen(bdd3)
expand 2 if bdd3==1, gen(bdd4)


g bdd=1 if bdd1==1 & bdd2==0
forvalues i=2/3{
	local j = `i'+1
	replace bdd=`i' if bdd`i'==1 & bdd`j'==0
}
replace bdd=4 if bdd4==1


g Y = ps13_a_1 if bdd==1 & inrange(ps13_a_1,1,4)
forvalues i=2/4{
	replace Y = ps13_a_`i' if bdd==`i' & inrange(ps13_a_`i', 1, 4)
}

g TC_Y = tc_am if bdd==1
replace TC_Y = tc_retr_tot2 if bdd==2
replace TC_Y = tc_famille if bdd==3
replace TC_Y = tc_chom if bdd==4


label define Y 1 "Oui tout à fait" 2 "Oui plutôt" 3 "Non plutôt pas" 4 "Non pas du tout"
label value Y Y


/*
egen id=group(ident)


ologit Y i.bdd##i.statut c.sdrevtr c.sdagetr i.statut tc_am tc_chom tc_retr_tot2 tc_famille c.annee  if sdrevtr!=8

drop if statut==.
sort  statut annee
xtset id
xtologit Y i.bdd##i.statut c.sdrevtr c.sdagetr i.statut tc_am tc_chom tc_retr_tot2 tc_famille c.annee  if sdrevtr!=8 & statut!=.

xtset id
xtologit Y i.bdd##i.statut c.sdrevtr c.sdagetr i.statut 1.bdd#c.tc_am 4.bdd#c.tc_chom 2.bdd#c.tc_retr_tot2 3.bdd#c.tc_famille c.annee  if sdrevtr!=8 & statut!=.


eststo clear
forvalues i =0/3 {
	eststo : qui ologit Y i.bdd##i.statut c.sdrevtr c.sdagetr i.statut c.annee  if sdrevtr!=8 & inrange(annee, 2000+`i'*5, 2004+`i'*5)
}
esttab , label mtitles("2000-2004" "2005-2009"  "20010-2014" "2015-2019") scalar(r2_p ll) star(* 0.1 ** 0.05 *** 0.01) eform
*/