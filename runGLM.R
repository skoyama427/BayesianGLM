source("src/Ceftools.R")
source("src/BayesianGLM.R")
source("src/Violinplot.R")

#######################
### Reproduce Fig2G ###
#######################

DATASET <- "DATA/Mouse_Embryo_fulldataset.cef"
CELL_FIG2G <- c("mEndo", "mPeric", "mMgl", "mRgl2", "mRgl3", "mNProg", "mNbM", "mNbML1", "mRN", "mNbML5", "mDA1", "mDA2", "mGaba2", "mSert", "mOMTN")
GENE_FIG2G <- c("Cldn5","Cd248", "Ccl4", "Ntn1", "Tnc", "Hmgb2", "Neurod1", "Nkx6-2", "Pou4f1", "Gata3", "Th", "Aldh1a1", "Meis2", "Slc6a4", "Isl1")

BayesianGLM(DATASET, GENE_FIG2G)
ViolinPlot(GENE_FIG2G, CELL_FIG2G)



#######################
### Reproduce Fig2F ###
#######################

DATASET <- "DATA/Human_Embryo_fulldataset.cef"
GENE_FIG2F <- c("CLDN5","CD248", "CCL4", "NTN1", "TNC", "HMGB2", "NEUROD1", "NKX6-2", "POU4F1", "GATA3", "TH", "ALDH1A1", "MEIS2", "SLC6A4", "ISL1") 
CELL_FIG2F <- c("hEndo", "hPeric", "hMgl", "hRgl2a", "hProgFPM", "hNbM", "hNbML1", "hRN", "hNbML5", "hDA1", "hDA2", "hNbGaba", "hSert", "hOMTN")

#Caluculation of MAP(Data will be output in /OUTPUT directory)
BayesianGLM(DATASET, GENE_FIG2F)

#Violinplot for GENE/CELL type
ViolinPlot(GENE_FIG2F, CELL_FIG2F)


