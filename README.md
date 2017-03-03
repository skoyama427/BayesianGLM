## BayesianGLM
R-translation of bayesian estimation with MCMC in [La Manno et al.(Cell,2016)](http://linnarssonlab.org/publications/2016/10/06/midbrain/)  
Easy to understand example of MCMC is [here](http://www.bewersdorff-online.de/amonopoly)

### How to use
#### Installation
Clone or download repository and make OUTPUT and DATA directory.  
Download datafiles(.cef) to /DATA from [the authors repository](https://github.com/linnarsson-lab/ipynb-lamanno2016/tree/master/data).  
Note: If you use UNIX, these procedure are automated in init.sh.

#### Package Requirement
Rstan, pipeR, ggplot2, foreach, doParallel

### Execution
#### Run MCMC
Run Estimation.R with some modification.  
As a default, you can obtain maximum posterior estimation for Fig2G.
#### Draw violinplot
Run violinplot.R


