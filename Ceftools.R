readCEF <- function(INFILE){

  print("extract dataset information...")

  INFO <- list()
  for(i in 1:3){
    TMP <- read.table(INFILE, skip=i-1, nrow=1)
    INFO[i] <- paste0(TMP, collapse=" ")
  }


  print("extract cell information...")

  for(i in 4:7){
    INFO[[i]] <- unlist(read.table(INFILE, skip=i-1, nrow=1))[-1]
  }


  print("making expression matrix...")

  TMP <- read.table(INFILE, skip=8)
  EXPR <- as.matrix(TMP[,-1])
  rownames(EXPR) <- TMP[,1]
  colnames(EXPR) <- INFO[[4]]


  print("make output list for analysis...")

  OUT <- list(CEF             = INFO[[1]],
              Dataset         = INFO[[2]],
              InfoVersion     = INFO[[3]],
              Cell_ID         = INFO[[4]],
              Cell_type       = INFO[[5]],
              Timepoint       = INFO[[6]],
              Total_Molecules = INFO[[7]],
              Readcount       = EXPR)

  return(OUT)
}

INFILE <- "../../data/Human_Embryo_fulldataset.cef"

OUT <- readCEF(INFILE)

head(OUT[[4]])

OUTd[[4]]
