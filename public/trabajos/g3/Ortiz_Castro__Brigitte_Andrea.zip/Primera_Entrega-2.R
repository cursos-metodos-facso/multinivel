#Primera Entrega An√°lisis Multinivel
#Grupo 4: Brigitte Ortiz, Gabriel Fuentes, Guislaine Espinoza, Cristian Fuentes Tobar.
rm(list=ls())
#Fijar el directorio
setwd("C:/Users/Cristian/Desktop/Universidad/Multinivel")

#Instalar y activar paquetes necesarios para esta sesi√≥n
install.packages("pacman")
library(pacman)

pacman::p_load(survey,haven, car, dplyr, stargazer, lme4, texreg) 

#Cargamos la base PNUD 2015 
pnud <- read_sav("PNUD IDH 2015 SPSS.sav")
#pnud <- svydesign(data = pnud, id=~1, weights = ~pond) %>% as.data.frame()
#Seleccionamos las variables de inter√©s
pnud <- pnud %>% select(COR,Region,COD_COMUNA,SEXO,P1,P4,P8,P9,P10,P25a,P25b,P25c,P25d,P25e,P25f,P25g,P25h,
                        P29,P64a,P64b,P64c,P64d,P64e,P64g,P64h,P64i,P64j,P138,P141,P144,P151,NSE_imput) %>% as.data.frame()

#Procedemos a construir los Indices y variables que vamos a ocupar.
#Depedencia econÛmica (cargas familiares) P8,9 y 10
pnud$dep_hijos[pnud$P8==2]=0
pnud$dep_hijos[pnud$P9==2]=0
pnud$dep_hijos[pnud$P9==1]=1
table(pnud$dep_hijos)
 
pnud$dep_eco[pnud$dep_hijos==0 & pnud$P10==2]=0
pnud$dep_eco[pnud$dep_hijos==0 & pnud$P10==1]=1
pnud$dep_eco[pnud$dep_hijos==1 & pnud$P10==2]=1
pnud$dep_eco[pnud$dep_hijos==1 & pnud$P10==1]=2
table(pnud$dep_eco)


#EvaluaciÛn de oportunidades
pnud$opor <- (pnud$P25a+pnud$P25b+pnud$P25c+pnud$P25d+pnud$P25e+pnud$P25f+pnud$P25g+pnud$P25h)
summary(pnud$opor)

#ParticipaciÛn en acciones de protesta
pnud$P64a[pnud$P64a > 1]=0
pnud$P64b[pnud$P64b > 1]=0
pnud$P64c[pnud$P64c > 1]=0
pnud$P64d[pnud$P64d > 1]=0
pnud$P64e[pnud$P64e > 1]=0
pnud$P64g[pnud$P64g > 1]=0
pnud$P64h[pnud$P64h > 1]=0
pnud$P64i[pnud$P64i > 1]=0
pnud$P64j[pnud$P64j > 1]=0

  
pnud$part <- (pnud$P64a+pnud$P64b+pnud$P64c+pnud$P64d+pnud$P64e+pnud$P64g+pnud$P64h+pnud$P64i+pnud$P64j)
summary(pnud$part)

#Discrepancia NSE y enclasamiento
pnud$P144
pnud$NSE_imput
#CategorÌa de no discrepancia
pnud$disc[pnud$NSE_imput==1 & pnud$P144==1]=0
pnud$disc[pnud$NSE_imput==2 & pnud$P144==2]=0
pnud$disc[pnud$NSE_imput==3 & pnud$P144==3]=0
pnud$disc[pnud$NSE_imput==4 & pnud$P144==4]=0
pnud$disc[pnud$NSE_imput==5 & pnud$P144==5]=0

#CategorÌa de discrepancia ascendente (personas que se posicionan mejor)
pnud$disc[pnud$NSE_imput==2 & pnud$P144<1]=1
pnud$disc[pnud$NSE_imput==3 & pnud$P144<3]=1
pnud$disc[pnud$NSE_imput==4 & pnud$P144<4]=1
pnud$disc[pnud$NSE_imput==5 & pnud$P144<5]=1

#CategorÌa de discrepancia descendente (personas que se posicionan peor)
pnud$disc[pnud$NSE_imput==1 & pnud$P144>1]=2
pnud$disc[pnud$NSE_imput==2 & pnud$P144>2]=2
pnud$disc[pnud$NSE_imput==3 & pnud$P144>3]=2
pnud$disc[pnud$NSE_imput==4 & pnud$P144>4]=2

table(pnud$disc)

#Recodificamos la variable Sexo en Mujer
pnud$mujer[pnud$SEXO==1]=0
pnud$mujer[pnud$SEXO==2]=1
#pnud$mujer=factor(pnud$mujer, levels = c(0,1),labels = c("Hombre","Mujer"))
table(pnud$mujer)

#Recodificamos la variable Sentirse Perdedor
pnud$perd[pnud$P29==1]=0
pnud$perd[pnud$P29==2]=1
#pnud$perd=factor(pnud$perd, levels = c(0,1),labels = c("Ganador","Perdedor"))
table(pnud$perd)

#Seleccionamos las variables e Ìndices que utilizaremos en el modelo
pnud <- pnud %>% select(COR,Region,COD_COMUNA,P1,P4,P138,P141,P151,
                        dep_eco,opor,part,disc,mujer,perd) %>% as.data.frame()


#Agregamos promedio de ingresos de hogares por comuna extraido de CASEN 2017
ingr <- read_sav("Comunas.sav")
colnames(ingr) [1]<-"COD_COMUNA"
pnud <- merge(pnud,ingr, by.pnud="COD_COMUNA", by.ingr="COD_COMUNA")
pnud <- pnud %>% group_by(COR) %>% slice(4) %>% as.data.frame()


#Generamos las descriptivas de la variables
colnames(pnud) <- c("Comuna","ID","Region","Edad","N.Ed","SueÒos","P.Ingr","Ingr","Depen","Opor","Part","Disc","Mujer","Perd","Ingr.Com")

stargazer(pnud, title = "Descriptivos generales", type='text', digits=3, out="table1.html")


#EstimaciÛn del modelo nulo
mlm0 <- lmer(Part ~ 1 + (1|Comuna), data=pnud, REML=FALSE)
summary(mlm0)
screenreg(mlm0)

#CorrelaciÛn intraclase
0.09252/(0.09252+1.91184)

#Modelo 1 - ElecciÛn racional
mlm1 <- lmer(Part ~ 1 + P.Ingr + Ingr + factor(Depen) +  (1|Comuna), data=pnud, REML=FALSE)
summary(mlm1)
screenreg(mlm1)

#Modelo 2 - ElecciÛn racional y PrivaciÛn relativa
mlm2 <- lmer(Part ~ 1 + P.Ingr + Ingr + factor(Depen) + factor (Perd) + factor(SueÒos) + Opor + factor(Disc) + Ingr.Com + (1|Comuna), data=pnud, REML=FALSE)
summary(mlm2)
screenreg(mlm2)

#Modelo 3- Modelos con controles
mlm3 <- lmer(Part ~ 1 + P.Ingr + Ingr + factor(Depen) + factor (Perd) + factor(SueÒos) + Opor + factor(Disc) + Ingr.Com + Edad + N.Ed + Mujer + (1|Comuna), data=pnud, REML=FALSE)
summary(mlm3)
screenreg(mlm3)

screenreg(list(mlm0, mlm1, mlm2, mlm3))
