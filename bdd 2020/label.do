/*auteur Florian Baudoin
date : 18/05/21
labels de la base de données du baromètre de la drees 2000-2020
Vérifier les noms des fichiers avant de lancer le code, 
le dictionnaire des variables doit s'appeler dico_var 
et le dictionnaire des libellés doit s'appeler dico_lib


Plus changer à la main dans le xlsx dico_lib les nom des variables :
variable | mod | libelle
*/
*************************

clear all

cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"


**************************

/* importation du dictionnaire des labels de variables 2019 */
import excel "dico_var.xlsx", sheet("variables") cellrange(A2:B413) firstrow
tempname varlabel
local N = c(N) /* nombre de var*/

/* Création d'un nouveau fichier .do pour sauvegarder l'ensemble des label */
file open `varlabel'  using var_label.do, write replace


/* boucle for pour écrire les commandes de labels dans le fichier .do*/
forvalues i = 1/`N' {
    file write `varlabel' "label variable `= Variable[`i']' "
    file write `varlabel' `""`= Libellé[`i']'""' _newline
}

file close `varlabel'

/*importation des données du baromètre 2000 - 2019 */
import delimited "Baromètre20.csv", varnames(1) delimiter(";") clear

/* application du fichier .do avec tout les labels de variables enregistrées*/

do var_label.do

/* attention au chemin de sauvegarde*/
save "Baromètre20.dta", replace




/* Ensuite on fait (preque) la même chose sur les labels des catégories pour chaque variables, imports du dico des labels, création d'un fichier do avec l'ensemble des commandes, puis application du fichier do*/

clear
cd "C:/Users/Utilisateur/Documents/StageLiepp/données/bdd 2020"

import excel "dico_lib.xlsx", sheet("libellés") cellrange(A3:C1766) firstrow

tempname lib
local N = c(N) /*sauvegarde nombre de colonne sert ligne 43 */
display `N'

file open `lib'  using libelles.do, write replace

*local n = 0
local i=1

while `i' <= `N' {
	if variable[`i']!=""{
		file write `lib' " label define `= variable[`i']' `=mod[`i']' "
		file write `lib' `""`= libelle[`i']'""'
		local i = `i'+1
	}

	local j = `i'
*	count if variable == "`=variable[`i']'"
	while variable[`j']==""{
		if `j' <= `N' {
			file write `lib' " `=mod[`j']' "
			file write `lib' `""`= libelle[`j']'""'
			local j = `j'+1
			local n = `j' - `i'
			display `n'
		}
		else {
			local j = 1
			local n = `n'
		}
	}
	
	local i = `i'+ `n'
	if variable[`i']!="" {
		file write `lib' _newline
		file write `lib' " label value `= variable[`i'- `n'-1] '  `= variable[`i' - `n'-1] '  " _newline
	}
*	local i = `i' + 1
*	display `i'
}

file close `lib'

/* fin du do file avec les labels, imports des données en dta */

use Baromètre20, clear

do libelles.do  /* application du do file label aux données*/ 

save "Baromètre20.dta", replace
