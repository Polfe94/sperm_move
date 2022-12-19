# Sperm motility multivariate analysis: sperm_move
Code for sperm motility multivariate analysis. If you use this code, make sure to cite this repository, as well as Predicting fertility from sperm motility landscapes (https://doi.org/10.1038/s42003-022-03954-0). 

## References (paper)
If you use the code provided in this repository, please make sure to properly cite:

Fernández-López, P., Garriga, J., Casas, I. et al. Predicting fertility from sperm motility landscapes. Commun Biol 5, 1027 (2022). https://doi.org/10.1038/s42003-022-03954-0

Fernández-López, Pol (2022), “Data used in Predicting fertility from sperm motility landscapes”, Mendeley Data, V5, doi: 10.17632/jd38jhxpg6.5

## Dependencies
Before proceeding to use the code, make sure you have installed the following packages (and their corresponding dependencies):

#### R (v4.0.2)
Core scripts:
- rstanarm (v2.21.1)
- bigMap (v4.5.3; 10.5281/zenodo.5506574) 
- dplyr (v1.0.7)
- parallel (v4.0.2)

Plot scripts:
- ggplot2 (v3.3.6)
- bayesplot (v1.9.0)
- reshape2 (v1.4.4)
- shadowtext (v0.1.2)
- gridExtra (v2.3)
- ggpubr (v0.4.0)
- viridis (v0.6.2)
- mixOmics (v6.19.4) optional for the color.jet palette.

Also, follow the instructions in https://github.com/KlugerLab/FIt-SNE to install FIt-SNE (not needed unless you want to get t-SNE embedding by alternative means than those offered in the bigMap R package).

For an UMAP (https://umap-learn.readthedocs.io/en/latest/index.html) based embedding, the code provided in this repository has the following requirements:

#### R (v4.0.2)
- jsonlite (v1.7.1)

#### Python (v3.6.8)
- numpy (v1.18.1)
- umap-learn (v0.4.6)

## How to use
After installing all necessary requirements (see above), five scripts are provided to reproduce the work performed in Fernandez-Lopez, P. et al (2022). Data used in this paper is available in Mendeley data (DOI: 10.17632/jd38jhxpg6.2). If you use the data, please cite the corresponding repository and the related paper. Scripts can be used on other data (motility related or otherwise), altough some adaptations to code might be necessary. After running any of the scripts, make sure to check the paths to load the data and source the code, as well as the path to save the results to. 

### (I) FUNCTIONS.R
This script provides some wrap functions to adapt t-SNE objects to bigMap package, automated modelling using rstanarm, and others. Necessary libraries are also load at the beggining of the script. It is encouraged to source this document before running any other script.

### (II) t-SNE computation
The first step is to compute the t-SNE coordinates. BHtSNE.R and FItSNE.R are ready to run on the sperm.csv dataset (DOI: 10.17632/jd38jhxpg6.2). They can be adapted to run on other datasets. For the capacitated sperm dataset (cap_motdata.csv), please run capacitated_tSNE.R instead.

These scripts return a t-SNE object (or a list of them, if multiple perplexities are used) that can be further explored by bigMap package, both for additional analysis and visualization.

#### UMAP computation
As an alternative, the 2D embedding can be computed using UMAP. Similarly to the previous point, run umap.py using the corresponding data (Xw.csv), and with the resulting embedding, run umap.R to convert the umap object to one compatible with the bigMap package. 

### (III) Bayesian modelling
After a t-SNE (or UMAP) object has been computed (see above), this embedding can be used in models.R. Briefly, this script computes the proportion of sperm of each boar in the landscape's clusters, and uses this data to produce several models. The models are compared by means of leave-one-out crossvalidation in the script, and some basic visualization is provided in the script.

### Plots

#### Plots from "Predicting fertility from sperm motility landscapes"
Download the data in Mendeley Data repository (DOI: 10.17632/jd38jhxpg6.2) and check the scripts in plots folder.

#### Visualization for new models and embeddings
Some basic plots to explore the (t-SNE or UMAP) landscape can be found in landscape_plots.R, that shows how the basic functionality of bigMap package works. In models.R, there is also some visualization regarding to the models' coefficients and predictions. 

### Troubleshooting
If any problem arises, please submit a new issue.
