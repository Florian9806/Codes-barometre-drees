###########################################################################
#####                                                                 #####
##### PROGRAMME POUR LIRE LES LIBELLES DES VARIABLES ET MODALITES     #####
#####                         VAGUE 2020                             #####
#####                                                                 #####
#####                                                                 #####
###########################################################################

#rm(list=ls())

library(Hmisc)
library(dplyr)
library(haven)
library("readxl")
library("xts")
library(data.table)
#indiquer le chemin du fichier pour lire la base 
 
barometre2000_2020_diff<-read.csv(file=".../barometre2000_2020_diff.csv", sep=";", dec=",")
 
# pour attribuer des noms aux variables et à leurs modalites 

# 1. Chargement des dicos
# indiquer le chemin de la base des dicos des variables et libelles
dico <- ".../"
dico_var <- data.table(read_xlsx(paste(dico,"dico_variable2020_diff.xlsx",sep=""),sheet=1,skip=1))
dico_lib<- data.table(read_xlsx(paste(dico,"dico_libelle2020_diff.xlsx",sep=""),skip=2))

# 2. Changement des noms de colonnes des dicos
setnames(dico_var,c("var","lib"))
setnames(dico_lib,c("variable","mod","libelle"))

# Passage de la colonne variable au format long
dico_lib$variable <- na.locf(dico_lib$variable)

# passage des variables au bon format
dico_lib$mod<-as.numeric(as.character(dico_lib$mod))
dico_lib$variable<-(as.character(dico_lib$variable))
dico_lib$libelle<-(as.character(dico_lib$libelle))


#3. Attribuer un label aux noms de COLONNES
for (i in 1:dim(dico_var)[1]){
  print(i)
  if(dico_var$var[i] %in% names(barometre2000_2020_diff)){
    
    eval(parse(text = paste('attr(barometre2000_2020_diff$',dico_var$var[i],',',"'label'",')<-','"',dico_var$lib[i],'"',sep="")))
    
  }
  
}


# 4. Attribuer un label aux noms de MODALITES
for (i in 1:length(unique(dico_lib$variable))){
  print(i)
  var<-unique(dico_lib$variable)
  eval(parse(text = paste("test<-dico_lib[which(dico_lib$variable=='",var[i],"'),]",sep="")))
  
  if(var[i] %in% names(barometre2000_2020_diff)){
    
    eval(parse(text = paste("attr(barometre2000_2020_diff$",var[i],",'labels')<-setNames(c(test$mod), c(test$libelle))",sep="")))
  }
  
}


#5. Quelques verifications 

baro<-barometre2000_2020_diff

str(baro)
names(baro)
attr(baro$og8_1, "label")#label de la variable
attr(baro$og8_1, "labels")# label des modalit?s de la variable

# les nouvelles variables 
attr(baro$sdnivie, "label")
attr(baro$sdnivie, "labels")
attr(baro$sdageenftr_1, "label")
attr(baro$sdniviecl_imput, "label")
attr(baro$sdrevcl_imput, "label")

