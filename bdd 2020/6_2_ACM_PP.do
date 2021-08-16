cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

do "6_0_ACM_codage_variables"


* ligne suivante a modifier pour avoir l'acm 17-20/ hcfips 2 (même ACM que précédement mais résultats mieux présentés)

mca ps2_ab ps1_ab_4 ps3_ab, sup(annee pcs8 diplome sdagetr sdres_2 sdres_3 sdres_4 sdres_5 sdres_6) method(burt) normalize(standard) dim(5)



mcaplot (ps2_ab, msymbol(circle) mcolor(red) mlabcolor(red)) (ps1_ab_4, msymbol(diamond) mcolor(green) mlabcolor(green)) (ps3_ab, msymbol(triangle) mcolor(blue) mlabcolor(blue)),  overlay mlabgap(1) mlabpos(3) msize(tiny) mlabsize(vsmall) mlabangle(45) origin legend(size(small) position(3)) title(ACM 2000-2020 Assurance chomage questionnaire A et B)
mcaplot annee, origin mlabpos(3) msize(tiny) mlabsize(vsmall) mlabangle(45)
mcaplot (pcs8, msymbol(circle) mcolor(red) mlabcolor(red) mlabpos(3) mlabangle(45)) (diplome, msymbol(diamond) mcolor(green) mlabcolor(green)mlabpos(6)) (sdagetr, msymbol(triangle) mcolor(blue) mlabcolor(blue) mlabpos(9)),  overlay mlabgap(1) msize(tiny) mlabsize(vsmall) origin legend(size(small) position(3)) title(ACM 2000-2020 Assurance chomage questionnaire A et B)


* regressions sur les deux premières dimensions nommées A et B
predict A B if e(sample)
eststo clear
eststo : reg A i.annee i.diplome i.sdnivie i.sdsexe
eststo : reg B i.annee i.diplome i.sdnivie i.sdsexe
esttab, star(* 0.1 ** 0.05 *** 0.01) p
coefplot est1 est2, keep(*.annee) baselevels xline(0)

eststo clear
eststo : reg A ib2.pcs8 i.sdsexe i.sdagetr i.habitat
eststo : reg B ib2.pcs8 i.sdsexe i.sdagetr i.habitat
esttab, star(* 0.1 ** 0.05 *** 0.01) p
coefplot est1 est2, keep(*.pcs8) baselevels
coefplot est1 est2, keep(*.sdagetr)
coefplot est1 est2, keep(*.sdsexe *.habitat) baselevels


eststo clear
eststo : reg A i.diplome i.sdstat i.sdsexe i.sdagetr i.habitat i.sitfam
eststo : reg B i.diplome i.sdstat i.sdsexe i.sdagetr i.habitat i.sitfam
esttab, star(* 0.1 ** 0.05 *** 0.01) p
coefplot est1 est2, keep(*.diplome *.sdstat) baselevels xline(0)
coefplot est1 est2, keep(*.sdagetr *.sitfam) baselevels xline(0)
coefplot est1 est2, keep(*.sdsexe *.habitat) baselevels xline(0)

eststo clear
eststo : reg A i.diplome ib2.sdres_1 ib2.sdres_2 ib2.sdres_3 ib2.sdres_6##i.annee ib2.sdres_7 ib2.sdres_5 ib2.sdres_4 i.sdsexe i.sdagetr i.habitat
eststo : reg B i.diplome ib2.sdres_1 ib2.sdres_2 ib2.sdres_3 ib2.sdres_6##i.annee ib2.sdres_7 ib2.sdres_5 ib2.sdres_4 i.sdsexe i.sdagetr i.habitat
esttab, star(* 0.1 ** 0.05 *** 0.01) p
esttab using acm_chom_sdres6_20.tex, f label nonumbers mtitles("Dimension 1: soutien aux cotisations chomages" "Dimension 2: soutien au changement de système") addnote("Source: Baromètre Drees BVA 2020") scalar(r2) star(* 0.1 ** 0.05 *** 0.01) replace compress longtable not
coefplot est1 est2, keep(*.sdres_6*) xline(0) /* choc de 2018 sur le soutien des foyer détenant des actifs financiers */
coefplot est1 est2, keep(*.annee) xline(0) legend(order(2 "Favorable à plus de cotisations sociales" 4 "Favorable à un changement de système")) title(Soutien à l'assuance chômage 2000 2020)
coefplot est1 est2, keep(*.sdres*) baselevels xline(0) 
coefplot est1 est2, keep(*.sdagetr) baselevels xline(0)
coefplot est1 est2, keep(*.sdsexe *.habitat) baselevels xline(0)


eststo clear
eststo : reg A ib3.sdpoltr#i.diplome3 i.diplome3
eststo : reg B ib3.sdpoltr#i.diplome3 i.diplome3
esttab, star(* 0.1 ** 0.05 *** 0.01) p
coefplot est1 est2, keep(*.sdpoltr*) baselevels xline(0) legend(order(1 "Moins de cotisations presta // Plus de cotisations presta"3 "Favorable à un changement de sytème // défavorable") cols(1) rows(2))

eststo clear
eststo : reg A i.ps13_a_4
eststo : reg A i.ps3_ab
eststo : reg A i.ps2_ab
eststo : reg B i.ps13_a_4
eststo : reg B i.ps3_ab
eststo : reg B i.ps2_ab
esttab, star(* 0.1 ** 0.05 *** 0.01) p scalar(r2)
* ps13_a_4 explique assez peu la variance de A et B -> se concentrer sur des CA qui prennent mieux en compte la branche en tant que telle et moins la protection sociale en générale.

eststo clear
eststo : mlogit ps13_a_4 A
eststo : mlogit ps3_ab A
eststo : mlogit ps2_ab A
eststo : mlogit ps13_a_4 B
eststo : mlogit ps3_ab B
eststo : mlogit ps2_ab B
esttab, star(* 0.1 ** 0.05 *** 0.01) p scalar(r2_p chi2 ll aic bic)
