








g si_am=(bdd==1)


g si_retr= (bdd==2 & sdres_5==1) /* ou statut==7 ? */

/* bénéf d'allocations familiales sont à 70% couple avec enfant, 
17 % familles monop (7.3% dans l'échantillon total)
64% des personnes avec 2enfants touchent des AF (prop augmente >2enfants)
Seul 25% des enquêtés ayant 1 enfant beneficie des AF
-> le plus déterminant pour séparer les familles 1 enfant 
n'est pas le nb de parent mais le niveau de revenu
*/
g si_fam= (bdd==3 & inrange(sdnbenf,2,10) ) /* famille avec 2 enfants ou plus*/

* SI famille prenant en compte (approximativement) l'effet du revenu dans la répartition des allocations familiales
g si_fam_rev= (bdd==3 & (inrange(sdnbenf, 3, 10) | (sdrevtr!=7 & sdnbenf==2) | (sdnbenf==1 & sdrevtr==1)) )



/* foyer bénéficiant des allocations chômage, 
n'inclut pas tous les chômeurs et n'inclut pas que des chômeurs, 
seulement 3472 individus en commun pour 6000 et 8000 individus concernés en fonction de la variable */
g si_chom= (bdd==4 & sdres_4==1)
g si_chom2 = (bdd==4 & statut==5)
