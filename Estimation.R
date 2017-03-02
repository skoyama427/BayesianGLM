DAT <- readRDS("../RDS/Mouse_Embryo_fulldataset.RDS")
  EXPR <- DAT$EXPR
  INFO <- DAT$INFO
    CELLTYPE <- INFO$Cell_type
    CELLEG <- names(table(CELLTYPE))
    TOTALMOL <- INFO$Total_Molecules
    NORMALIZE <- tapply(TOTALMOL, CELLTYPE, mean)

#Calc Baseline Expression

FACTORS <- list()
for(i in 1:length(CELLEG)){
  TMP <- apply(EXPR[which(CELLTYPE==CELLEG[i], ), ], 1, sum)
  FACTORS[i] <- mean(TMP)
}
FACTORS <- unlist(FACTORS)
names(FACTORS) <- CELLEG

B0 <- c()
for(i in 1:nrow(INFO)){
  TOTMOL <- su(EXPR[i, ])
  FACTOR <- FACTORS[CELLTYPE[i]]
  B0[i] <- TOTMOL/FACTOR
}

#bind Baseline and Gene expression data

X0 <- matrix(0, nrow=nrow(INFO), ncol=length(CELLEG))
for(i in 1:nrow(INFO)){
  for(j in 1:length(CELLEG)){
    if(INFO[i,]$Cell_type == CELLEG[j]){
      X0[i, j] <-  1
    }
  }
}

saveRDS(CELLEG, "./CELLEG.RDS")

library(rstan)
library(foreach)
library(doParallel)

NGENE <- ncol(EXPR)

sm <- stan_model(file="../SCRIPTS/BayesianGLM.stan")

cl <- makeCluster(detectCores())
registerDoParallel(cl)

foreach(i=1:NGENE, .packages="rstan") %dopar% {

  ITERGENE <- colnames(EXPR)[i]
  X <- cbind(B0, X0)
  Y <- EXPR[,ITERGENE]

  DATA <- list(Y=Y, X=X, N=length(Y), K=ncol(X))
  OUT <- sampling(sm, data=DATA, iter=1000, chains=2)
  EXT <- extract(OUT)

  OUTFILE <- paste0("../RDS/MAP/MAP_", ITERGENE, ".RDS", collapse="")
  saveRDS(EXT, OUTFILE) 
}

stopCluster(cl)
