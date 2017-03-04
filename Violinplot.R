library(rstan)
library(ggplot2)
library(reshape2)

############################
# Function for violin plot #
############################
# Argument BETA(numeric matrix, iteration * celltype): MAP-beta matrix
#          TGTCELL(character vector): Names of celltype, to be plotted

vioPlot <- function(BETA, TGTCELL=FIG2G){
  MBETA <- melt(log2(BETA[,TGTCELL]) -1)
  colnames(MBETA) <- c("Cell_type", "beta")
  VIO <- ggplot(MBETA, aes(x=Cell_type, y=beta, fill=Cell_type)) + geom_violin(trim=FALSE) + theme_minimal()
  VIO
}


FIG2G <- c("mEndo", "mPeric", "mMgl", "mRgl2", "mRgl3", "mNProg", "mNbM", "mNbML1", "mRN", "mNbML5", "mDA1", "mDA2", "mGaba2", "mSert", "mOMTN", "mEpen")

vioPlot(read.csv2("./OUTPUT/MAP_Cldn5.csv"))
vioPlot(read.csv2("./OUTPUT/MAP_Cd248.csv"))
vioPlot(read.csv2("./OUTPUT/MAP_Ccl4.csv"))

