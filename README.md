## BayesianGLM
Bayesian generalized linear regression model for estimation of cell-specific gene expression in R and Rstan.[La Manno et al.(Cell,2016)](http://linnarssonlab.org/publications/2016/10/06/midbrain/)  
Easy to understand example of MCMC is [here](http://www.bewersdorff-online.de/amonopoly)

### How to use
#### Installation
1. Clone or download repository and make OUTPUT and DATA directory in the repository directory.  
2. Download datafiles(.cef) to DATA directory from [the authors repository](https://github.com/linnarsson-lab/ipynb-lamanno2016/tree/master/data).  
Note: If you use UNIX, these procedure are automated in init.sh.

#### Package Requirement
Rstan, ggplot2, pipeR, foreach. reshape2

Option for parallelization
doParallel

### Execution
Run "runGLM.R"  
You can modify DATASET/GENESET/CELLTYPESET in the script to create your own plot.

