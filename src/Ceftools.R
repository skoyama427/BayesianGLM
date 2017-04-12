readCEF <- function(INFILE){
  require(dplyr)
  require(tibble)
  print("extract dataset information...")
  
  LEG <- read.table(INFILE, nrow=8, fill=T,stringsAsFactors = F)[,1]
  
  #metadata
  TMP.INFO <- read.delim(INFILE,nrows = 8,fill = T,stringsAsFactors = F,header=F) %>% select(-V1) %>% filter(V2 %in% LEG) %>% 
    column_to_rownames("V2") %>% t(.) %>% data.frame(.,stringsAsFactors = F)
  
  CEF.info <- read.table(INFILE, skip=(which(LEG=="CEF")-1), nrow=1) %>% paste0  #CEF
  
  print("making expression matrix...")
  
  TMP <- read.table(INFILE, skip=(which(LEG=="Gene")), stringsAsFactors = F)
  EXPR <- as.matrix(TMP[,-1])
  rownames(EXPR) <- TMP[,1]
  colnames(EXPR) <- TMP.INFO$Cell_ID
  
  print("make output list for analysis...")
  
  OUT <- list(CEF             = CEF.info,
              Cell_ID         = TMP.INFO$Cell_ID,
              Cell_type       = TMP.INFO$Cell_type,
              Timepoint       = TMP.INFO$Timepoint,
              Readcount       = EXPR)
  
  return(OUT)
}


