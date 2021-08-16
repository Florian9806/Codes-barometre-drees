cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "6_0_ACM_codage_variables"



*******************************************************************************
* ACM pseudo panel comparaison entre questionnaire (question ps13 en supplémentaires)
*******************************************************************************
* chômage
* ps13A
mca ps1ab4 ps2_ab ps16_ab ps3_ab if sdsplit==1, sup(y_Chomage_3)
mcaplot, overlay name(G1, replace) title(Questionnaire A) msize(vsmall) mlabsize(vsmall) origin
* ps13B
mca ps1ab4 ps2_ab ps16_ab ps3_ab if sdsplit==2, sup(y_Chomage_3)
mcaplot, overlay name(G2, replace) title(Questionnaire B)  msize(vsmall) mlabsize(vsmall) origin

*ps13C
mca ps1cd4 ps2_cd ps16_cd ps3_cd if sdsplit==3, sup(y_Chomage_3)
mcaplot, overlay name(G3, replace) title(Questionnaire C)  msize(vsmall) mlabsize(vsmall) origin

*ps13D
mca ps1cd4 ps2_cd ps16_cd ps3_cd if sdsplit==4, sup(y_Chomage_3)
mcaplot, overlay name(G4, replace) title(Questionnaire D)  msize(vsmall) mlabsize(vsmall) origin


********
* AvB assurance maladie (moins de variables)
********

mca ps1_ab_1 ps2_ab ps16_ab if sdsplit==1 & ps1_ab_1!=5, sup(y_AM_3 PCS)
mcaplot, overlay name(G1, replace) title(Questionnaire A)

mca ps1_ab_1 ps2_ab ps16_ab if sdsplit==2 & ps1_ab_1!=5, sup(y_AM_3 PCS)
mcaplot, overlay name(G2, replace) title(Questionnaire B)

grc1leg G1 G2, legendfrom(G1)


* AvB retraite

mca ps16_ab ps1_ab_2 ps2_ab if sdsplit==1 & ps1_ab_2!=5, sup(y_Retraite_3 PCS)
mcaplot, overlay name(G1, replace) title(Questionnaire A)

mca ps16_ab ps1_ab_2 ps2_ab if sdsplit==2 & ps1_ab_2!=5, sup(y_Retraite_3 PCS)
mcaplot, overlay name(G2, replace) title(Questionnaire B)

grc1leg G1 G2, legendfrom(G1)


* cd vs ab question ps1 chomage, ps2 et ps16 
* (cd= ajout de "dans le contexte de la crise du covid", ab =formulation normale)

mca ps1_ab_4 ps2_ab ps16_ab if annee==2020 , sup(PCS)
mcaplot, overlay name(G1, replace) title(Questionnaire A et B) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))

mca ps1_cd_4 ps2_cd ps16_cd if annee==2020 , sup(PCS)
mcaplot, overlay name(G2, replace) title(Questionnaire C et D) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))



**************************************
* Avec var socio-demo en supplémentaires
*************************************

* questionnaire ab
mca ps1ab4 ps2_ab ps16_ab if annee==2020, sup(diplome3 sdnivie sdagetr)
mcaplot, overlay name(G1, replace) title(Questionnaire A et B) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
predict ab1 ab2 if e(sample) /*sert à ne prédire que sur l'échantillon ou l'ACM est effectuée*/
scatter ab2 ab1

* questionnaire cd
mca ps1cd4 ps2_cd ps16_cd if annee==2020, sup(diplome3 sdnivie sdagetr)
mcaplot, overlay name(G2, replace) title(Questionnaire C et D) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
predict cd1 cd2 if e(sample)
scatter cd2 cd1


mca ps1ab4 ps2_ab ps16_ab if annee==2019, sup(diplome3 sdnivie sdagetr)
mcaplot, overlay name(G3, replace) title(Questionnaire A et B) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
predict ab19_1 ab19_2 if e(sample)
scatter ab19_2 ab19_1

tw (scatter ab2 ab1, mstyle(p1)) (scatter cd2 cd1, mstyle(p2)) (scatter ab19_2 ab19_1, mstyle(p3)), legend(order(1 "QAB 2020" 2 "QCD 2020" 3 "QAB2019"))
* compare la répartition des points en fonction de l'année ou de la version de l'enquête en 2020 (pas très clair)

* 2019 - 2020 (stabilise la représentation)
mca ps1ab4 ps2_ab ps16_ab if annee==2019 | annee==2020, sup(diplome3 sdnivie sdagetr)
mcaplot, overlay name(G3, replace) title(Questionnaire A et B 2019 2020) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
predict ab1920_1 ab1920_2 if e(sample)
scatter ab1920_2 ab1920_1
tw (scatter ab1920_2 ab1920_1 ) (lfit ab1920_2 ab1920_1) (qfit ab1920_2 ab1920_1)
tw (histogram ab1920_1 if annee==2019, lcol(pink)) (histogram ab1920_1 if annee==2020, lcol(blue)), legend(order(1 "2019 " 2 "2020"))
tw (histogram ab1920_2 if annee==2019, lcol(pink)) (histogram ab1920_2 if annee==2020, lcol(blue)), legend(order(1 "2019 " 2 "2020"))
* représentation par pcs; peut intéressant, répartition des points pas évidente à exploiter sous cette forme 
* (les régressions donnent des résultats plus intéressants)

tw (kdensity ab1920_1 if PCS==1, lcol(pink)) (kdensity ab1920_1 if PCS==2, lcol(blue)) (kdensity ab1920_1 if PCS==3, lcol(green)) (kdensity ab1920_1 if PCS==4, lcol(orange)) (kdensity ab1920_1 if PCS==5, lcol(black)), legend(order(1 "Indep " 2 "Cadre" 3 "Ouvrier/employé" 4 "Autre inactif" 5 "Retraité"))
tw (kdensity ab1920_2 if PCS==1, lcol(pink)) (kdensity ab1920_2 if PCS==2, lcol(blue)) (kdensity ab1920_2 if PCS==3, lcol(green)) (kdensity ab1920_2 if PCS==4, lcol(orange)) (kdensity ab1920_2 if PCS==5, lcol(black)), legend(order(1 "Indep " 2 "Cadre" 3 "Ouvrier/employé" 4 "Autre inactif" 5 "Retraité"))

tw (histogram ab1920_1 if annee==2020 & sdsplit==1, lcol(pink)) (histogram ab1920_1 if annee==2020 & sdsplit==2, lcol(blue)), legend(order(1 "A " 2 "B"))




mca ps1ab4 ps2_ab ps16_ab if annee==2020, sup(diplome3 sdnivie sdagetr y_Chomage_3)
mcaplot, overlay name(G3, replace) title(Questionnaire A et B 2020) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
predict dimchom1 dimchom2 if annee==2020 & (sdsplit==1|sdsplit==2)

mca ps15_ab_1 ps16_ab ps2_ab ps1ab4 if annee==2020, sup(ps15_ab_3)
mcaplot, overlay mlabgap(1) mlabpos(6) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3)) yneg
predict G H if e(sample)
tw (scatter H G if ps1ab4==1, msize(vsmall) m(square)) (scatter H G if ps1ab4==2, msize(vsmall) m(triangle)) (scatter H G if ps1ab4==3, msize(small) m(+))(lfit H G) (qfit H G)
tw (scatter H G if ps2_ab==1, msize(vsmall) m(square)) (scatter H G if ps2_ab==2, msize(vsmall) m(triangle)) (scatter H G if ps2_ab==3, msize(small) m(+))(lfit H G) (qfit H G)
tw (histogram H, vertical) (histogram G, horizontal)





*********
* ajout de la variable ps15_ab_1 (opinion sur le système social français)
*********
mca ps15_ab_1 ps16_ab ps2_ab ps1ab4 ps3_ab if annee==2020, sup(PCS)
mcaplot, overlay mlabgap(1) mlabpos(6) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))

mca ps15_ab_1 ps16_ab ps2_ab ps1ab4 ps3_ab if annee==2020, sup(PS13A4 PS13B4)
mcaplot, overlay mlabgap(1) mlabpos(6) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))




* opinion sur le chômage (limitation de la durée du chômage et des droits des chômeurs)
* pb: peu de profondeur temporelle
mca pe14_1 pe14_2 pe14_3 pe14_4 pe13_ab
mcaplot, overlay mlabgap(1) mlabpos(6) msize(vsmall) mlabsize(vsmall) origin legend(size(small) position(3))
predict chom1
bysort annee : egen CHOM =mean(chom1)
bysort annee PCS : egen CHOM_pcs = mean(chom1)
tw (line CHOM_pcs annee if PCS==1) (line CHOM_pcs annee if PCS==2) (line CHOM_pcs annee if PCS==3) (line CHOM_pcs annee if PCS==4) (line CHOM_pcs annee if PCS==5), legend(order(1 "agri ACCE" 2 "Cadre et PI" 3 "Ouvrier employé" 4 "autre Hors emploi" 5 "Retraité"))
bysort annee pcs8 : egen CHOM_pcs8 = mean(chom1)
tw (line CHOM_pcs8 annee if pcs8==1) (line CHOM_pcs8 annee if pcs8==2) (line CHOM_pcs8 annee if pcs8==3) (line CHOM_pcs8 annee if pcs8==4) (line CHOM_pcs8 annee if pcs8==5) (line CHOM_pcs8 annee if pcs8==6) (line CHOM_pcs8 annee if pcs8==7) (line CHOM_pcs8 annee if pcs8==8), legend(order(1 "agri ACCE" 2 "CPIS" 3 "PI" 4 "Employé" 5 "Ouvrier" 6 "Chomeur" 7 "Retraité" 8 "Autre inactif"))
bysort annee sdpoltr : egen CHOM_pol = mean(chom1)
tw (line CHOM_pol annee if sdpoltr==1) (line CHOM_pol annee if sdpoltr==2) (line CHOM_pol annee if sdpoltr==3) (line CHOM_pol annee if sdpoltr==4) (line CHOM_pol annee if sdpoltr==5), legend(order(1 "Extreme gauche" 2 "gauche" 3 "centre" 4 "Droite" 5 "Extreme droite"))
bysort annee diplome4 : egen CHOM_dipl = mean(chom1)
tw (line CHOM_dipl annee if diplome4==1) (line CHOM_dipl annee if diplome4==2) (line CHOM_dipl annee if diplome4==3) (line CHOM_dipl annee if diplome4==4), legend(order(1 "inf au bac" 2 "CAP BEP" 3 "Bac" 4 "Sup bac"))
* résultats difficile à lire. bcp de variations temporelles. + besoin d'être + parcimonieux






*******************************************************************************
* Analyse des correspondances ps13/ps1
*******************************************************************************

ca ps13_a_1 ps1_ab_1
cabiplot, origin  rowopts(msymbol(o) mcolor(green) mlabcolor(green) mlabsize(vsmall) mlabpos(12) mlabangle(20)) colopts(msymbol(triangle) mcolor(red) mlabcolor(red) mlabsize(vsmall) mlabpos(6) mlabangle(10)) title(Analyse des correspondances Assurance maladie) legend(order(1 "Accepte une baisse des prestations" 2 "Type de système souhaité"))
ca ps13_a_2 ps1_ab_2
cabiplot, origin  rowopts(msymbol(o) mcolor(green) mlabcolor(green) mlabsize(vsmall) mlabpos(12) mlabangle(20)) colopts(msymbol(triangle) mcolor(red) mlabcolor(red) mlabsize(vsmall) mlabpos(6) mlabangle(10)) title(Analyse des correspondances Retraite) legend(order(1 "Accepte une baisse des prestations" 2 "Type de système souhaité"))
ca ps13_a_3 ps1_ab_3
cabiplot, origin  rowopts(msymbol(o) mcolor(green) mlabcolor(green) mlabsize(vsmall) mlabpos(12) mlabangle(20)) colopts(msymbol(triangle) mcolor(red) mlabcolor(red) mlabsize(vsmall) mlabpos(6) mlabangle(10)) title(Analyse des correspondances allocations familiales) legend(order(1 "Accepte une baisse des prestations" 2 "Type de système souhaité"))
ca ps13_a_4 ps1_ab_4
cabiplot, origin  rowopts(msymbol(o) mcolor(green) mlabcolor(green) mlabsize(vsmall) mlabpos(12) mlabangle(20)) colopts(msymbol(triangle) mcolor(red) mlabcolor(red) mlabsize(vsmall) mlabpos(6) mlabangle(10)) title(Analyse des correspondances allocations chômage) legend(order(1 "Accepte une baisse des prestations" 2 "Type de système souhaité"))







********************************************************************************
* Analyse des correspondances ps13/ps1 longitudinale 
*(on utilise la commande mca sur 2 variables ce qui revient au même que la commande CA mais permet d'ajouter des variables supplémentaires)
* predict par branche (coordonnées sur les dimensions 1 et 2 des ac)
********************************************************************************
/* Bien regarder les résultats des CA avant de faire des régressions, les résultats sont moins facilement exploitable qu'auparavant du fait de la modification de catégorie en 2017. la catégorie mixte (intermédiaire) n'étant plus présente les données sont représentées très différement. Question: retirer les NSP questions 13 AM (très faible)?*/

mca ps13_a_4 PS1_4, sup(annee pcs8) normalize(principal)
mcaplot, overlay origin mlabsize(small)
predict chomdim1 chomdim2 if e(sample)

mca ps13_a_1 PS1_1, sup(annee pcs8) normalize(principal)
mcaplot, overlay origin mlabsize(small)
predict AMdim1 AMdim2 if e(sample)

mca ps13_a_2 PS1_2, sup(annee pcs8) normalize(principal)
mcaplot, overlay origin mlabsize(small)
predict retraitedim1 retraitedim2 if e(sample)

mca ps13_a_3 PS1_3, sup(annee) normalize(principal)
mcaplot, overlay origin mlabsize(small)
predict famdim1 famdim2 if e(sample)


* créations des variables de pondérations pour le graphiques suivant
bys famdim1 : egen famdimpoid = count(famdim1) if famdim1!=.
bys chomdim1 : egen chomdimpoid = count(chomdim1) if chomdim1!=.
bys AMdim1 : egen AMdimpoid = count(AMdim1) if AMdim1!=.
bys retraitedim1 : egen retraitedimpoid = count(retraitedim1) if retraitedim1!=.
* projections des individus sur les deux premières dimensions des ac des branches pondéré par leur poid
tw (scatter famdim2 famdim1 [w=famdimpoid], mfcolor(none) mcol(blue))  (scatter chomdim2 chomdim1 [w=chomdimpoid], mfcolor(none) mcol(red))  (scatter AMdim2 AMdim1 [w=AMdimpoid], mfcolor(none) mcol(green))  (scatter retraitedim2 retraitedim1 [w=retraitedimpoid], mfcolor(none) mcol(black)), xline(0) yline(0) legend(order(1 "Famille" 2 "Chômage" 3 "Assurance maladie" 4 "Retraite"))


* reg socio démo
eststo clear
eststo : reg AMdim1 i.diplome i.sdstat i.sdagetr i.sdsexe
eststo : reg retraitedim1 i.diplome i.sdstat i.sdagetr i.sdsexe
eststo : reg famdim1 i.diplome i.sdstat i.sdagetr i.sdsexe
eststo : reg chomdim1 i.diplome i.sdstat i.sdagetr i.sdsexe
esttab, star(* 0.1 ** 0.05 *** 0.01) p
coefplot est1 est2 est3 est4, keep(*diplome *sdstat *sdsexe *sdagetr) xline(0)



********************************************
* regression sur choc csg 2018 (essai)
*********************************************
g traitement_csg=(annee>=2018)
g trait_plaffam=(sdrevtr==7 | sdrevtr==6 & n2_enfants==1) /* pas exploité*/


* dim1 par branche. sdres= origine de revenus du foyer
*(attention variable codé en 1 et 2 donc spécifié en catégorielle dans les régressions)
eststo clear

eststo : reg AMdim1 i.diplome i.sdagetr i.habitat  i.sdsexe ///
	ib2.sdres_2 ib2.sdres_3 ib2.sdres_4 ib2.sdres_7 ib2.sdres_5 ib2.sdres_6 ///
	ib2.sdres_2#i.traitement_csg ib2.sdres_3#i.traitement_csg ib2.sdres_4#i.traitement_csg ///
	ib2.sdres_7#i.traitement_csg ib2.sdres_5#i.traitement_csg ib2.sdres_6#i.traitement_csg i.traitement_csg

eststo : reg retraitedim1 i.diplome i.sdagetr i.habitat  i.sdsexe ///
	ib2.sdres_2 ib2.sdres_3 ib2.sdres_4 ib2.sdres_7 ib2.sdres_5 ib2.sdres_6 ///
	ib2.sdres_2#i.traitement_csg ib2.sdres_3#i.traitement_csg ib2.sdres_4#i.traitement_csg ///
	ib2.sdres_7#i.traitement_csg ib2.sdres_5#i.traitement_csg ib2.sdres_6#i.traitement_csg i.traitement_csg

eststo : reg famdim1 i.diplome i.sdagetr i.habitat  i.sdsexe ///
	ib2.sdres_2 ib2.sdres_3 ib2.sdres_4 ib2.sdres_7 ib2.sdres_5 ib2.sdres_6 ///
	ib2.sdres_2#i.traitement_csg ib2.sdres_3#i.traitement_csg ib2.sdres_4#i.traitement_csg ///
	ib2.sdres_7#i.traitement_csg ib2.sdres_5#i.traitement_csg ib2.sdres_6#i.traitement_csg i.traitement_csg

eststo : reg chomdim1 i.diplome i.sdagetr i.habitat  i.sdsexe ///
	ib2.sdres_2 ib2.sdres_3 ib2.sdres_4 ib2.sdres_7 ib2.sdres_5 ib2.sdres_6 ///
	ib2.sdres_2#i.traitement_csg ib2.sdres_3#i.traitement_csg ib2.sdres_4#i.traitement_csg ///
	ib2.sdres_7#i.traitement_csg ib2.sdres_5#i.traitement_csg ib2.sdres_6#i.traitement_csg i.traitement_csg
	
esttab, star(* 0.1 ** 0.05 *** 0.01) p

coefplot est1 est2 est3 est4, keep(*sdres*) xline(0)
coefplot est1 est2 est3 est4, keep(*diplome *habitat *sexe *sdagetr) xline(0)

* la même chose mais sur la deuxième dimension
eststo clear
eststo : reg AMdim2 i.diplome i.sdsexe i.sdagetr i.habitat i.traitement_csg ///
	ib2.sdres_2 ib2.sdres_3 ib2.sdres_4 ib2.sdres_7 ib2.sdres_5 ib2.sdres_6 ///
	ib2.sdres_2#i.traitement_csg ib2.sdres_3#i.traitement_csg ib2.sdres_4#i.traitement_csg ///
	ib2.sdres_7#i.traitement_csg ib2.sdres_5#i.traitement_csg ib2.sdres_6#i.traitement_csg ///
	
eststo : reg retraitedim2 i.diplome i.sdsexe i.sdagetr i.habitat i.traitement_csg ///
	ib2.sdres_2 ib2.sdres_3 ib2.sdres_4 ib2.sdres_7 ib2.sdres_5 ib2.sdres_6 ///
	ib2.sdres_2#i.traitement_csg ib2.sdres_3#i.traitement_csg ib2.sdres_4#i.traitement_csg ///
	ib2.sdres_7#i.traitement_csg ib2.sdres_5#i.traitement_csg ib2.sdres_6#i.traitement_csg ///
	
eststo : reg famdim2 i.diplome i.sdsexe i.sdagetr i.habitat i.traitement_csg ///
	ib2.sdres_2 ib2.sdres_3 ib2.sdres_4 ib2.sdres_7 ib2.sdres_5 ib2.sdres_6 ///
	ib2.sdres_2#i.traitement_csg ib2.sdres_3#i.traitement_csg ib2.sdres_4#i.traitement_csg ///
	ib2.sdres_7#i.traitement_csg ib2.sdres_5#i.traitement_csg ib2.sdres_6#i.traitement_csg ///
	
eststo : reg chomdim2 i.diplome i.sdsexe i.sdagetr i.habitat i.traitement_csg ///
	ib2.sdres_2 ib2.sdres_3 ib2.sdres_4 ib2.sdres_7 ib2.sdres_5 ib2.sdres_6 ///
	ib2.sdres_2#i.traitement_csg ib2.sdres_3#i.traitement_csg ib2.sdres_4#i.traitement_csg ///
	ib2.sdres_7#i.traitement_csg ib2.sdres_5#i.traitement_csg ib2.sdres_6#i.traitement_csg ///
	
esttab, star(* 0.1 ** 0.05 *** 0.01) p




********************************************************************************
* Comparaison famille chômage (effet d'être bénéficiaire ou éligible)
********************************************************************************
* a faire seulement sur une période restreinte: 
* les coef sortent assez différement et ne sont plus significatifs.

eststo clear
eststo : reg famdim1 c.sdnivie i.diplome i.sitfam i.sdagetr i.sdsexe
eststo : reg famdim2 c.sdnivie i.diplome i.sitfam i.sdagetr i.sdsexe
eststo : reg chomdim1 c.sdnivie i.diplome i.sitfam i.sdagetr i.sdsexe
eststo : reg chomdim2 c.sdnivie i.diplome i.sitfam i.sdagetr i.sdsexe
coefplot est1 est2, bylabel("Allocations familiales") || est3 est4 , bylabel("Allocations chômage") || , xline(0) baselevels legend(order(2 "Inclusivité (-) ou exclusivité (+)" 4 "Indécision ou statuquo (-) ") rows(2)) name(AC, replace) keep(*sitfam) headings(1.sitfam="{bf: Situation familiale}")





eststo clear
eststo : reg famdim1 i.diplome ib2.sdstat i.sitfam i.sdagetr i.sdsexe
eststo : reg famdim2 i.diplome ib2.sdstat i.sitfam i.sdagetr i.sdsexe
eststo : reg chomdim1 i.diplome ib2.sdstat i.sitfam i.sdagetr i.sdsexe
eststo : reg chomdim2 i.diplome ib2.sdstat i.sitfam i.sdagetr i.sdsexe
coefplot est1 est2, bylabel("Allocations familiales") || est3 est4 , bylabel("Allocations chômage") || , xline(0) baselevels legend(order(2 "Inclusivité (-) ou exclusivité (+)" 4 "Indécision ou statuquo (-) ") rows(2)) name(AC, replace) headings(1.sdstat="{bf:Statut d'emploi}" 1.sitfam="{bf: Situation familiale}" 1.sdagetr="{bf: Tranche d'âge}" 1.sdsexe="{bf: Sexe}") drop(_cons) keep(*sitfam *sdstat)



eststo clear
eststo : reg famdim1 i.enfant##i.sdnivie i.sdsexe
eststo : reg famdim2 i.enfant##i.sdnivie i.sdsexe
coefplot est1, xline(0) baselevels legend(order(2 "Variable opposant inclusivité des prestations (coef négatifs)" "et exclusivité des prestations (coef positifs) ") rows(2)) headings(0.enfant="{bf: Nombre d'enfant}" 1.sdnivie="{bf: Niveau de vie}" 0.enfant#1.sdnivie="{bf: Nombre d'enfant et niveau de vie}" 1.sdagetr="{bf: Tranche d'âge}" 1.sdsexe="{bf: Sexe}") drop(_cons) title(Allocations familiales)
margins, dydx(enfant) over(sdnivie)
marginsplot
margins, dydx(sdnivie) over(enfant)
marginsplot

eststo clear
eststo : reg famdim1 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==1
eststo : reg famdim1 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==2
eststo : reg famdim1 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==3
eststo : reg famdim1 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==4
eststo : reg famdim1 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==5
eststo : reg famdim2 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==1
eststo : reg famdim2 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==2
eststo : reg famdim2 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==3
eststo : reg famdim2 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==4
eststo : reg famdim2 i.diplome3 i.enfant2 c.sdage i.sdsexe if sdnivie==5
coefplot est1 est2 est3 est4 est5 || est6 est7 est8 est9 est10, keep(*enfant2) xline(0) legend(order(2 "Q1" 4 "Q2" 6 "Q3" 8 "Q4" 10 "Q5"))
eststo : reg famdim2 i.diplome i.sitfam i.sdagetr i.sdsexe



* former une variable d'origine de revenue
* ajouter division cdi cdd?


* longitudinale en fonction des socio-démo 
*(initialement prévu pour 4 ans et généralisé pour 21 donc difficulté de lecture peut se poser, 
* néanmoins la profondeur temporelle permet de dire des choses plus intéressantes)

mean chomdim1, over(annee)
estimates store meanchomdim1
mean chomdim2, over(annee)
estimates store meanchomdim2
mean chomdim1 if sdres_6==1, over(annee)
estimates store meanchomdim1_sdres6
mean chomdim2 if sdres_6==1, over(annee)
estimates store meanchomdim2_sdres6
mean chomdim1 if sdres_7==1, over(annee)
estimates store meanchomdim1_sdres7
mean chomdim2 if sdres_7==1, over(annee)
estimates store meanchomdim2_sdres7
mean chomdim1 if sdres_5==1, over(annee)
estimates store meanchomdim1_sdres5
coefplot meanchomdim1 meanchomdim1_sdres6 meanchomdim1_sdres7 meanchomdim1_sdres5, recast(connected) vertical
* choc difficilement visible pour les retraités (2017-2020) et pour les revenus financiers (2018-2020) mais semble possible

mean chomdim1 if pcs8==2, over(annee)
estimates store meanchomdim1_pcs8_2
mean chomdim2 if pcs8==2, over(annee)
estimates store meanchomdim2_pcs8_2
mean chomdim1 if pcs8==6, over(annee)
estimates store meanchomdim1_pcs8_6
mean chomdim2 if pcs8==6, over(annee)
estimates store meanchomdim2_pcs8_6
mean chomdim1 if pcs8==7, over(annee)
estimates store meanchomdim1_pcs8_7
mean chomdim2 if pcs8==7, over(annee)
estimates store meanchomdim2_pcs8_7
coefplot meanchomdim1 meanchomdim1_pcs8_7 meanchomdim1_pcs8_2 meanchomdim1_pcs8_6, recast(connected) vertical
* choc sur les ouvriers en 2018-2020 (+ de soutien) choc sur les cadres 2011

coefplot meanchomdim1 meanchomdim2 meanchomdim1_pcs8_6 meanchomdim2_pcs8_6, recast(connected) vertical


mean chomdim1 if sdstat==1, over(annee)
estimates store meanchomdim1_statut1
mean chomdim2 if sdstat==1, over(annee)
estimates store meanchomdim2_statut1
mean chomdim1 if sdstat==2, over(annee)
estimates store meanchomdim1_statut2
mean chomdim2 if sdstat==2, over(annee)
estimates store meanchomdim2_statut2

coefplot meanchomdim1_statut1 meanchomdim2_statut1 meanchomdim1_statut2 meanchomdim2_statut2, recast(connected) vertical ciopts(recast(rline) lpattern(dash)) level(90)

mean AMdim1 if sdstat==1, over(annee)
estimates store meanAMdim1_statut1
mean AMdim2 if sdstat==1, over(annee)
estimates store meanAMdim2_statut1
mean AMdim1 if sdstat==2, over(annee)
estimates store meanAMdim1_statut2
mean AMdim2 if sdstat==2, over(annee)
estimates store meanAMdim2_statut2
coefplot meanAMdim1_statut1 meanAMdim1_statut2, recast(connected) vertical ciopts(recast(rline) lpattern(dash)) level(90)


* graphe intéressant surtout pour hypothèse de tendance commune. probleme de légende complexe à modifier.
* a aprofondire entre autre pour allocations familiales?
* et par statut d'emploi avec les indépendants et les retraités pour la parties DID sur les cotisations







