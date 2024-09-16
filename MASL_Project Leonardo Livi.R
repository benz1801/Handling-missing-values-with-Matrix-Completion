#######PROJECT########

library(softImpute)
library(ggplot2)
library(GGally)
setwd('C:\\Users\\Asus\\Desktop\\Cdlm - Statistica e Data Science\\Multivariate Analysis & Statistical Learning\\Project')
clash <- read.csv('clash_royale_dataset.csv', sep=';',dec=',')

head(clash)
str(clash)

#vars <- names(dati)[c(1:4,6:9,14:16)]
vars <- names(clash)[-c(5,9,10,11,12)]
dati <- clash[,vars]#; rownames(dati) <- dati[,1]; dati<-dati[,-1]

#pairs(dati, panel=panel.smooth, col="#4A7C9C")
ggscatmat(dati)

#Matrix completion

X <- dati[,-1]
X <- data.matrix(scale(X))
pcob <- prcomp(X)
summary(pcob)

# Singular value decomposition
sX <- svd(X)

round(sX$v, 3)
pcob$rotation

#Random missing
nomit <- 107
set.seed(15)
ina <- sample(1:nrow(X),nomit)
inb <- sample(1:ncol(X),nomit,replace = T)
Xna <- X
index.na <- cbind(ina,inb)
Xna[index.na] <- NA
# Algorithm 12.1
# Function that takes a matrix in input and
# returns an approximation to the matrix
# using sdv()

fit.svd <- function(X,M=1){
  svdob <- svd(X)
  with(svdob,
       u[,1:M,drop=FALSE]%*%
         (d[1:M]*t(v[,1:M,drop=FALSE]))
       )
}

# By simulation, we the select the best number of PC in terms of relative error

cicle <- 0
for (i in 1:ncol(X)){
  cicle <- cicle+1
  Xhat <- Xna
  xbar <- colMeans(Xna, na.rm=T)
  Xhat[index.na] <- xbar[inb]
  
  # Measure progress of iterations
  threshold <- 1e-7
  relative_error <- 1
  iter <- 0
  ismiss <- is.na(Xna) # logical matrix nxp, returns T where matrix has NA
  mssold <- mean((scale(Xna,xbar,F)[!ismiss])^2) #mse of non-missing elements of the old version of Xhat
  mss0 <- mean(Xna[!ismiss]^2) #square mean of non-missing elements
  
  # Store mse of current version of Xhat in mss
  # will then iterate step 2 of algorithm untile relative error (mssold-mss)/mss0
  # falls below the threshold
  
  # Step 2
  # (a) We approximate Xhat using fit.svd(), calling this Xapp
  # (b) We use Xapp to update the estimates for elements in Xhat that are missing in Xna
  # (c) Compute the relative error
  
  while(relative_error>threshold){
    iter <- iter+1
    #Step 2(a)
    Xapp <- fit.svd(Xhat,M=i)
    #Step 2(b)
    Xhat[ismiss] <- Xapp[ismiss]
    #Step 2(c)
    mss <- mean(((Xna-Xapp)[!ismiss])^2)
    relative_error <- (mssold-mss)/mss0
    mssold <- mss
    #cat('Iter:', iter, 'MSS:', mss,
    #    'Relative Error:', relative_error, '\n')
  }
  print(paste('M:',cicle,', Cor:',cor(Xapp[ismiss], X[ismiss])))
  
}

# We want to compare matrix completion with M=2 and M=9

##### M=2
# Build Xhat replacing NA with
# each colmeans
Xhat <- Xna
xbar <- colMeans(Xna, na.rm=T)
Xhat[index.na] <- xbar[inb]

# Measure progress of iterations
threshold <- 1e-7
relative_error <- 1
iter <- 0
ismiss <- is.na(Xna) # logical matrix nxp, returns T where matrix has NA

mssold <- mean((scale(Xna,xbar,F)[!ismiss])^2) #mse of non-missing elements of the old version of Xhat
mss0 <- mean(Xna[!ismiss]^2) #square mean of non-missing elements

# Store mse of current version of Xhat in mss
# will then iterate step 2 of algorithm untile relative error (mssold-mss)/mss0
# falls below the threshold

# Step 2
# (a) We approximate Xhat using fit.svd(), calling this Xapp
# (b) We use Xapp to update the estimates for elements in Xhat that are missing in Xna
# (c) Compute the relative error

while(relative_error>threshold){
  iter <- iter+1
  #Step 2(a)
  Xapp <- fit.svd(Xhat,M=2)
  #Step 2(b)
  Xhat[ismiss] <- Xapp[ismiss]
  #Step 2(c)
  mss <- mean(((Xna-Xapp)[!ismiss])^2)
  relative_error <- (mssold-mss)/mss0
  mssold <- mss
  cat('Iter:', iter, 'MSS:', mss,
      'Relative Error:', relative_error, '\n')
}

cor(Xapp[ismiss], X[ismiss])

plot(X[ismiss], Xapp[ismiss], xlab = 'Original values', ylab = 'Imputed values',
     xlim=c(-2.5,2.5),ylim=c(-2.5,2.5), col = as.factor(clash$Rarity), pch=19, main='M=2')
#text(X[ismiss], Xapp[ismiss], labels = rownames(X)[ismiss], pos = 1, col = "blue")
abline(a=0, b=1)
legend('topleft', legend=as.factor(unique(clash$Rarity)), pch=19, col=as.factor(clash$Rarity))

Xnew <- fit.svd(X,M=2)
cor(Xnew[ismiss],X[ismiss])
##### M=9
# Build Xhat replacing NA with
# each colmeans
Xhat <- Xna
xbar <- colMeans(Xna, na.rm=T)
Xhat[index.na] <- xbar[inb]

# Measure progress of iterations
threshold <- 1e-7
relative_error <- 1
iter <- 0
ismiss <- is.na(Xna) # logical matrix nxp, returns T where matrix has NA

mssold <- mean((scale(Xna,xbar,F)[!ismiss])^2) #mse of non-missing elements of the old version of Xhat
mss0 <- mean(Xna[!ismiss]^2) #square mean of non-missing elements

# Store mse of current version of Xhat in mss
# will then iterate step 2 of algorithm untile relative error (mssold-mss)/mss0
# falls below the threshold

# Step 2
# (a) We approximate Xhat using fit.svd(), calling this Xapp
# (b) We use Xapp to update the estimates for elements in Xhat that are missing in Xna
# (c) Compute the relative error

while(relative_error>threshold){
  iter <- iter+1
  #Step 2(a)
  Xapp <- fit.svd(Xhat,M=9)
  #Step 2(b)
  Xhat[ismiss] <- Xapp[ismiss]
  #Step 2(c)
  mss <- mean(((Xna-Xapp)[!ismiss])^2)
  relative_error <- (mssold-mss)/mss0
  mssold <- mss
  cat('Iter:', iter, 'MSS:', mss,
      'Relative Error:', relative_error, '\n')
}

cor(Xapp[ismiss], X[ismiss])

plot(X[ismiss], Xapp[ismiss], xlab = 'Original values', ylab = 'Imputed values',
     xlim=c(-2.5,2.5),ylim=c(-2.5,2.5), col = as.factor(clash$Rarity), pch=19, main='M=9')
#text(X[ismiss], Xapp[ismiss], labels = rownames(X)[ismiss], pos = 1, col = "blue")
abline(a=0, b=1)
legend('topleft', legend=as.factor(unique(clash$Rarity)), pch=19, col=as.factor(clash$Rarity))
#a <- softImpute(Xna, lambda=0, type = 'svd', thresh = 1e-7, trace.it = T)

Xnew <- fit.svd(X,M=9)
cor(Xnew[ismiss],X[ismiss])

