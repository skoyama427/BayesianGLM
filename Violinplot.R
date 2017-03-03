library(rstan)
library(ggplot2)
library(reshape2)
library(gridExtra)

############################
# Function for violin plot #
############################
# Argument BETA(numeric matrix, iteration * celltype): MAP-beta matrix
#          TGTCELL(character vector): Names of celltype, to be plotted



vioPlot <- function(BETA, TGTCELL=FIG2G){
  MBETA <- melt(BETA[,TGTCELL] -1)
  colnames(MBETA) <- c("Cell_type", "beta")
  VIO <- ggplot(MBETA, aes(x=Cell_type, y=beta, fill=Cell_type)) + geom_violin(trim=FALSE) + theme_minimal()
  VIO
}


FIG2G <- c("mEndo", "mPeric", "mMgl", "mRgl2", "mRgl3", "mNProg", "mNbM", "mNbML1", "mRN", "mNbML5", "mDA1", "mDA2", "mGaba2", "mSert", "mOMTN", "mEpen")

V1 <- vioPlot(read.csv2("./OUTPUT/MAP_Cldn5.csv"))
V2 <- vioPlot(read.csv2("./OUTPUT/MAP_Cd248.csv"))
V3 <- vioPlot(read.csv2("./OUTPUT/MAP_Ccl4.csv"))
grid.arrange(V1, V2, V3, row=1)
