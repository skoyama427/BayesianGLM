readCEF <- function(INFILE){

  print("extract dataset information...")

  INFO <- list()
  LEG <- read.table(INFILE, nrow=8, fill=T)[,1]
  
  INFO[[1]] <- read.table(INFILE, skip=(which(LEG=="CEF")      -1), nrow=1) %>>% paste0
  INFO[[2]] <- read.table(INFILE, skip=(which(LEG=="Cell_ID")  -1), nrow=1)[-1]
  INFO[[3]] <- read.table(INFILE, skip=(which(LEG=="Cell_type")-1), nrow=1)[-1]
  INFO[[4]] <- read.table(INFILE, skip=(which(LEG=="Timepoint")-1), nrow=1)[-1]

  print("making expression matrix...")

  TMP <- read.table(INFILE, skip=(which(LEG=="Gene")))
  EXPR <- as.matrix(TMP[,-1])
  rownames(EXPR) <- TMP[,1]
  colnames(EXPR) <- INFO[[2]]

  print("make output list for analysis...")

  OUT <- list(CEF             = INFO[[1]],
              Cell_ID         = as.character(INFO[[2]]),
              Cell_type       = as.character(INFO[[3]]),
              Timepoint       = as.character(INFO[[4]]),
              Readcount       = EXPR)

  return(OUT)
}

