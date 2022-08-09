# rtemis requires R v4.1
# this script last tested on R 4.2.0 and rtemis 0.92.0

# install packages
library(devtools)
remotes::install_github("egenn/rtemis") #user prompted for input
library(rtemis)
packageVersion("rtemis")

list.of.packages <- c("data.table", "future", "gbm", "glmnet", "plyr", "ranger",
                      "DiagrammeR", "rpart", "data.tree", "pbapply")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
new.packages
if(length(new.packages)) install.packages(new.packages)

# load data
parkinsons <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/parkinsons/parkinsons.data")
parkinsons$Status <- factor(parkinsons$status, levels = c(1, 0))
parkinsons$status <- NULL
parkinsons$name <- NULL
checkData(parkinsons)

# train an Additive Tree model on the full sample
parkinsons.addtree <- s_ADDTREE(parkinsons, gamma = .8, learning.rate = .1)

# plot the tree
dplot3_addtree(parkinsons.addtree)

# explore in console
parkinsons.addtree$mod$addtree.pruned
print(parkinsons.addtree$mod$addtree.pruned, "Estimate")
predict(parkinsons.addtree)

# build tree with train and test data
res <- resample(parkinsons, n.resamples = 10, resampler = "kfold", verbose = TRUE)
parkinsons.train <- parkinsons[res$Fold_1, ]
parkinsons.test <- parkinsons[-res$Fold_1, ]
parkinsons.addtree <- s_ADDTREE(parkinsons.train, x.test = parkinsons.test,
                                gamma = .8, learning.rate = .1)

# build with hyperparameter tuning
parkinsons.addtree.tune <- s_ADDTREE(parkinsons.train, x.test = parkinsons.test,
                                     gamma = seq(.6, .9, .1), learning.rate = .1)

# define tuning resampling parameters
parkinsons.addtree.tune <- s_ADDTREE(parkinsons.train, parkinsons.test,
                                     gamma = seq(.6, .9, .1), 
                                     learning.rate = .1,
                                     grid.resampler.rtset = rtset.resample(resampler = 'strat.boot',
                                                                           n.resamples = 5))

# nested resampling for cross-validation and hyperparameter tuning
# this takes a while so commenting out
# parkinsons.addtree.10fold <- elevate(parkinsons, mod = 'addtree', 
#                                      gamma = c(.8, .9), 
#                                      learning.rate = c(.01, .05),
#                                      seed = 2018)
# 
# parkinsons.addtree.10fold

