cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"


g n2_enfant = (sdnbenf>=2 & sdnbenf<20)


*************************************************************************
* I- PS1
* II - PS13



**************************************************************************
* PS1 longitudinale
**************************************************************************

* création des variables longitudinales pour les 4 branches et les 4 modalitées

gen contrib100=(ps1_ab_1==1 & ps1_ab_2==1 & ps1_ab_3==1 & ps1_ab_4==1)
replace contrib100=. if ps1_ab_1==. | ps1_ab_2==. | ps1_ab_3==. | ps1_ab_4==.
bys annee: egen meancontrib100 = mean(contrib100)

gen contribAM=(ps1_ab_1==1)
replace contribAM=. if ps1_ab_1==.
bys annee: egen meancontribam = mean(contribAM)

gen contribretraite=(ps1_ab_2==1)
replace contribretraite=. if ps1_ab_2==.
bys annee: egen meancontribretraite = mean(contribretraite)

gen contribfamille=(ps1_ab_3==1)
replace contribfamille=. if ps1_ab_3==.
bys annee: egen meancontribfamille = mean(contribfamille)

gen contribchomage=(ps1_ab_4==1)
replace contribchomage=. if ps1_ab_4==.
bys annee: egen meancontribchomage = mean(contribchomage)

gen univ100=(ps1_ab_1==3 & ps1_ab_2==3 & ps1_ab_3==3 & ps1_ab_4==3)
replace univ100=. if ps1_ab_1==.
bys annee: egen meanuniv100 = mean(univ100)

gen univAM=(ps1_ab_1==3)
replace univAM=. if ps1_ab_1==.
bys annee: egen meanunivAM = mean(univAM)

gen univretraite=(ps1_ab_2==3)
replace univretraite=. if ps1_ab_2==.
bys annee: egen meanunivretraite = mean(univretraite)

gen univfamille=(ps1_ab_3==3)
replace univfamille=. if ps1_ab_3==.
bys annee: egen meanunivfamille = mean(univfamille)

gen univchomage=(ps1_ab_4==3)
replace univchomage=. if ps1_ab_4==.
bys annee: egen meanunivchomage = mean(univchomage)

gen minima100=(ps1_ab_1==2 & ps1_ab_2==2 & ps1_ab_3==2 & ps1_ab_4==2)
replace minima100=. if ps1_ab_1==.
bys annee: egen meanminima100 = mean(minima100)

gen minimaAM=(ps1_ab_1==2)
replace minimaAM=. if ps1_ab_1==.
bys annee: egen meanminimaAM = mean(minimaAM)

gen minimaretraite=(ps1_ab_2==2)
replace minimaretraite=. if ps1_ab_2==.
bys annee: egen meanminimaretraite = mean(minimaretraite)

gen minimafamille=(ps1_ab_3==2)
replace minimafamille=. if ps1_ab_3==.
bys annee: egen meanminimafamille = mean(minimafamille)

gen minimachomage=(ps1_ab_4==2)
replace minimachomage=. if ps1_ab_4==.
bys annee: egen meanminimachomage = mean(minimachomage)

gen AM=(ps1_ab_1==4)
replace AM=. if ps1_ab_1==.
bys annee: egen meanAM = mean(AM)

gen retr=(ps1_ab_2==4)
replace retr=. if ps1_ab_2==.
bys annee: egen meanretr = mean(retr)

gen fam=(ps1_ab_3==4)
replace fam=. if ps1_ab_3==.
bys annee: egen meanfam = mean(fam)

gen chom=(ps1_ab_4==4)
replace chom=. if ps1_ab_4==.
bys annee: egen meanchom = mean(chom)



**************************
* Graphiuqes PS1
**************************

grstyle init
grstyle set mesh, compact


*graph soutien à un système contributif
tw (connected meancontribam annee) (connected meancontribretraite annee) (connected meancontribfamille annee) (connected meancontribchomage annee)  (connected meancontrib100 annee), xtitle("") title(Part de soutien à un système contributif par année et par branche) legend(order(1 "Assurance maladie" 2 "Retraite" 3 "Allocations familiales" 4 "Allocations chômages" 5 "Soutien à un système 100% contributif"))


*graph à un système universel
tw (connected meanunivAM annee) (connected meanunivretraite annee) (connected meanunivfamille annee) (connected meanunivchomage annee)  (connected meanuniv100 annee) if annee!=2016, xtitle("") title(Part de soutien à un système universelle par année et par branche) legend(order(1 "Assurance maladie" 2 "Retraite" 3 "Allocations familiales" 4 "Allocations chômages" 5 "Soutien à un système 100% universel"))


*graph sur le système de l'assurance maladie
tw (connected meanunivAM annee) (connected meancontribam annee) (connected meanminimaAM annee) (connected meanAM annee if annee>2016) if annee!=2016, xtitle("") title(A votre avis l'assurance maladie devrait-elle bénéficier...) legend(order(1 "A tous sans distinction de catégorie sociale et de statut professionnel" 2 "Uniquement à ceux qui cotisent" 3 "Uniquement à ceux qui ne peuvent pas ou n'ont pas les moyens de s'en sortir seuls" 4 "Davantage à ceux qui cotisent, avec un niveau minimal de protection pour les autres") rows(4) cols(1)) yscale(range(0 0.85))


*graph sur le type de système d'allocations chomage
tw (connected meanunivchomage annee) (connected meancontribchomage annee) (connected meanminimachomage annee) (connected meanchom annee if annee>2016) if annee!=2016, xtitle("") title(A votre avis les allocations chômage devraient-elles bénéficier...) legend(order(1 "A tous sans distinction de catégorie sociale et de statut professionnel" 2 "Uniquement à ceux qui cotisent" 3 "Uniquement à ceux qui ne peuvent pas ou n'ont pas les moyens de s'en sortir seuls" 4 "Davantage à ceux qui cotisent, avec un niveau minimal de protection pour les autres") rows(4) cols(1)) ylabel(0 0.2 0.4 0.6 0.8) yscale(range(0 0.85))




********************************************************************************
* II - PS13 longitudinale
********************************************************************************

* Création des variables longitudinales pour les 7 branches 
* (faire tourner les locales avec la boucle)

local lab1 "am"
local lab2 "retr"
local lab3 "fam"
local lab4 "chom"
local lab5 "handi"
local lab6 "dep"
local lab7 "log"
forvalues i=1/7{
	g oui_`lab`i'' = (ps13_a_`i'==1 | ps13_a_`i'==2)
	replace oui_`lab`i''=. if ps13_a_`i'==.
	bys annee: egen mean_oui_`lab`i'' = mean(oui_`lab`i'')
	g non1_`lab`i'' = (ps13_a_`i'==3)
	replace non1_`lab`i''=. if ps13_a_`i'==.
	bys annee: egen mean_non1_`lab`i'' = mean(non1_`lab`i'')
	g non2_`lab`i'' = (ps13_a_`i'==4)
	replace non2_`lab`i''=. if ps13_a_`i'==.
	bys annee: egen mean_non2_`lab`i'' = mean(non2_`lab`i'')
	g nsp_`lab`i'' = (ps13_a_`i'==5 | ps13_a_`i'==6)
	replace nsp_`lab`i''=. if ps13_a_`i'==.
	bys annee: egen mean_nsp_`lab`i'' = mean(nsp_`lab`i'')

}


* Graphiques pour les 7 branches
local lab1 "am"
local lab2 "retr"
local lab3 "fam"
local lab4 "chom"
local lab5 "handi"
local lab6 "dep"
local lab7 "log"
forvalues i=1/7{
tw (connected mean_oui_`lab`i'' annee) (connected mean_non1_`lab`i'' annee) (connected mean_non2_`lab`i'' annee) (connected mean_nsp_`lab`i'' annee), xtitle("") title("Personnellement, compte-tenu de votre niveau de ressources," "êtes-vous prêt à accepter une diminution des prestations" "pour payer moins d’impôts ou moins de cotisations" `lab`i'') legend(order(1 "Oui tout à fait ou oui plutôt" 2 "Non plutôt pas" 3 "Non pas du tout" 4 "NSP ou non concerné") rows(4) cols(1)) name(`lab`i'', replace)
}


* Graphique refus baisse
tw (line mean_non2_am annee) (line mean_non2_retr annee) (line mean_non2_fam annee) (line mean_non2_chom annee) (line mean_non2_handi annee) (line mean_non2_dep annee) (line mean_non2_log annee), name(non2, replace)

* Graphique Accepte baisse
tw (line mean_oui_am annee) (line mean_oui_retr annee) (line mean_oui_fam annee) (line mean_oui_chom annee) (line mean_oui_handi annee) (line mean_oui_dep annee) (line mean_oui_log annee), name(oui, replace)





eststo clear

ologit univretraite i.annee if inrange(ps1_ab_2,1,3)
eststo : margins annee, predict(outcome(1)) post

ologit contribretraite i.annee if inrange(ps1_ab_2,1,3)
eststo : margins annee, predict(outcome(1)) post

ologit non2_retr i.annee if inrange(ps13_a_2,1,4)
eststo : margins annee, predict(outcome(1)) post

ologit oui_retr i.annee if inrange(ps13_a_2,1,4)
eststo : margins annee, predict(outcome(1)) post

coefplot est1 est3 est4, recast(connected) vertical xlabel(1 "2000" 2 "2001" 3 "2002" 4 "2004" 5 "2005" 6 "2006" 7 "2007" 8 "2008" 9 "2009" 10 "2010" 11 "2011" 12 "2012" 13 "2013" 14 "2014" 15 "2015" 16 "2016" 17 "2017" 18 "2018" 19 "2019" 20 "2020", angle(30)) nolabel xline(9.5) legend(order(2 "Favorable à des prestations inclusives" 4 "Totalement opposé à une baisse des prestations retraites" 6 "Favorable à une baisse des prestations retraites") cols(1))



