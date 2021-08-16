cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "code sur enquete 2020"





********************************************************************************
* analyse chomage RSA
********************************************************************************

replace ps13_a_1=5 if ps13_a_1==6
replace ps13_a_2=5 if ps13_a_2==6
replace ps13_a_3=5 if ps13_a_3==6
replace ps13_a_4=5 if ps13_a_4==6

ta ps13_a_1 pe9_ab, chi2 nofreq
ta ps13_a_2 pe9_ab, chi2 nofreq
ta ps13_a_3 pe9_ab, chi2 nofreq
ta ps13_a_4 pe9_ab, chi2 nofreq



ta ps13_a_1 pe17_ab if pe17_ab!= 3, chi2 nofreq
ta ps13_a_2 pe17_ab if pe17_ab!=3, chi2 nofreq
ta ps13_a_3 pe17_ab if pe17_ab!=3, chi2 nofreq
ta ps13_a_4 pe17_ab if pe17_ab!=3, chi2 nofreq

ta ps13_a_1 pe10 if pe10!=3, chi2
ta ps13_a_2 pe10 if pe10!=3, chi2
ta ps13_a_3 pe10 if pe10!=3, chi2
ta ps13_a_4 pe10 if pe10!=3, chi2

ta pe9_ab ps2_ab, chi2 cchi2
ta pe10 ps2_ab, chi2 cchi2 
ta pe17_ab ps2_ab, chi2 cchi2


ta pe17_ab sdagetr if pe17_ab!=3, chi2
ta pe9_ab sdagetr if pe9_ab==1 | pe9_ab==2, chi2
ta pe10 sdagetr if pe10!=3, chi2


ta pe10 ps1_ab_1 if pe10!=3, chi2 cchi2 col nof
ta pe10 ps1_ab_2 if pe10!=3, chi2 cchi2 col nof
ta pe10 ps1_ab_3 if pe10!=3, chi2 cchi2 col nof
ta pe10 ps1_ab_4 if pe10!=3, chi2 cchi2 col nof 
ta pe10 ps2_ab if pe10!=3, chi2 nof 
ta pe10 ps3_ab if pe10!=3, chi2 nof
ta pe10 ps16_ab if pe10!=3, chi2 nof

* créer sur 2017-2020 car pb de filtre sur certaines années
g pe9_10=1 if pe9_ab==1 & pe10==1 & annee>=2017
replace pe9_10=2 if pe9_ab==1 & (pe10==2 | pe10==3) & annee>=2017
replace pe9_10=3 if pe9_ab==2 & annee>=2017
replace pe9_10=4 if pe9_ab==3 | pe9_ab==4 & annee>=2017

ta ps13_a_1 pe9_10 if ps13_a_1!=5, chi2 
ta ps13_a_2 pe9_10 if ps13_a_2!=5, chi2 
ta ps13_a_3 pe9_10 if ps13_a_3!=5, chi2 
ta ps13_a_4 pe9_10 if ps13_a_4!=5, chi2 





* écart entre les bénéficiaires et les non bénéficiaires



ta ps13_a_4 sdres_4, col cchi2 chi2
ta pe9_ab sdres_3, col cchi2 chi2

g RSA1 = (pe9_ab==1)
replace RSA1=. if pe9_ab==.
g alloc_chom=(ps13_a_4==3 | ps13_a_4==4)
replace alloc_chom=. if ps13_a_4==.
ta alloc_chom sdres_4, col cchi2 chi2
ta RSA1 sdres_3, col cchi2 chi2
ta alloc_chom sdres_3, col cchi2 chi2
ta RSA1 sdres_4, col cchi2 chi2

g AM1 = (ps13_a_1==3 | ps13_a_1==4)
replace AM1 = . if ps13_a_1==.
ta AM1 sdres_3, col cchi2 chi2
ta AM1 sdres_4, col cchi2 chi2


ta sa8_2 sdres_3 if sa8_2!=3, col cchi2 chi2
ta sa8_2 sdres_4 if sa8_2!=3, col cchi2 chi2

ta sa8_5 sdres_3 if sa8_5!=3, col cchi2 chi2
ta sa8_5 sdres_4 if sa8_5!=3, col cchi2 chi2


eststo clear
eststo : qui logit RSA1 i.alloc_chom i.sa8_2 i.ps2_ab
eststo : qui logit alloc_chom i.RSA1 i.sa8_2 i.ps2_ab
esttab, star(* 0.1 ** 0.05 *** 0.01) eform p scalars(ll_0 ll chi2 ar2)



bys annee: egen m_RSA1=mean(RSA1)
bys annee: egen m_alloc_chom=mean(alloc_chom)
gen alloc_chom2=(ps13_a_4==1| ps13_a_4==2)
replace alloc_chom2=. if ps13_a_4==.
bys annee: egen m_alloc2_chom=mean(alloc_chom2)

tw (connected m_RSA1 annee) (connected m_alloc_chom annee) (connected m_alloc2_chom annee), legend(order(1 "Est favorable à une hausse du RSA" 2 "Refuse une baisse des allocations chômage" 3 "Accepte une baisse des allocations chômage") rows(3)) xtitle("") title(Soutien Chômage vs RSA)


bys sdnivie annee: egen m2_RSA1=mean(RSA1)
bys sdnivie annee: egen m2_alloc_chom=mean(alloc_chom)
tw (line m2_RSA1 annee if sdnivie==1) (line m2_RSA1 annee if sdnivie==2) (line m2_RSA1 annee if sdnivie==3) (line m2_RSA1 annee if sdnivie==4) (line m2_RSA1 annee if sdnivie==5), legend(order(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5"))

g revtr3 = 1 if sdrevtr==1 | sdrevtr==2
replace revtr3=2 if sdrevtr==3 | sdrevtr==4 | sdrevtr==5
replace revtr3=3 if sdrevtr==6 | sdrevtr==7

bys revtr3 annee: egen m3_RSA1=mean(RSA1)
bys revtr3 annee: egen m3_alloc_chom=mean(alloc_chom)
tw (line m3_RSA1 annee if revtr3==1) (line m3_RSA1 annee if revtr3==2) (line m3_RSA1 annee if revtr3==3), legend(order(1 "Moins de 1400€" 2 "1400€ à 3800€" 3 "Plus de 3800€")) xtitle("") ytitle("") title("Evolution de la part de personne se déclarant favorable" "à une hausse du RSA par tranche de revenu") xline(2009) xline(2016)
tw (line m3_alloc_chom annee if revtr3==1) (line m3_alloc_chom annee if revtr3==2) (line m3_alloc_chom annee if revtr3==3), legend(order(1 "Moins de 1400€" 2 "1400€ à 3800€" 3 "Plus de 3800€")) xtitle("") ytitle("") title("Evolution de la part de personne refusant" "une baisse des allocations chômage par niveau de revenu")

bys annee: egen m_mrsa = mean(pe8) if pe8<5000
bys revtr3 annee: egen m2_mrsa = mean(pe8) if pe8<5000
tw (line m2_mrsa annee if revtr3==1) (line m2_mrsa annee if revtr3==2) (line m2_mrsa annee if revtr3==3)





ta RSA1 alloc_chom
g rsa_chom= 1 if RSA1==0 & alloc_chom==0
replace rsa_chom=2 if RSA1==0 & alloc_chom==1
replace rsa_chom=3 if RSA1==1 & alloc_chom==0
replace rsa_chom=4 if RSA1==1 & alloc_chom==1
bys rsa_chom : egen rsa_poid = count(rsa_chom) if rsa_chom!=.
bys sdstat : egen statut_rsa = mean(RSA1) if RSA1!=.
bys sdstat : egen statut_chom = mean(alloc_chom) if alloc_chom!=.
bys sdstat : egen statpoid = count(sdstat) if sdstat!=.

bys revtr3 : egen rev_rsa = mean(RSA1) if RSA1!=. & revtr3!=.
bys revtr3 : egen rev_chom = mean(alloc_chom) if alloc_chom!=. & revtr3!=.

bys sdrevtr : egen sdrev_rsa = mean(RSA1) if RSA1!=. & sdrevtr!=.
bys sdrevtr : egen sdrev_chom = mean(alloc_chom) if alloc_chom!=. & sdrevtr!=.

bys sdres_3 : egen rsa_rsa =mean(RSA1) if RSA!=. & sdres_3!=3
bys sdres_3 : egen rsa_allocchom =mean(alloc_chom) if alloc_chom!=. & sdres_3!=3

bys sdres_4 : egen allocchom_rsa =mean(RSA1) if RSA!=. & sdres_4==1 | sdres_4 == 2
bys sdres_4 : egen allocchom_allocchom =mean(alloc_chom) if alloc_chom!=. & sdres_4==1 | sdres_4 == 2



tw (scatter statut_rsa statut_chom, mfcolor(none) mcol(red) mlabel(sdstat) mlabsize(vsmall) mlabpos(9)) (scatter sdrev_rsa sdrev_chom if sdrevtr!=8, msymbol(+) mfcolor(none) msize(vsmall) mcol(blue)) (line rsa_rsa rsa_allocchom) (line allocchom_rsa allocchom_allocchom) (function y=x), legend(order(1 "Statut d'emploi" 2 "Tranche de revenu" 3 "Effet bénéficiaire du RSA" 4 "Effet bénéficiaire du chômage")) xtitle("Part de refus à la baisse des allocations chômage") ytitle(Part de soutien à l'augmentation du RSA)

tw (scatter statut_rsa statut_chom, mfcolor(none) mcol(red) mlabel(sdstat) mlabsize(vsmall) mlabpos(9)) (scatter sdrev_rsa sdrev_chom if sdrevtr!=8, msymbol(+) mfcolor(none) msize(vsmall) mcol(blue)) (line rsa_rsa rsa_allocchom) (line allocchom_rsa allocchom_allocchom), legend(order(1 "Statut d'emploi" 2 "Tranche de revenu" 3 "Effet bénéficiaire du RSA" 4 "Effet bénéficiaire du chômage")) xtitle("Part de refus à la baisse des allocations chômage") ytitle(Part de soutien à l'augmentation du RSA)

