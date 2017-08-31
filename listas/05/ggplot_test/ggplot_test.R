# imports
library(ggplot2)  # graphs
library(vioplot)
library(xtable)
library(sqldf)

# set of data
library(datasets)




#####################################################################################################
# groups
#####################################################################################################

# default is 1000
#options(max.print=600000)


str(anscombe)

# Let's reorg them into four data frames:
anscombe1 <- data.frame(anscombe$x1,anscombe$y1)
names(anscombe1) <- c("x","y")
anscombe2 <- data.frame(anscombe$x2,anscombe$y2)
names(anscombe2) <- c("x","y")
anscombe3 <- data.frame(anscombe$x3,anscombe$y3)
names(anscombe3) <- c("x","y")
anscombe4 <- data.frame(anscombe$x4,anscombe$y4)
names(anscombe4) <- c("x","y")

anscombe1["group"] = 1
anscombe2["group"] = 2
anscombe3["group"] = 3
anscombe4["group"] = 4

tudo = rbind(anscombe1, anscombe2, anscombe3, anscombe4)
tudo

ggplot(tudo, aes(x = x, y = y))+
  geom_point()+
  geom_smooth(method = "lm",colour = 'red')+
  facet_wrap(~group)


#####################################################################################################
# rafael's code - http://www.lac.inpe.br/~rafael.santos/Docs/R/CAP386/IntroEDA-CovType.html
#####################################################################################################

covtype <- read.csv(file="files/covtype.data", header=FALSE, sep=",", stringsAsFactors=FALSE)
head(covtype, n=2)

# fixing data

# "Fixed" attributes' names
names <- c("Elevation","Aspect","Slope","HorDistToHydro","VertDistToHydro",
           "HorDistRoad","Hillshade09","Hillshade12","Hillshade15",
           "HorDistFire")
# Four binary attributes for wilderness areas:
names <- c(names,"WA_RWA","WA_NWA","WA_CPWA","WA_CLPWA")
# 40 (!) binary attributes for soil types:
#names <- c(names,sprintf("ST%02d",1:40))
names <- c(names,sprintf("%d",1:40))
# The cover type
names <- c(names,"Class")
# Assign these names to the attributes
names(covtype) <- names
# Let's also assign labels to the coverage types.
covtype$Class <- as.factor(covtype$Class)
levels(covtype$Class) <- c("Spruce/Fir", "Lodgepole Pine",
                           "Ponderosa Pine","Cottonwood/Willow","Aspen",
                           "Douglas-fir","Krummholz")
# How does it looks like?
str(covtype)



countWA <- covtype$WA_RWA + covtype$WA_NWA + covtype$WA_CPWA + covtype$WA_CLPWA
paste(min(countWA),max(countWA))

str(covtype)


#soilT <- sprintf("ST%02d",1:40)
soilT <- sprintf("%d",1:40)
countST <- rowSums(covtype[,soilT])
paste(min(countST),max(countST))


# Which are the columns we want to consider?
searchOn <- c("WA_RWA","WA_NWA","WA_CPWA","WA_CLPWA")
# Get the index of each WA_
indexOfWA <- apply(covtype[,searchOn], 1, function(x) which(x == 1))
# Convert it to a factor with the column names we used.
factorOfWA <- factor(indexOfWA,labels = searchOn)
# Add it to the data frame
covtype$WildArea <- factorOfWA
# Drop the binary variables we don't need anymore
covtype[searchOn] <- list(NULL)


# Which are the columns we want to consider?
#searchOn <- sprintf("ST%02d",1:40)
searchOn <- sprintf("%d",1:40)
searchOn


# Get the index of 1 in ST01..ST40
indexOfST <- apply(covtype[,searchOn], 1, function(x) which(x == 1))
# Convert it to a factor with the column names we used.
factorOfST <- factor(indexOfST,labels = searchOn)
# Add it to the data frame
covtype$SoilType <- factorOfST
# Drop the binary variables we don't need anymore
covtype[searchOn] <- list(NULL)
str(covtype)


# see data

summary(covtype)


# Let's save it just in case!
save(covtype,file="files/covtype2.R")


par(mfrow=c(1,3),mar=c(6,3,2,1))
boxplot(covtype$Elevation, main="Elevation",las=2)
boxplot(covtype$Slope, main="Slope",las=2)
boxplot(covtype$HorDistFire, main="Hor.Dist.Fire",las=2)


par(mfrow=c(1,3),mar=c(6,3,2,1))
boxplot(covtype$HorDistToHydro, main="Hor.Dist.Hydro",las=2)
boxplot(covtype$VertDistToHydro, main="Vert.Dist.Hydro",las=2)
boxplot(covtype$HorDistRoad, main="Hor.Dist.Road",las=2)


#library(vioplot)

vioplot(covtype$HorDistToHydro,covtype$HorDistRoad,covtype$HorDistFire,
        names=c("Hor.Dist.Hydro","Hor.Dist.Road","Hor.Dist.Fire"),
        col="yellow")


#library(xtable)

tabSW <- table(covtype$SoilType,covtype$WildArea)
print(xtable(tabSW), type="html")


tabCW <- table(covtype$Class,covtype$WildArea)
print(xtable(tabCW), type="html")


colfunc <- colorRampPalette(c("red", "yellow","green","cyan","blue","magenta"))
mosaicplot(t(tabSW),main="Soil Type x Wilderness Area",
           ylab="Soil Type",xlab="Wilderness Area",col=colfunc(nlevels(covtype$SoilType)))


mosaicplot(t(tabCW),main="Class x Wilderness Area",
           ylab="Class",xlab="Wilderness Area",col=colfunc(nlevels(covtype$Class)))



#####################################################################################################
# intersecting
#####################################################################################################

#write.csv(covtype, file = "files/covtype_test.csv")

description <- read.csv(file="files/description.csv", header=FALSE, sep=",", stringsAsFactors=FALSE)

names <- c("study_code", "usfs_elu_code", "description")
names(description) <- names

# convert factor in numeric, to can use it in SQL code
covtype$SoilType = as.numeric(as.character(covtype$SoilType))

str(covtype)
str(description)


# using SQL, do a join between covtype and description
covtype_and_description = sqldf("select * from covtype ct, description d where ct.SoilType = d.study_code")

# convert to factor again...
covtype_and_description$SoilType <- as.factor(covtype_and_description$SoilType)

# now I don't need the study_code anymore, so I can remove it
covtype_and_description$study_code <- NULL

str(covtype_and_description)


# Let's save it just in case!
save(covtype_and_description, file="files/covtype_and_description.R")









