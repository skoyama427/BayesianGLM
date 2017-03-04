library(rstan)
library(ggplot2)
library(reshape2)

############################
# Function for violin plot #
############################
# Argument BETA(numeric matrix, iteration * celltype): MAP-beta matrix
#          TGTCELL(character vector): Names of target cell type, to be plotted

ViolinPlot <- function(TGTGENE, TGTCELL){
  MAP <- c()
  for(i in 1:length(TGTGENE)){
    Gene <- TGTGENE[i] 
    INFILE <- paste0("./OUTPUT/MAP_", Gene, ".csv", collapse="")
    BETA <- (read.csv2(INFILE) - 1)[,TGTCELL]
    TMP <- cbind(Gene, melt(BETA))
    MAP <- rbind(MAP, TMP)
  }
  colnames(MAP) <- c("Gene", "Cell_type", "beta")
  VIO <- ggplot(MAP, aes(x=Cell_type, y=beta, fill=Cell_type)) + geom_violin(trim=FALSE) + facet_grid(Gene~., scales="free")
  VIO
}


