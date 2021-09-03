


g am_1316 = (inrange(annee, 2013, 2016))
g am17 = (inrange(annee, 2017, 2020))
g indep = (sdstat==3 | sdstat==4)
g fam_15 = (annee>=2015)

g traitement_chom2003 = inrange(annee, 2003, 2020)
g traité_chom2003 = (sdstat==2)



g traitement_chom18 = inrange(annee,2018, 2020)
g traité_chom18 = (sdstat==2)

*drop tendance_chom18
g tendance_chom18 = inrange(annee, 2014, 2018)



g traitement_csg = inrange(annee,2018, 2020)
g traité_csg = (sdres_6==1 | sdres_7==1 | (sdres_5==1 & inrange(sdrevtr, 5, 7) ) )



g traitement_famille = inrange(annee,2018, 2020)
g traité_famille = (inrange(statut,2,3))



g traitement_agirc=inrange(annee, 2008, 2020)
g traité_agirc=(pcs8==2 & sdstat==2)	



g traitement_agirc2 = inrange(annee, 2016, 2020)




g traitement_ret_fp = inrange(annee, 2012, 2020)
g traitement_ret_fp2 = (annee==2012)
replace traitement_ret_fp2=2 if annee==2013
replace traitement_ret_fp2=3 if annee==2014
replace traitement_ret_fp2=4 if annee==2015
replace traitement_ret_fp2=5 if annee==2016
replace traitement_ret_fp2=6 if annee==2017
replace traitement_ret_fp2=7 if annee==2018
g traitement_ret_fp3 = inrange(annee, 2014, 2020)


g traité_ret_fp = (statut==1)




g traitement_ret_ind= inrange(annee, 2014, 2020)
g traitement_ret_ind2= inrange(annee, 2016, 2020)
g traité_ret_ind=inrange(statut, 3,4)