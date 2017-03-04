## BayesianGLM
R-translation of bayesian estimation with MCMC in [La Manno et al.(Cell,2016)](http://linnarssonlab.org/publications/2016/10/06/midbrain/)  
Easy to understand example of MCMC is [here](http://www.bewersdorff-online.de/amonopoly)

### How to use
#### Installation
Clone or download repository and make OUTPUT and DATA directory.  
Download datafiles(.cef) to /DATA from [the authors repository](https://github.com/linnarsson-lab/ipynb-lamanno2016/tree/master/data).  
Note: If you use UNIX, these procedure are automated in init.sh.

#### Package Requirement
Rstan, ggplot2, pipeR, foreach

Option for parallelization
doParallel

### Execution
Run "runGLM.R"  
You can modify DATASET/GENESET/CELLTYPESET in the script to create your own plot.

