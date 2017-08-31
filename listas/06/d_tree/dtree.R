# http://www.lac.inpe.br/~rafael.santos/Docs/R/CAP386/IntroML-DecTree2.html

library(C50)

library(datasets)



covtype <- read.csv(file="files/covtype.data", header=FALSE, sep=",", stringsAsFactors=FALSE)

head(covtype, n=2)


rows <- nrow(covtype)
covtype <- covtype[sample(rows,rows/100), ]
str(covtype)


modelCT <- C5.0(Class ~ ., data=covtype, control = C5.0Control(noGlobalPruning = TRUE,minCases=1))
summary(modelCT)

plot(modelCT, main="C5.0 Decision Tree - Unpruned, min=1")








