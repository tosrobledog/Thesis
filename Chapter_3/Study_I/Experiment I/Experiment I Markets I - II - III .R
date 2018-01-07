#### Experiment I Market I  ####
# Upload data experiment I - Market I
experimentI.marketI <- read.csv( file=file.choose() )
View(experimentI.marketI)  # se verifica normalidad por medio de histogramas
# Hallar media de las ventas
mean(experimentI.marketI$totalmarketsales)

## Stats analysis ##

## TotalMarketsales vs Size linear regression and r-squared

plot(experimentI.marketI$totalmarketsales ~ experimentI.marketI$degree, ann=FALSE)
title("TotalMarketsales vs Size", xlab="Size", ylab="TotalMarketsales")
legend("topright", bty="n", legend=paste("R2 ",
                                         format(summary(lm(experimentI.marketI$totalmarketsales ~ experimentI.marketI$degree, experimentI.marketI))$r.squared, digits=4)))

## TotalMarketsales vs Density
plot(experimentI.marketI$totalmarketsales ~ experimentI.marketI$density, ann=FALSE)
title("TotalMarketsales vs Density", xlab="Density", ylab="TotalMarketsales")
legend("topright", bty="n", legend=paste("R2 ",
                                         format(summary(lm(experimentI.marketI$totalmarketsales ~ experimentI.marketI$density, experimentI.marketI))$r.squared, digits=4)))

#### Experiment I Market II  ####
# Upload data experiment I - Market I
experimentI.marketII <- read.csv( file=file.choose() )
View(experimentI.marketII)  # se verifica normalidad por medio de histogramas
# Hallar media de las ventas
mean(experimentI.marketII$totalmarketsales)

## Stats analysis ##

## TotalMarketsales vs Size linear regression and r-squared

plot(experimentI.marketII$totalmarketsales ~ experimentI.marketII$degree, ann=FALSE)
title("TotalMarketsales vs Size", xlab="Size", ylab="TotalMarketsales")
legend("topright", bty="n", legend=paste("R2 ",
                                         format(summary(lm(experimentI.marketII$totalmarketsales ~ experimentI.marketII$degree, 
                                                           experimentI.marketII))$r.squared, digits=4)))

## TotalMarketsales vs Density
plot(experimentI.marketII$totalmarketsales ~ experimentI.marketII$density, ann=FALSE)
title("TotalMarketsales vs Density", xlab="Density", ylab="TotalMarketsales")
legend("topright", bty="n", legend=paste("R2 ",
                                         format(summary(lm(experimentI.marketII$totalmarketsales ~ experimentI.marketII$density, 
                                                           experimentI.marketII))$r.squared, digits=4)))

#### Experiment I Market II  ####
# Upload data experiment I - Market I
experimentI.marketIII <- read.csv( file=file.choose() )
View(experimentI.marketIII)  # se verifica normalidad por medio de histogramas
# Hallar media de las ventas
mean(experimentI.marketIII$totalmarketsales)

## Stats analysis ##

## TotalMarketsales vs Size linear regression and r-squared

plot(experimentI.marketIII$totalmarketsales ~ experimentI.marketIII$degree, ann=FALSE)
title("TotalMarketsales vs Size", xlab="Size", ylab="TotalMarketsales")
legend("topright", bty="n", legend=paste("R2 ",
                                         format(summary(lm(experimentI.marketIII$totalmarketsales ~ experimentI.marketIII$degree, 
                                                           experimentI.marketIII))$r.squared, digits=4)))

## TotalMarketsales vs Density
plot(experimentI.marketIII$totalmarketsales ~ experimentI.marketIII$density, ann=FALSE)
title("TotalMarketsales vs Density", xlab="Density", ylab="TotalMarketsales")
legend("topright", bty="n", legend=paste("R2 ",
                                         format(summary(lm(experimentI.marketIII$totalmarketsales ~ experimentI.marketIII$density, 
                                                           experimentI.marketIII))$r.squared, digits=4)))