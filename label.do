/*auteur Florian Baudoin
date : 18/05/21
labels de la base de données du baromètre de la drees 2000-2019
*/
*************************

cd C:/Users/Utilisateur/Documents/StageLiepp/données


**************************

/* importation du dictionnaire des labels de variables 2019 */
import delimited "dico_var.csv", varnames(1) encoding(windows-1252)  delimiter(";") clear

tempname varlabel
local N = c(N) /* nombre de var*/

/* Création d'un nouveau fichier .do pour sauvegarder l'ensemble des label */
file open `varlabel'  using var_label.do, write replace


/* boucle for pour écrire les commandes de labels dans le fichier .do*/
forvalues i = 1/`N' {
    file write `varlabel' "label variable `= var[`i']' "
    file write `varlabel' `""`= lib[`i']'""' _newline
}

file close `varlabel'

/*importation des données du baromètre 2000 - 2019 */
import delimited "Baromètre19.csv", varnames(1) delimiter(";") clear

/* application du fichier .do avec tout les labels de variables enregistrées*/

do var_label.do

/* attention au chemin de sauvegarde*/
save "C:\Users\Utilisateur\Documents\StageLiepp\données\Baromètre19.dta", replace




/* Ensuite on fait (preque) la même chose sur les labels des catégories pour chaque variables, imports du dico des labels, création d'un fichier do avec l'ensemble des commandes, puis application du fichier do*/


import delimited "dico_lib.csv", varnames(1) encoding(windows-1252)  delimiter(";") clear

tempname lib
local N = c(N) /*sauvegarde nombre de colonne sert ligne 43 */


file open `lib'  using libelles.do, write replace
local i = 1


/* Boucle while plus simple que boucle for mais le principe reste le même, on ajoute une boucle pour les items de chaques variables dans la première boucle*/

while `i' <= `N' {
    file write `lib' " label define `= variable[`i']'"
	local j = 0
	count if variable == "`=variable[`i']'"
	local n = r(N)
	while `j' <= `n'-1 {
	    file write `lib' " `=mod[`i'+`j']' "
		file write `lib' `""`= libelle[`i'+`j']'""'
		local j = `j'+1
	}
	file write `lib' _newline
    file write `lib' " label value `= variable[`i'] '  `= variable[`i'] '  " _newline
	local i = `i'+ `n'
}

file close `lib'

/* fin du do file avec les labels, imports des données en dta */

use Baromètre19, clear

do libelles.do  /* application du do file label aux données*/ 

save "C:\Users\Utilisateur\Documents\StageLiepp\données\Baromètre19.dta", replace
