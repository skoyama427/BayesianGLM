EXT_NAM <- function(X) {
  tmp <- sub("MAP_", "", X)
  return(sub(".csv", "", tmp))
}

INFILES <- list.files("OUTPUT/")
CSVS <- INFILES[grep(".csv", INFILES)]
REF <- read.table("../../KI_COURSE2017/data/Mouse_medians.tsv")
setwd("OUTPUT")

CORS <- c()
png("pairwiseplot.png")
par(mfrow=c(3,3))
for(i in CSVS){
  TGT <- EXT_NAM(i)
  CSV <- read.csv2(i) - 1
  P_MED <- REF[TGT,]
  R_MED <- apply(CSV, 2, median)[names(P_MED)]
  CORS <- cor.test(as.numeric(P_MED), as.numeric(R_MED))$estimate
  if(which(CSVS==i) < 10)
    plot(log(as.numeric(P_MED)), log(as.numeric(R_MED)), main=paste(TGT,"R=",round(CORS, digit=5)), xlab="log2 beta in original", ylab="log2 beta by Rstan")
}
dev.off()
