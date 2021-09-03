cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"


forvalues i=1/5{
gen de4_`i' = (de4==`i')
replace de4_`i'=. if de4==.
bys annee: egen mde4_`i'=mean(de4_`i')
}


forvalues i=1/5{
bys annee: egen mde4_`i'_bis=mean(de4_`i') if sdagetr!=5
}


forvalues i=1/5{
gen de5_`i' = (de5_ab==`i')
replace de5_`i'=. if de5_ab==.
bys annee: egen mde5_`i'=mean(de5_`i')
}

forvalues i=1/4{
gen de1_`i' = (de1==`i')
replace de1_`i'=. if de1==.
bys annee: egen mde1_`i'=mean(de1_`i')
}

forvalues i=1/4{
gen de7_`i' = (de7==`i')
replace de7_`i'=. if de7==.
bys annee: egen mde7_`i'=mean(de7_`i')
}



tw (connected mde4_1 annee) (connected mde4_2 annee) (connected mde4_3 annee) (connected mde4_4 annee) (connected mde4_5 annee), xtitle("") legend(order(1 "Tout à fait" 2 "plutôt" 3 "Plutôt pas" 4 "Pas du tout" 5 "NSP")) title("Seriez-vous prêt.e à épargner davantage" "en prévision d'une éventuelle situation de dépendance?", size(medium))



g mde4_12=mde4_1 + mde4_2
g mde4_34= mde4_3 + mde4_4
tw (connected mde4_12 annee) (connected mde4_34 annee) (connected mde4_5 annee), xtitle("") legend(order(1 "Oui" 2 "Non" 3 "NSP")) title("Seriez-vous prêt.e à épargner davantage" "en prévision d'une éventuelle situation de dépendance?", size(medium))

g mde4_12_bis=mde4_1_bis + mde4_2_bis
g mde4_34_bis= mde4_3_bis + mde4_4_bis
tw (connected mde4_12_bis annee) (connected mde4_34_bis annee) (connected mde4_5_bis annee), xtitle("") legend(order(1 "Oui" 2 "Non" 3 "NSP")) title("Seriez-vous prêt.e à épargner davantage" "en prévision d'une éventuelle situation de dépendance?", size(medium))


tw (connected mde5_1 annee) (connected mde5_2 annee) (connected mde5_3 annee) (connected mde5_4 annee) (connected mde5_5 annee), xtitle("") legend(order(1 "Vous le placeriez dans une institution" 2 "Vous l'accueilleriez chez vous" 3 "Vous consacreriez une partie de votre revenu à lui payer des aides" 4 "Vous feriez en sorte de pouvoir vous en occuper" 5 "NSP") cols(1)) title("Si l'un de vos parents proches devenait dépendant, que feriez-vous ?", size(medium))

tw (connected mde7_1 annee) (connected mde7_2 annee) (connected mde7_3 annee) (connected mde7_4 annee) if annee>2010, xtitle("") legend(order(1 "Oui" 2 "Non" 3 "Non car j'ai moi même besoin d'aide" 4 "NSP") cols(1)) title("Vous personnelement, apportez-vous une aide régulière et bénévole" "à une personne âgée dépendante ? ", size(medium))


ta de1

g PS13_6= ps13_a_6
replace PS13_6 =2 if PS13_6==1
replace PS13_6=5 if PS13_6==6

mca de4 de5_ab de1 de7 PS13_6 if de4!=5 & de5_ab!=5 & de1!=4 & de7!=4, sup(sdnivie diplome sdsexe statut sdagetr) dim(5)
mcaplot de4 de5_ab de1 de7 PS13_6, overlay mlabsize(tiny) legend(order(1 "Epargne" 2 "Parents" 3 "Charge financière" 4 "AidantEs" 5 "Prestations")) name(active, replace)
mcaplot sdnivie diplome sdsexe statut sdagetr, overlay mlabsize(tiny) legend(order(1 "revenu" 2 "diplome" 3 "sexe" 4 "statut d'empoi" 5 "Age")) name(sup, replace)


g PS13D_6= ps13_d_6
replace PS13D_6=5 if PS13D_6==6

mca de1 ps13_d_6 de4 if inrange(ps13_d_6,1,4) & de4!=5 & de1!=4, sup(sdsexe statut sdagetr)
mcaplot de1 ps13_d_6 de4, overlay

mcaplot de4 de5_cd de1 de7 PS13D_6, overlay mlabsize(tiny) legend(order(1 "Epargne" 2 "Parents" 3 "Charge financière" 4 "AidantEs" 5 "Prestations")) name(active, replace)
mcaplot sdnivie diplome sdsexe statut sdagetr, overlay mlabsize(tiny) legend(order(1 "revenu" 2 "diplome" 3 "sexe" 4 "statut d'empoi" 5 "Age")) name(sup, replace)



