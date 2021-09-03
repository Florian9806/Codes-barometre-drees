cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do 9_2_self_interest



* stat desc soutien aux allocs famille en fonction du statut familiale/ être concerné par la réforme ou non

g f=(ps13_a_3==4 & bdd==3)
replace f=. if ps13_a_3==. | bdd!=3

forvalues i=1/3 {
bys annee: egen f`i'_2enf = mean(f) if revtr2==`i' & sdnbenf>=2
bys annee: egen f`i'_inf = mean(f) if revtr2==`i' & sdnbenf<2
}

tw (connected f1_2enf annee) (connected f1_inf annee)  if annee!=2017
tw (connected f1_2enf annee)  (connected f2_2enf annee) (connected f3_2enf annee) if annee>2003, xline(2014.5) name(famille_sup, replace)
tw (connected f1_inf annee)  (connected f2_inf annee) (connected f3_inf annee) if annee>2003, xline(2014.5) name(famille_inf, replace)


forvalues i=4/7 {
bys annee: egen f`i'_2enf_2 = mean(f) if sdrevtr==`i' & sdnbenf>=2
bys annee: egen f`i'_inf_2 = mean(f) if sdrevtr==`i' & sdnbenf<2
}


tw (connected f1_2enf_2 annee) (connected f2_2enf_2 annee) (connected f3_2enf_2 annee) (connected f4_2enf_2 annee) (connected f5_2enf_2 annee) (connected f6_2enf_2 annee) (connected f7_2enf_2 annee)  if annee!=2017, xline(2014.5)

* Placebo assurance maladie
g m=(ps13_a_1==4 & bdd==1)
replace m=. if ps13_a_1==. | bdd!=1

forvalues i=1/3 {
bys annee: egen m`i'_2enf = mean(m) if revtr2==`i' & sdnbenf>=2
bys annee: egen m`i'_inf = mean(m) if revtr2==`i' & sdnbenf<2
}

tw (connected m1_2enf annee) (connected m1_inf annee)  if annee!=2017
tw (connected m1_2enf annee)  (connected m2_2enf annee) (connected m3_2enf annee) if annee!=2017 & annee>2003, xline(2014.5) name(maladie_sup, replace)
tw (connected m1_inf annee) (connected m2_inf annee) (connected m3_inf annee) if annee!=2017 & annee>2003, xline(2014.5) name(maladie_inf, replace)


* Placebo Allocations chômage

g c=(ps13_a_4==4 & bdd==4)
replace c=. if ps13_a_4==. | bdd!=4

forvalues i=1/3 {
bys annee: egen c`i'_2enf = mean(c) if revtr2==`i' & sdnbenf>=2
bys annee: egen c`i'_inf = mean(c) if revtr2==`i' & sdnbenf<2
}

tw (connected c1_2enf annee) (connected c1_inf annee)  if annee!=2017
tw (connected c1_2enf annee)  (connected c2_2enf annee) (connected c3_2enf annee) if annee>2003, xline(2014.5) name(chomage_sup, replace)
tw (connected c1_inf annee) (connected c2_inf annee) (connected c3_inf annee) if annee>2003, xline(2014.5) name(chomage_inf, replace)


bys annee: egen ctot = mean(c) if inrange(sdrevtr, 1, 5) & sdnbenf>=2
tw (connected ctot annee) (connected c3_2enf annee) if annee>2003, xline(2014.5) name(chomagetot, replace)

bys annee: egen ctotinf = mean(c) if inrange(sdrevtr, 1, 5) & sdnbenf<2
tw (connected ctotinf annee) (connected c3_inf annee) if annee>2003, xline(2014.5) name(chomagetotinf, replace)


******************



forvalues i=1/7 {
bys annee: egen f`i'_2enf_2 = mean(f) if sdrevtr==`i' & sdnbenf>=2
bys annee: egen f`i'_inf_2 = mean(f) if sdrevtr==`i' & sdnbenf<2
}


tw (connected f1_2enf_2 annee) (connected f2_2enf_2 annee) (connected f3_2enf_2 annee) (connected f4_2enf_2 annee) (connected f5_2enf_2 annee) (connected f6_2enf_2 annee) (connected f7_2enf_2 annee)  if annee!=2017, xline(2014.5)


bys annee: egen ftot = mean(f) if inrange(sdrevtr, 1, 5) & sdnbenf>=2

tw (connected ftot annee) (connected f3_2enf annee) if annee>2003, xline(2014.5) name(ftot, replace)

bys annee: egen ftotinf = mean(f) if inrange(sdrevtr, 1, 5) & sdnbenf<2

tw (connected ftotinf annee) (connected f3_inf annee) if annee>2003, xline(2014.5) name(ftotinf, replace)

