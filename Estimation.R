library(pipeR)
library(rstan)
library(foreach)
library(doParallel)

source("Ceftools.R")

################
# Loading Data #
################

CEF <- readCEF("DATA/Mouse_Embryo_fulldataset.cef")
READCNT <- CEF$Readcount
CELLTYP <- CEF$Cell_type

CELLTYP[CELLTYP=="mEpen"] <- "mEpend"

CELLLEG <- sort(unique(CELLTYP))
MOLECNT <- apply(READCNT, 2, sum)

##########################################################
# Calculation the sizefactor vector (Cell length vector) #
##########################################################

FACTORS <- list()

for(i in 1:length(CELLLEG)){
  TMP <- apply(READCNT[, which(CELLTYP==CELLLEG[i], )], 2, sum)
  FACTORS[i] <- mean(TMP)
}
FACTORS <- unlist(FACTORS)
names(FACTORS) <- CELLLEG
SIZFACT <- MOLECNT/FACTORS[CELLTYP]

################################################
# Create design matrix X(Cell*Celltype matrix) #
################################################

X0 <- matrix(0, nrow=length(CELLTYP), ncol=length(CELLLEG))

for(i in 1:length(CELLLEG)){
  X0[CELLTYP==CELLLEG[i], i] <- 1
}
colnames(X0) <- CELLLEG

############
# Run MCMC #
############

#Try to recapitulate Figure 2G for Mousedataset

X <- cbind(Sz=SIZFACT, X0)
TGT <- c("Cldn5", "Cd248", "Ccl4", "Ntn1", "Tnc", "Hmgb2", "Neurod1", "Nkx6-2", "Pou4f1", "Gata3", "Th", "Aldh1a1", "Meis2", "Slc6a4", "Isl1")
TGTGENE <- which(!is.na(match(rownames(READCNT), TGT)))
# If you want whole results, please uncomment below, however, it takes several days.
# TGTGENE <- 1:nrow(READCNT)

# Compile Stan model
sm <- stan_model(file="BayesianGLM.stan")


# Parallel computation for each gene
cl <- makeCluster(detectCores())

  registerDoParallel(cl)

  foreach(i=TGTGENE, .packages="rstan") %dopar% {

    GENNAME <- rownames(READCNT)[i]
    Y <- READCNT[i,]

    DATA <- list(Y=Y, X=X, N=length(Y), K=ncol(X))

    OUT <- sampling(sm, data=DATA, iter=1000, chains=2)
    BETA <- extract(OUT)$beta
    colnames(BETA) <- colnames(X)
    OUTRDS <- paste0("MAP/MAP_", GENNAME, ".RDS", collapse="")
    saveRDS(BETA, OUTRDS) 
    OUTCSV <- paste0("MAP/MAP_", GENNAME, ".csv", collapse="")
    write.csv2(BETA, OUTCSV)

  }

stopCluster(cl)
