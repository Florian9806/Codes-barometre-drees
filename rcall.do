* Florian Baudoin
* 26/05/21
* Installation des packages pour utiliser R et factominer sur stata

* Package pour importer des codes de github
net install github, from("https://haghish.github.io/github/")


* Package rcall pour faire tourner un code R dans stata
github install haghish/rcall, stable


* importation des packages de R:

 /* début de code R*/
rcall: install.packages("readstata13", repos="http://cran.uk.r-project.org") /*package qui permet de passer de R à stata*/

*install.packages("FactoMineR", repos = "http://cran.us.r-project.org")
*library(FactoMineR)
rcall: library(readstata13)
*install.packages(c("Factoshiny","missMDA","FactoInvestigate"), repos = "http://cran.us.r-project.org")



