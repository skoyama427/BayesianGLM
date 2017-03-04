library(pipeR)
library(rstan)
library(foreach)
library(doParallel)


BayesianGLM <- function(DATASET, TGTGENE, parallel=T){

  stanmodel <- "

    data {
      int<lower=0> N;
      int<lower=0> K;
      int Y[N];
      matrix<lower=0>[N,K] X;
    }

    parameters{
      vector<lower=1>[K] beta;
      real<lower=0.001> r;
    }

    model {
        vector[N] mu;
        vector[N] rv;
        
        r ~ cauchy(0, 1);
        beta ~ pareto(1, 1.5);
        
        for (n in 1:N){
            rv[n] = square(r+1) -1;
        }
        
        mu = X * (beta - 1) + 0.001;
        Y ~ neg_binomial(mu ./ rv, 1 / rv[1]);
    }
  " 

  ################
  # Loading Data #
  ################

  CEF <- readCEF(DATASET)
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
  TGT <- which(!is.na(match(rownames(READCNT), TGTGENE)))

  # Compile Stan model

  sm <- stan_model(model_code = stanmodel)


  # Parallel computation for each gene

  if(parallel==T){

    cl <- makeCluster(detectCores())

      registerDoParallel(cl)

      foreach(i=TGT, .packages="rstan") %dopar% {

        GENNAME <- rownames(READCNT)[i]
        Y <- READCNT[i,]

        DATA <- list(Y=Y, X=X, N=length(Y), K=ncol(X))

        OUT <- sampling(sm, data=DATA, iter=1000, chains=2)
        BETA <- extract(OUT)$beta
        colnames(BETA) <- colnames(X)
        OUTCSV <- paste0("OUTPUT/MAP_", GENNAME, ".csv", collapse="")
        write.csv2(BETA, OUTCSV)

      }

    stopCluster(cl)

  } else {

  # In case of not working parallelization. specify parallel=F
    
    foreach(i=TGT, .packages="rstan") %do% {

          GENNAME <- rownames(READCNT)[i]
          Y <- READCNT[i,]

          DATA <- list(Y=Y, X=X, N=length(Y), K=ncol(X))

          OUT <- sampling(sm, data=DATA, iter=1000, chains=2)
          BETA <- extract(OUT)$beta
          colnames(BETA) <- colnames(X)
          OUTCSV <- paste0("OUTPUT/MAP_", GENNAME, ".csv", collapse="")
          write.csv2(BETA, OUTCSV)

    }

  }

}
