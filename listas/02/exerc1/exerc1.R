############################## part 1 ############################## 

# row hi
tempHi <- c(41.2,44.8,53.9,64.5,73.9,82.7,87.2,85.1,78.2,67.0,56.3,46.0)

# label hi
months <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
names(tempHi) <- months

print(tempHi)


# row lo
tempLo <- c(23.5,26.1,33.6,42.0,51.8,60.8,65.8,63.9,56.6,43.7,34.7,27.3)

# label lo
months <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
names(tempLo) <- months

print(tempLo)


############################## part 2 ############################## 

#avgTempSJC <- c(22.2,22.4,21.6,19.6,17,16.1,15.6,17.1,18.8,19.4,20.3,21.4)
avgTempSJC <- c(22.2,22.4,21.6,19.6,17,NA,15.6,17.1,18.8,NA,20.3,21.4)
names(avgTempSJC) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")

print(avgTempSJC)


descTempSJC <- vector(length = length(avgTempSJC))
descTempSJC[avgTempSJC>20] <- 'Hot' 
descTempSJC[avgTempSJC<18] <- 'Cool' 
descTempSJC[(avgTempSJC >= 18) & (avgTempSJC <= 20)] <- 'Mild'

print(descTempSJC)

# Se colocar NA no vetor, o fator referente a este valor fica "FALSE"


############################## part 3 ############################## 

maxTempSJC <- c(29.7,30.1,29.5,27.3,25.1,24.3,24.1,26.2,27.2,27.3,28,28.7)
avgTempSJC <- c(22.2,22.4,21.6,19.6,17,16.1,15.6,17.1,18.8,19.4,20.3,21.4)
minTempSJC <- c(16.2,16.5,15.7,13.2,10.1,8.9,8.2,9.9,11.9,13.4,14.2,15.3)
months <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
sjcTemps <- data.frame(Max=maxTempSJC,Avg=avgTempSJC,Min=minTempSJC,row.names = months)

print(sjcTemps)

summary(sjcTemps)


# Este nao funciona, porque precisa passar o indice, nao a categorizacao
#sjcTemps["Jan":"Jul",c(1,3)]
# Este eh o comando correto
sjcTemps[1:6,c(1,3)]


############################## part 4 ############################## 

sjcTemps3 <- sjcTemps

sjcTemps3["Jul",] <- 0
sjcTemps3[,"Avg"] <- 0
sjcTemps3["Aug",] <- c(1,2,3)
sjcTemps3["Jul",] <- sjcTemps3["Jul",]+c(3,4)
sjcTemps3["Dec","Max"] <- 50

print("Temps")
print(sjcTemps)

print("Temps3")
print(sjcTemps3)

# Nao podemos usar este comando porque estamos inserindo uma lista
# de 2 elementos dentro de uma de 3 elementos
# sjcTemps3["Jul",]	<-	c(3,4)

# Este comando eh possivel usar por conta da regra da reciclagem
#sjcTemps3["Jul",] <- sjcTemps3["Jul",]+c(3,4)


############################## part 5 ############################## 

vetor1 <- c(5, 8, 10, 3, 17, 20, 7)
vetor2 <- c(5, 8, 10, 3, 17)
sum = vetor1 + vetor2

print(sum)

vetor1 <- c(10, 3, 17, 5, 20, 4, 3, 7)
vetor2 <- c(5, 8, 3, 17)
sum = vetor1 + vetor2

print(sum)


vetor1 <- c(10, 3, 17, 5, 20, 4, 5, 8, 3, 17, 3, 7)
vetor2 <- c(5)
sum = vetor1 + vetor2

print(sum)


############################## part 6 ############################## 

# stringsAsFactors=FALSE faz com que as strings do arquivo CSV NAO se tornem factors
# ficando como string
# Nos fazemos isso porque se transformar a string em factor, ela recebera uma 
# numeracao dada a partir da ordem alfabetica, mudando a ordem dos rotulos colocados













