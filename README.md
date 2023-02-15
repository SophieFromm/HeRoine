# HeRoine

HeRoine_NAVIGATE comprises task code of the Helicopter Online Reward Learning study.
It is hosted in JATOS (www.jatos.org) and the jzip file can be uploaded directly to JATOS to run the study.

# HeRoine_analysis
... comprises the analysis code. Analysis was done in R.
... contains 3 consecutive files:
1) H1_rawBehav.R: This is the R script to load the data and compute the raw data analyis.
2) H2_H3_Regression.R: This is the R script that uses the model parameters to compute the regression on PLE.
3) Plots_tbu.R: This R script can be used to create the plots.


# HeRoine_data
... comprises the data downloaded from Jatos, cleaned and converted to excel files.
... contains 3 files:
1) HeRoine_data_Rexport.xlsx: This file contains some performance measures, the behavioral data, selfreport data, the factors from the supplementary factor analysis and at the very end the model-based parameters for CPP and RU.
2) HeRoine_master_Rexport.xlsx: This file contains the master structure of the task
3) HeRoine_sums_Rexport.xlsx: This file contains the sum scores of the questionnaires (overlaps with the file "HeRoine_data_Rexport", but needed for the scripts)

Author: Sophie Fromm
