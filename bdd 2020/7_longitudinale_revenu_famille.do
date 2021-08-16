cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "1_PS1_longitudinale"

* Fait tourner un autre code avant avec production graphique, à voir si on simplifie pas en séparant le code 1 en deux, la première partie création de variable, la deuxième création graphiques.

********************************************************************************
* Stat desc longitudinale sur population haut revenu avec enfant (allocations familiales)
********************************************************************************


g REV =(sdrevtr==6 | sdrevtr==7)
bys REV annee: egen meanrev_non2_fam = mean(non2_fam)

tw (connected meanrev_non2_fam annee if REV==1) (connected meanrev_non2_fam annee if REV==0), xtitle("") title("Personnellement, compte-tenu de votre niveau de ressources," "êtes-vous prêt à accepter une diminution des prestations" "pour payer moins d’impôts ou moins de cotisations" famille) legend(order(1 "2 dernières tranches de revenues" 2 "Reste de la population")) name(REV, replace)

g REV2 =(sdrevtr==6 | sdrevtr==7 & n2_enfant==1)
bys REV2 annee: egen meanrev2_non2_fam = mean(non2_fam)

tw (connected meanrev2_non2_fam annee if REV2==1) (connected meanrev2_non2_fam annee if REV2==0)  (connected meanrev_non2_fam annee if REV==1), xtitle("") title("Personnellement, compte-tenu de votre niveau de ressources," "êtes-vous prêt à accepter une diminution des prestations" "pour payer moins d’impôts ou moins de cotisations" famille) name(REV2, replace)


bys REV annee: egen meanrev3_non2_fam=mean(non2_fam) if n2_enfant==1
tw (connected meanrev3_non2_fam annee if REV==1) (connected meanrev3_non2_fam annee if REV==0)  (line meanrev_non2_fam annee if REV==1) (line meanrev_non2_fam annee if REV==0), xtitle("") title("Personnellement, compte-tenu de votre niveau de ressources," "êtes-vous prêt à accepter une diminution des prestations" "pour payer moins d’impôts ou moins de cotisations" famille) name(REV2, replace)


bys sdstat annee: egen meanstat_non2_fam= mean(non2_fam)
tw (connected meanstat_non2_fam annee if sdstat==1) (connected meanstat_non2_fam annee if sdstat==2) 

bys sdstat annee: egen meanstat_non2_chom= mean(non2_chom)
tw (connected meanstat_non2_chom annee if sdstat==1) (connected meanstat_non2_chom annee if sdstat==2) 


catplot ps13_a_3 if sdres_8!=3 & ps13_a_3<5, over(sdres_8) percent(sdres_8) asyvar stack blabel(bar, color(white) pos(center) format(%3.1f)) legend(rows(1) cols(4)) l1title(Bénéficiaire de prestations familiales) ytitle("") title("Accepteriez-vous une baisse des allocations familiales" "en échange d'une baisse de cotisation?")
