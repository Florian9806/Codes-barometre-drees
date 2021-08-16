cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

forvalues i=1/7{
	rename ps13_a_`i' ps13_`i'
}

merge 1:1 ident ident using bdd2016unif, keepusing(ps13_1 ps13_2 ps13_3 ps13_4 ps13_5 ps13_6 ps13_7) update
