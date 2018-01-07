#### Experiment II Market I  ####
# Upload data experiment I - Market I
experimentII.marketI <- read.csv( file=file.choose() )
View(experimentII.marketI)  # se verifica normalidad por medio de histogramas
# Hallar media de las ventas for each strategy #
mean(experimentII.marketI$Random.grow)
mean(experimentII.marketI$Density.grow)
mean(experimentII.marketI$Referred.grow)
mean(experimentII.marketI$mix.grow)
# Look for standard desviation #
sd(experimentII.marketI$Random.grow)
sd(experimentII.marketI$Density.grow)
sd(experimentII.marketI$Referred.grow)
sd(experimentII.marketI$mix.grow)
# Kruskal.Test # 
kruskal.test(experimentII.marketI$Random.grow)

#### Experiment II Market II  ####
# Upload data experiment I - Market I
experimentII.marketII <- read.csv( file=file.choose() )
View(experimentII.marketII)  # se verifica normalidad por medio de histogramas
# Hallar media de las ventas for each strategy #
mean(experimentII.marketII$Random.grow)
mean(experimentII.marketII$Density.grow)
mean(experimentII.marketII$Referred.grow)
mean(experimentII.marketII$Mix.grow)
# Look for standard desviation #
sd(experimentII.marketII$Random.grow)
sd(experimentII.marketII$Density.grow)
sd(experimentII.marketII$Referred.grow)
sd(experimentII.marketII$Mix.grow)
# Kruskal.Test # 
kruskal.test(experimentII.marketII)

#### Experiment II Market III  ####
# Upload data experiment I - Market I
experimentII.marketIII <- read.csv( file=file.choose() )
View(experimentII.marketIII)  # se verifica normalidad por medio de histogramas
# Hallar media de las ventas for each strategy #
mean(experimentII.marketIII$Random.grow)
mean(experimentII.marketIII$Density.grow)
mean(experimentII.marketIII$Referred.grow)
mean(experimentII.marketIII$Mix.grow)
# Look for standard desviation #
sd(experimentII.marketIII$Random.grow)
sd(experimentII.marketIII$Density.grow)
sd(experimentII.marketIII$Referred.grow)
sd(experimentII.marketIII$Mix.grow)
# Kruskal.Test # 
kruskal.test(experimentII.marketIII)  # Maybe experimentII.marketIII$X <- NULL

###  Tamhane test ### We couldn`t find it in r ####

### Boxplot ####
boxplot(c(experimentII.marketI, experimentII.marketII,experimentII.marketIII),
        las=2, par(mar = c(12, 5, 4, 2)+ 0.1 ,
        at=c(1,2,3,4, 6,7,8,9, 11,12,13,14),names=c("Random-grow","Density-grow","Referred-grow","Mix-grow","Random-grow","Density-grow","Referred-grow","Mix-grow","Random-grow","Density-grow","Referred-grow","Mix-grow"),
        main="Summary of strategies", ylab="Total Market Sales", xlab="" , col=c("turquoise","tomato","darkgreen","yellow"))

