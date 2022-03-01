# sperm_move
Code for sperm motility multivariate analysis. If you use this code, make sure to cite this repository, as well as Predicting fertility from sperm motility landscapes (DOI: ). 

# citation 1 (paper)
# citation 2 (DOI: 10.17632/jd38jhxpg6.2)

## Dependencies
Before proceeding to use the code, make sure you have installed the following packages (and their corresponding dependencies) in R:
rstanarm (v2.21.1)
bigMap (v4.5.3; 10.5281/zenodo.5506574) 
dplyr (v1.0.7)
parallel

Also, follow the instructions in https://github.com/KlugerLab/FIt-SNE to install FIt-SNE (not needed unless you want to get t-SNE embedding by alternative means than those offered in the bigMap R package).

## How to use
After installing all necessary requirements (see above), five scripts are provided to reproduce the work performed in Fernandez-Lopez, P. et al (2022). Data used in this paper is available in Mendeley data (DOI: 10.17632/jd38jhxpg6.2). If you use the data, please cite the corresponding repository and the related paper. Scripts can be used on other data (motility related or otherwise), altough some adaptations to code might be necessary. After running any of the scripts, make sure to check the paths to load the data and source the code. 

### (I) FUNCTIONS.R
This script provides some wrap functions to adapt t-SNE objects to bigMap package, automated modelling using rstanarm, and others. Necessary libraries are also load at the beggining of the script. It is encouraged to source this document before running any other script.

### (II) t-SNE computation
The first step is to compute the t-SNE coordinates. BHtSNE.R and FItSNE.R are ready to run on the sperm.RData dataset (DOI: 10.17632/jd38jhxpg6.2). They can be adapted to run on other datasets. For the capacitated sperm dataset (cap_motdata.RData), please run capacitated_tSNE.R instead.

These scripts return a t-SNE object (or a list of them, if multiple perplexities are used) that can be further explored by bigMap package, both for additional analysis and visualization.

### (III) Bayesian modelling
After a t-SNE object has been computed (see above), this embedding can be used in models.R. Briefly, this script computes the proportion of sperm of each boar in the landscape's clusters, and uses this data to produce several models. The models are compared by means of leave-one-out crossvalidation in the script, and some basic visualization is provided in the script.

### Contact
For any troubleshooting, please contact me at pfernandez@ceab.csic.es.
