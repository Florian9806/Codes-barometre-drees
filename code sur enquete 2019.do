cd C:/Users/Utilisateur/Documents/StageLiepp/données

use Baromètre19

********************************************************************************
*modification des label et des variables
********************************************************************************

label drop ps1_1
label define ps1_1 1 "Ceux qui cotisent" 2 "Pas les moyens" 3 "A tous" 4 "Davantage aux cotisants mais avec minima sociaux" 5 "NSP"
label values ps1_1 ps1_1
label value ps1_2 ps1_1
label value ps1_3 ps1_1
label value ps1_4 ps1_1


gen diplome=1 if sddipl==1 | sddipl==2 | sddipl==3 | sddipl==4 /*inf bac*/
replace diplome=2 if sddipl==4 
replace diplome =3 if sddipl==5 | sddipl==6 /*niveau bac*/
replace diplome=4 if sddipl==7 /*bac+1 2*/
replace diplome=5 if sddipl==8 /* bac +3 ou plus */
label define diplome 1 "inférieur au bac" 2 "CAP BEP" 3 "bac pro ou général" 4 "Bac+1ou2" 5 "bac+3 ou plus"
label value diplome diplome


/* Modification a faire avant l'ACM: neutraliser les catégories trop petites, pour cela, suppression de la catégorie NSP pour variables PS1 et mixer la catégorie "nsp" et "non concerné" pour les variables PS13 */

forvalues i = 1/4 {
	replace ps1_`i'=. if ps1_`i'==5 
	replace ps13_`i'=5 if ps13_`i'==6
}

* codage de la situation familiale en séparant couple avec et sans enfant et en retirant les catégories marginales

gen sitfam=1 if sdsitfam==1
replace sitfam=2 if sdsitfam==2 & sdnbenf==1 /*couple sans enfant*/
replace sitfam=3 if sdsitfam==2 & sdnbenf>1 /*couple avec enfant*/
replace sitfam=4 if sdsitfam==3 /*parent monoparental*/
replace sitfam=5 if sdsitfam==4 /*enfant du foyer*/
label define sitfam 1 "Seul" 2 "Couple sans enfant" 3 "Couple avec enfant" 4 " Parent seul" 5 "Enfant du foyer"
label value sitfam sitfam
ta sdsitfam sitfam if annee==2019, missing /*vérif du code de la var sitfam*/


/*recodage de la situation d'activité de l'individu*/
gen situa=1 if sdsitua ==1
replace situa=2 if inrange(sdsitua, 2, 3) /*temps partiel*/
replace situa=3 if sdsitua==4 /*chomage*/
replace situa=4 if sdsitua==5 /*étudiant*/
replace situa=5 if sdsitua==6 /*retraité*/
replace situa=6 if sdsitua==7 /*autre inactif*/
*si pb de taille de catégorie mettre étudiant dans autre inactif.
label define situa 1 "Temps plein" 2 "Temps partiel, intermittent.e" 3 "Chomeur.euse" 4 "Etudiant.e" 5 "Retraité.e" 6 "Autre inactif.ve"
label value situa situa

/*recodage de la situation d'activité de la personne de réf du ménage, étudiant trop peu nombreux mis dans autre inactif*/
gen prsitua=1 if sdprsitua ==1
replace prsitua=2 if inrange(sdprsitua, 2, 3) /*temps partiel*/
replace prsitua=3 if sdprsitua==4 /*chomage*/
replace prsitua=4 if sdprsitua==6 /*retraité*/
replace prsitua=5 if sdprsitua==7 | sdprsitua==5 /*autre inactif*/
label define prsitua 1 "Temps plein" 2 "Temps partiel, intermittent.e" 3 "Chomeur.euse" 4 "Retraité.e" 5 "Autre inactif.ve"
label value prsitua prsitua


********************************************************************************
* Tabulation du bloc protection sociale (PS)
********************************************************************************

*ta ps1_1 ps13_1 if annee==2019, row col nofreq
ta ps1_1 ps13_1 if annee==2019, row cchi2 nofreq chi2

*ta ps1_2 ps13_2 if annee==2019, row col nofreq
ta ps1_2 ps13_2 if annee==2019, row cchi2 nofreq chi2

*ta ps1_3 ps13_3 if annee==2019, row col nofreq
ta ps1_3 ps13_3 if annee==2019, row cchi2 nofreq chi2

*ta ps1_4 ps13_4 if annee==2019, row col nofreq
ta ps1_4 ps13_4 if annee==2019, row cchi2 nofreq chi2





********************************************************************************
* ACM du bloc PS avec variable sociodem en supplémentaire
********************************************************************************

mca ps1_1 ps1_2 ps1_3 ps1_4 ps13_1 ps13_2 ps13_3 ps13_4 if annee==2019, supplementary(sdpcs10 sdprpcs10 diplome sdnivie sdagetr sitfam habitat) dim(5) report(all) plot

* Projection des questions sur l'allocation chômage sur les 3 premières dimensions
mcaprojection ps1_4 ps13_4, normalize(standard) alternate maxlength(10) legend(off) dim(1/3)

* projection du quintile de niveau de vie et PCS sur les 2 premières dimensions
mcaprojection sdnivie sdprpcs10, normalize(standard) alternate maxlength(10) legend(off) dim(1/2)

mcaprojection diplome sdagetr, normalize(standard) alternate maxlength(10) legend(off) dim(1/3)

mcaprojection habitat sitfam, normalize(standard) alternate maxlength(10) legend(off) dim(1/3)




********************************************************************************
* ACM des variables socdem en active et bloc PS en passive
********************************************************************************

* pour diminuer l'effet de l'âge retirer sitfam?
mca diplome sdnivie sdagetr sitfam habitat if annee==2019, supplementary(ps1_1 ps1_2 ps1_3 ps1_4 ps13_1 ps13_2 ps13_3 ps13_4 sdprpcs10) dim(5) report(all) plot

* Projection des questions sur l'allocation chômage sur les 3 premières dimensions
mcaprojection ps1_4 ps13_4, normalize(standard) alternate maxlength(10) legend(off) dim(1/3)

* projection du quintile de niveau de vie et PCS sur les 2 premières dimensions
mcaprojection sdnivie sdprpcs10, normalize(standard) alternate maxlength(10) legend(off) dim(1/2)

mcaprojection diplome sdagetr, normalize(standard) alternate maxlength(10) legend(off) dim(1/3)

mcaprojection habitat sitfam, normalize(standard) alternate maxlength(10) legend(off) dim(1/3)

*ajouter overlay pour avoir les variables dans un seul graphique 
mcaplot sdprpcs10 diplome sdnivie sdagetr sitfam habitat, origin maxlength(10) normalize(principal) legend(off)

mcaprojection ps1_1 ps1_2 ps1_3 ps1_4, normalize(standard) alternate maxlength(10) legend(off) dim(1/3)

mcaprojection ps13_1 ps13_2 ps13_3 ps13_4, normalize(standard) alternate maxlength(10) legend(off) dim(1/2)

mcaplot ps1_1 ps1_2 ps1_3 ps1_4 , maxlength(10) normalize(principal) legend(off)
*représentation pas terrible




