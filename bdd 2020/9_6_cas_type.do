
*******************Cas types soutien assurance maladie et allocations chômage**************************


logit Y_bin i.statut i.diplome i.sdnivie i.sdagetr i.sdsexe if bdd==1 & sdrevtr!=8 & inrange(annee, 2015, 2020)
predict castype_am if e(sample) 

logit Y_bin i.statut i.diplome i.sdnivie i.sdagetr i.sdsexe if bdd==4 & sdrevtr!=8 & inrange(annee, 2015, 2020)
predict castype_chom if e(sample) 

* cas initial femme
sum castype_am castype_chom if sdsexe==2 & sdagetr==2 & diplome==2 & sdnivie==1 & statut==6
* inactive à salarié du privé
sum castype_am castype_chom if sdsexe==2 & sdagetr==2 & diplome==2 & sdnivie==1 & statut==2
* bas revenu sans diplome à haut revenu avec diplome
sum castype_am castype_chom if sdsexe==2 & sdagetr==2 & diplome==5 & sdnivie==5 & statut==2
* age = 4 (50-64ans)
sum castype_am castype_chom if sdsexe==2 & sdagetr==4 & diplome==5 & sdnivie==5 & statut==2
* retraité avec bac
sum castype_am castype_chom if sdsexe==2 & sdagetr==5 & diplome==3 & sdnivie==5 & statut==7
* retraité bas revenu
sum castype_am castype_chom if sdsexe==2 & sdagetr==5 & diplome==3 & sdnivie==1 & statut==7

* cas initial homme
sum castype_am castype_chom if sdsexe==1 & sdagetr==1 & diplome==1 & sdnivie==1 & statut==5
* age = 3
sum castype_am castype_chom if sdsexe==1 & sdagetr==3 & diplome==1 & sdnivie==1 & statut==5
* statut = salarié du public
sum castype_am castype_chom if sdsexe==1 & sdagetr==3 & diplome==1 & sdnivie==1 & statut==1
* haut revenu mais toujours sans diplome
sum castype_am castype_chom if sdsexe==1 & sdagetr==3 & diplome==2 & sdnivie==5 & statut==1
*
sum castype_am castype_chom if sdsexe==1 & sdagetr==3 & diplome==5 & sdnivie==5 & statut==4



* Pour avoir la variance de l'estimation: faire tourner le code ci-dessus
* en ajoutant dans la commande predict ", stdp" et en créant 2 nouvelles variables


* effet fixe année en proba prédite
* effet FP et indép, cotis retraite
