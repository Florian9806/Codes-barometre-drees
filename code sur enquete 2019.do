cd C:/Users/Utilisateur/Documents/StageLiepp/données

use Baromètre19, clear

* ssc install catplot
*ssc install palettes,  replace
*ssc install colrspace, replace
*ssc install grstyle, replace
*net install grc1leg, from(http://www.stata.com/users/vwiggins)
* ssc install tabplot, replace
********************************************************************************
*modification des labels et des variables
********************************************************************************

label drop ps1_1
label define ps1_1 1 "Ceux qui cotisent" 2 "Pas les moyens" 3 "A tous" 4 "Davantage aux cotisants mais avec minima sociaux" 5 "NSP"
label values ps1_1 ps1_1
label value ps1_2 ps1_1
label value ps1_3 ps1_1
label value ps1_4 ps1_1


gen diplome=1 if sddipl==1 | sddipl==2 | sddipl==3 | sddipl==4 /*inf bac*/
replace diplome=2 if sddipl==4 
replace diplome=3 if sddipl==5 | sddipl==6 /*niveau bac*/
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


* variable ps2 il est souhaitable que les entreprises cotisent + - =
label drop ps2
label define ps2 1 "+ de cotisations patronales" 2 "- de cotisations patronales" 3 "Autant de cotisations" 4 "NSP"
label value ps2 ps2


* recodage label variable sa8 assurance maladie : variable d'intérêt = proposition de réforme de l'assurance maladie

label variable sa8_1 "Augmenter les cotisations"
label variable sa8_2 "Limiter le remboursement pour certaines prestations"
label variable sa8_3 "Réduire la prise en charge des longues maladies"
label variable sa8_5 "Modifier habitudes des médecins pour qu'ils prescrivent moins de médicaments"
label variable sa8_6 "Limiter les tarifs des professionnels de santé"
label variable sa8_7 "Taxer plus les fabricants de médicaments"
label variable sa8_9 "Permettre aux infirmiers ou aux pharmaciens de faire certaines tâches à la place des médecins, comme le renouvellement d’ordonnances"


*recodage de l'age en 4 catégories:
gen agetr=1 if sdage<30
replace agetr=2 if sdage>=30 & sdage<50
replace agetr=3 if sdage>=50 & sdage<65
replace agetr=4 if sdage>=65
label define agetr 1 "[18-29]" 2 "[30-49]" 3 "[50-64]" 4 "[65 +"
label value agetr agetr


*PCS de la PR en 8 catégories
gen pcs8=1 if sdprpcs10==1 | sdprpcs10==2
replace pcs8=sdprpcs10-1 if inrange(sdprpcs10, 3, 8)
replace pcs8=8 if sdprpcs10==10
label define pcs8 1 "Agri, ACCE" 2 "CPIS" 3 "PI" 4 "Employe" 5 "Ouvrier" 6 "Chomeur" 7 "Retraite" 8 "Autre Inactif"
label value pcs8 pcs8

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


********************************************************************************
* Analyse population soutien contributivité
********************************************************************************

gen contrib100=1 if ps1_1==1 & ps1_2==1 & ps1_3==1 & ps1_4==1
replace contrib100=0 if contrib100==.
bys annee: egen meancontrib100 = mean(contrib100)

gen contribAM=(ps1_1==1)
bys annee: egen meancontribam = mean(contribAM)

gen contribretraite=(ps1_2==1)
bys annee: egen meancontribretraite = mean(contribretraite)

gen contribfamille=(ps1_3==1)
bys annee: egen meancontribfamille = mean(contribfamille)

gen contribchomage=(ps1_4==1)
bys annee: egen meancontribchomage = mean(contribchomage)

gen univ100=(ps1_1==3 & ps1_2==3 & ps1_3==3 & ps1_4==3)
bys annee: egen meanuniv100 = mean(univ100)

gen univAM=(ps1_1==3)
bys annee: egen meanunivAM = mean(univAM)

gen univretraite=(ps1_2==3)
bys annee: egen meanunivretraite = mean(univretraite)

gen univfamille=(ps1_3==3)
bys annee: egen meanunivfamille = mean(univfamille)

gen univchomage=(ps1_4==3)
bys annee: egen meanunivchomage = mean(univchomage)

gen minima100=(ps1_1==2 & ps1_2==2 & ps1_3==2 & ps1_4==2)
bys annee: egen meanminima100 = mean(minima100)

gen minimaAM=(ps1_1==2)
bys annee: egen meanminimaAM = mean(minimaAM)

gen minimaretraite=(ps1_2==2)
bys annee: egen meanminimaretraite = mean(minimaretraite)

gen minimafamille=(ps1_3==2)
bys annee: egen meanminimafamille = mean(minimafamille)

gen minimachomage=(ps1_4==2)
bys annee: egen meanminimachomage = mean(minimachomage)

gen AM=(ps1_1==4)
bys annee: egen meanAM = mean(AM)

gen retr=(ps1_1==4)
bys annee: egen meanretr = mean(retr)

gen fam=(ps1_1==4)
bys annee: egen meanfam = mean(fam)

gen chom=(ps1_1==4)
bys annee: egen meanchom = mean(chom)



tw function mean(univ100), over(annee)
grstyle init
grstyle set mesh, compact
*graph soutien à un système contributif
tw (connected meancontribam annee) (connected meancontribretraite annee) (connected meancontribfamille annee) (connected meancontribchomage annee)  (connected meancontrib100 annee) if annee!=2016, xtitle("") title(Part de soutien à un système contributif par année et par branche) legend(order(1 "Assurance maladie" 2 "Retraite" 3 "Allocations familiales" 4 "Allocations chômages" 5 "Soutien à un système 100% contributif"))
*graph à un système universel
tw (connected meanunivAM annee) (connected meanunivretraite annee) (connected meanunivfamille annee) (connected meanunivchomage annee)  (connected meanuniv100 annee) if annee!=2016, xtitle("") title(Part de soutien à un système universelle par année et par branche) legend(order(1 "Assurance maladie" 2 "Retraite" 3 "Allocations familiales" 4 "Allocations chômages" 5 "Soutien à un système 100% universel"))
*graph sur le système de l'assurance maladie
tw (connected meanunivAM annee) (connected meancontribam annee) (connected meanminimaAM annee) (connected meanAM annee if annee>2016) if annee!=2016, xtitle("") title(Type de système soutenu pour l'assurance maladie) legend(order(1 "Système universel" 2 "Système contributif" 3 "Système de minima sociaux" 4 "Système contributif et universel"))
*graph sur le type de système d'allocations chomage
tw (connected meanunivchomage annee) (connected meancontribchomage annee) (connected meanminimachomage annee) (connected meanchom annee if annee>2016) if annee!=2016, xtitle("") title(Type de système soutenu pour l'assurance maladie) legend(order(1 "Système universel" 2 "Système contributif" 3 "Système de minima sociaux" 4 "Système contributif et universel"))






graph dot (mean) contrib100, over(annee, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) by(sdagetr) vertical

*variable de revenu commune à toutes les enquêtes sdrevtr
graph dot (mean) contrib100, over(annee, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) by(sdrevtr) vertical

graph bar (mean) contrib100, over(sdrevtr, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) vertical

graph bar (mean) contrib100, over(sdpcs10, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) vertical
* les ouvriers sont légèrement plus favorable que les autres pcs salariés à une contributivité 100%

graph dot (mean) contrib100, over(ps2, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) vertical

/* - Evolution du taux de soutien à un système complètement contributif */


graph dot (mean) contribAM (mean) contribretraite (mean) contribfamille ///
	(mean) contribchomage (mean) contrib100 if annee!=2016, ///
	over(annee, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) ///
	vertical title(Proportion du soutien à la contributivité du système) ///
	legend(order(1 "Assurance maladie" 2 "Système de retraite" 3 "Allocation familiale" 4 "Allocation chômage ")
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\PROcontributivitélongitudinale.png", as(png) name("Graph") replace

/* - Evolution du taux de soutien à un système complètement universel */


graph dot (mean) univAM (mean) univretraite (mean) univfamille (mean) ///
	univchomage (mean) univ100 if annee!=2016, ///
	over(annee, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) ///
	vertical title(Proportion du soutien à l'universalité du système) ///
	legend(order(1 "Assurance maladie" 2 "Système de retraite" 3 "Allocation familiale" 4 "Allocation chômage ")

graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\PROuniversalitélongitudinale.png", as(png) name("Graph")

/*Taux de soutien à un système de minima sociaux uniquement*/


/* système mixte, contributif avec minima, réponse proposée uniquement depuis 2016*/


graph dot (mean) univAM (mean) minimaAM (mean) contribAM (mean) AM if annee!=2016, ///
	over(annee, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) ///
	vertical title(Type de système d'assurance maladie soutenu) ///
	legend(order(1 "Système universelle" 2 "Système de minima sociaux" 3 "Système contributif" 4 "Système mixte ")
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\AMlongitudinale.png", as(png) name("Graph")

graph dot (mean) univchomage (mean) minimachomage (mean) contribchomage ///
	(mean) chom if annee!=2016, ///
	over(annee, label(labcolor("black") labsize(vsmall) angle(forty_five) ) ) ///
	vertical title(Type de système d'assurance chomage soutenu) ///
	legend(order(1 "Système universelle" 2 "Système de minima sociaux" 3 "Système contributif" 4 "Système mixte ")
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\Chomagelongitudinale.png", as(png) name("Graph")


****************************************************************************
* Analyse soutient à la protection sociale (qui soutient et quel niveau de soutien)
****************************************************************************

* variable de soutient : ps2 et ps13_1/2/3/4 (il ya aussi 5 à 7 sur des éléments plus éloigné de la protection sociale traditionnelle)


****************************************************************************
* Analyse soutient à l'assurance maladie
****************************************************************************


gen cotisAM=1 if sa8_1==1 & annee>=2005 /*soutient à une augmentation des cotisations sociales*/
replace cotisAM=0 if sa8_1!=1 & annee>=2005
gen baisseAM=1 if sa8_2==1 & annee>=2005 /*soutient à une baisse des prestations*/
replace baisseAM=0 if sa8_2!=1 & annee>=2005
gen baisseAM2=1 if sa8_3==1 & annee>=2005 /*soutient à une baisse des prestations pour les maladies longues */
replace baisseAM2=0 if sa8_3!=1 & annee>=2005

* soutien à 3 types de réformes face au déficit, longitudinale
graph dot (mean) cotisAM (mean) baisseAM (mean) baisseAM2 if annee>=2005, ///
	over(annee, label(labcolor("black") labsize(vsmall) angle(forty_five) )) ///
	legend(order(1 "Favorable à une augmentation des cotisations sociales" 2 "Favorable à une baisse de prise en charge de certaines maladies" 3 "Favorable à une baisse de prise en charge de maladies longues") col(1) size(small)) ///
	vertical title("Différentes mesures pour réduire le déficit de la branche maladie", size(medium)) 
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\reformeAM1.png", as(png) name("Graph")

	
* par catégories socdem

* quintile de niveau de vie
graph bar (mean) cotisAM (mean) baisseAM (mean) baisseAM2 , over(sdnivie) ///
	legend(order(1 "Favorable à une augmentation des cotisations sociales" 2 "Favorable à une baisse de prise en charge de certaines maladies" 3 "Favorable à une baisse de prise en charge de maladies longues") col(1) size(small))
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\reformeAM2.png", as(png) name("Graph")

* PCS en 10 catégories
graph bar (mean) cotisAM (mean) baisseAM (mean) baisseAM2 , ///
	over(sdpcs10 , label(labcolor("black") labsize(vsmall) angle(forty_five) )) ///
	legend(order(1 "Favorable à une augmentation des cotisations sociales" 2 "Favorable à une baisse de prise en charge de certaines maladies" 3 "Favorable à une baisse de prise en charge de maladies longues") col(1) size(small))
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\reformeAM3.png", as(png) name("Graph")

* Siutation d'activité
graph bar (mean) cotisAM (mean) baisseAM (mean) baisseAM2 , ///
	over(situa , label(labcolor("black") labsize(vsmall) angle(forty_five) )) ///
	legend(order(1 "Favorable à une augmentation des cotisations sociales" 2 "Favorable à une baisse de prise en charge de certaines maladies" 3 "Favorable à une baisse de prise en charge de maladies longues") col(1) size(small))
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\reformeAM4.png", as(png) name("Graph")

* Diplome
graph bar (mean) cotisAM (mean) baisseAM (mean) baisseAM2 , ///
	over(diplome , label(labcolor("black") labsize(vsmall) angle(forty_five) )) ///
	legend(order(1 "Favorable à une augmentation des cotisations sociales" 2 "Favorable à une baisse de prise en charge de certaines maladies" 3 "Favorable à une baisse de prise en charge de maladies longues") col(1) size(small))
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\reformeAM5.png", as(png) name("Graph")

*Age
graph bar (mean) cotisAM (mean) baisseAM (mean) baisseAM2 , ///
	over(sdagetr , label(labcolor("black") labsize(vsmall) angle(forty_five) )) ///
	legend(order(1 "Favorable à une augmentation des cotisations sociales" 2 "Favorable à une baisse de prise en charge de certaines maladies" 3 "Favorable à une baisse de prise en charge de maladies longues") col(1) size(small))
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\reformeAM6.png", as(png) name("Graph")


****************************************************************************
* Analyse cohérence des opinions et niveaux de connaissance 
* en matière de prélèvement et de prestations
****************************************************************************





********************************************************************************
*Analyse du soutien à l'assurance chomage en fonction des risque de chomage
********************************************************************************
graph dot (mean) cotisAM (mean) baisseAM (mean) baisseAM2 if annee>=2005, ///
	over(annee, label(labcolor("black") labsize(vsmall) angle(forty_five) )) ///
	legend(order(1 "Favorable à une augmentation des cotisations sociales" 2 "Favorable à une baisse de prise en charge de certaines maladies" 3 "Favorable à une baisse de prise en charge de maladies longues") col(1) size(small)) ///
	vertical title("Différentes mesures pour réduire le déficit de la branche maladie", size(medium)) 
graph export "C:\Users\Utilisateur\Documents\StageLiepp\résultats\reformeAM1.png", as(png) name("Graph")




********************************************************************************
*ACM sur factominer: I - Variable sociodem en principale
********************************************************************************




mac def varprincipale "st.var(agetr), st.var(pcs8), st.var(diplome), st.var(sitfam), st.var(sdnivie), st.var(habitat), st.var(sdsexe)"
mac def varsup "st.var(og4_6), st.var(og4_8), st.var(og5_4), st.var(pe3), st.var(pe9), st.var(pe10), st.var(ps1_1), st.var(ps1_2), st.var(ps1_3), st.var(ps1_4), st.var(ps13_1, st.var(ps13_2), st.var(ps13_3), st.var(ps13_4), st.var(ps15_1), st.var(ps15_2), st.var(ps15_3), st.var(ps2), st.var(ps3), st.var(ps11), st.var(ps12), st.var(ps8), st.var(ps16), st.var(ps18), st.var(sa8_1), st.var(sa8_2), st.var(sa8_3), st.var(sdrichom)"
* mac def varsupquanti
* manque des variables partie retraite (pas encore traité et questions pas évidente à traiter) allocation familiale (pas dans la bdd 2018) et une partie sur la santé (accès au soin etc on s'éloigne un peu du sujet)



R: acm_essai = data.frame(c($varprincipale, $varsup)) /*peut prend bcp de temps*/
R: head(acm_essai) 
R: acm_essai <- as.data.frame(acm_essai)

*R: acm_essai\$diplome <- as.factor(acm_essai\$diplome) ; acm_essai\$sitfam <- as.factor(acm_essai\$sitfam ) ; acm_essai\$situa <- as.factor(acm_essai\$situa )

R: acm_res1 <- MCA(acm_essai, quali.sup=8:36 graph=T)
R: summary(acm_res1)

rcall : png("Rplot.png") ; ///
	barplot(acm_res1\$eig[,2],main="Pourcentage d'inertie", names.arg=1:nrow(acm_res1\$eig))

R : png("advancedgraph.png"); ///
	library(factoextra) ; ///
	fviz_mca_ind(acm_res1, col.ind="contrib")
R : png("advancedgraph2.png"); ///
	library(factoextra) ; ///
	fviz_mca_var(acm_res1, col.var="contrib")
* on peut remplacer contrib par cos2 pour la qualité de la représentation


/* Graphique code: boucle pour sortir série de graph soc-dem */

global sociodem1 "sdagetr sitfam  pcs8 diplome sdnivie"

colorpalette viridis, select(3 8 13) nograph

grstyle init
grstyle set mesh, compact
grstyle set color "70 50 127" "33 144 140" "159 218 58" , ipolate(5) 

foreach i in $sociodem1 {
    catplot ps1_1 if annee>=2016, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Assurance maladie par `i' ") vertical stack name(G1, replace) nodraw

	catplot ps1_2 if annee>=2016, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Système de retraite par `i' ") vertical stack name(G2, replace) nodraw

	catplot ps1_3 if annee>=2016, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Allocation familiale par `i' ") vertical stack name(G3, replace) nodraw

	catplot ps1_4 if annee>=2016, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Allocation chomage par `i'") vertical stack name(G4, replace) nodraw

	grc1leg G1 G2 G3 G4, legendfrom(G1) title(Type de système par prestation et par `i') iscale(0.7)
	graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/ps1_`i'.png", replace
    
}


foreach i in $sociodem1 {
    catplot ps13_1 if annee, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Assurance maladie par `i' ") vertical stack name(G1, replace) nodraw

	catplot ps13_2 if annee, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Système de retraite par `i' ") vertical stack name(G2, replace) nodraw

	catplot ps13_3 if annee, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Allocation familiale par `i' ") vertical stack name(G3, replace) nodraw

	catplot ps13_4 if annee, over(`i', label(labsize(vsmall) labcolor(black))) percent(`i') asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Allocation chomage par `i'") vertical stack name(G4, replace) nodraw

	grc1leg G1 G2 G3 G4, legendfrom(G1) title(Soutien à une baisse des prestations et des cotisations) iscale(0.7)
	graph export "C:/Users/Utilisateur/Documents/StageLiepp/résultats/ps13_`i'.png", replace
    
}




/*
catplot ps1_1 if annee>=2016, over(pcs8, label(labsize(vsmall) labcolor(black))) percent(pcs8) asyvars legend(pos(1) color(gs5)) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Assurance maladie par PCS de la PR") vertical stack name(G1, replace)

catplot ps1_2 if annee>=2016, over(pcs8, label(labsize(vsmall) labcolor(black))) percent(pcs8) asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Système de retraite par PCS de la PR") vertical stack name(G2, replace)

catplot ps1_3 if annee>=2016, over(pcs8, label(labsize(vsmall) labcolor(black))) percent(pcs8) asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Allocation familiale par PCS de la PR") vertical stack name(G3, replace)

catplot ps1_4 if annee>=2016, over(pcs8, label(labsize(vsmall) labcolor(black))) percent(pcs8) asyvars legend(off) blabel(bar, position(center) format(%3.1f) color(white) size(vsmall)) b1title("Allocation chomage par PCS de la PR") vertical stack name(G4, replace)

grc1leg G1 G2 G3 G4, legendfrom(G1)
*/






