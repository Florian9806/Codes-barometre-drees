cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020.do"


**************************************************************************
* PS1 longitudinale
**************************************************************************


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
