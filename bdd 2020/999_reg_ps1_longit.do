cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"


*******************************************************************************
* Pas hyper utile (en tout cas pas utilisé pour le moment)
*******************************************************************************


*******************
*regression universelle contributif
*******************

local lab1 AM
local lab2 retraite
local lab3 fam
local lab4 chom
forvalues i=1/4 {
    g y_univ_`lab`i'' = 1 if ps1_ab_`i'==3
	replace y_univ_`lab`i''=0 if ps1_ab_`i'==1
	label define y_univ_`lab`i'' 0 "Affiliation du système" 1 "Ouverture des droits à tous"
	label value y_univ_`lab`i''  y_univ_`lab`i''
}

replace sdnbenf=. if sdnbenf==999999999
g n2_enfants = (sdnbenf>=2)
replace n2_enfants =. if sdnbenf==.


g traitement= (annee>=2014)

eststo clear
local lab1 AM
local lab2 retraite
local lab3 fam
local lab4 chom
forvalues i=1/4 {
    eststo : qui logit y_univ_`lab`i'' c.n2_enfants i.sdrevtr c.n2_enfants#i.sdrevtr#c.traitement c.sdage i.sdsexe i.annee 
}
esttab, star(* 0.1 ** 0.05 *** 0.01) p

eststo clear
forvalues i=2008/2017 {
    eststo : qui logit y_univ_chom c.n2_enfants i.sdrevtr c.n2_enfants#i.sdrevtr c.sdage i.sdsexe if annee==`i'
}
esttab, star(* 0.1 ** 0.05 *** 0.01) p


local lab1 AM
local lab2 retraite
local lab3 fam
local lab4 chom
forvalues i=1/4 {
    g y_minima_`lab`i'' = 1 if ps1_ab_`i'==2
	replace y_minima_`lab`i''=0 if ps1_ab_`i'==1 | ps1_ab_`i'==3
	label define y_minima_`lab`i'' 0 "Autre" 1 "Prestation uniquement pour les nécessiteux"
	label value y_minima_`lab`i'' y_minima_`lab`i''
}

eststo clear
local lab1 AM
local lab2 retraite
local lab3 fam
local lab4 chom
forvalues i=1/4 {
    eststo : qui logit y_minima_`lab`i'' c.n2_enfants##i.sdrevtr c.sdage i.sdsexe
}
esttab, star(* 0.1 ** 0.05 *** 0.01) p




