#!/bin/csh -f

# FEM inputs

setenv BASEDIR /groups/ESS/projects/ess/bbaek/Tools/FEM/FEM_git/FEM

setenv case 2021
setenv YEAR 2021
setenv COUNTRY USA

setenv ANIMAL_TYPE dairy
setenv SCC 2805018000

# FEM inputs
setenv ANIMAL_COUNTS $BASEDIR/data/activity_data/${ANIMAL_TYPE}_pop.${case}.txt
setenv FARM_CONFIG $BASEDIR/data/activity_data/farm_prob.${ANIMAL_TYPE}.${case}.txt
setenv PARAMETERS $BASEDIR/data/params/tuned_params.${ANIMAL_TYPE}.NEI.txt

# Meteorology inputs
setenv TEPERATURE $BASEDIR/data/climate/TPRO_DAY_FEM_TEMP2_county_${case}.txt
setenv WIND_SPEED $BASEDIR/data/climate/TPRO_DAY_FEM_WSPD10_county_${case}.txt
setenv PRECIPITATION $BASEDIR/data/climate/TPRO_DAY_FEM_Precip_county_${case}.csv

# FEM output files
setenv PARAM_DEFAULT $BASEDIR/data/params/default_params.txt  # DO NOT Change this variable (PARAM_DEFAULT)
setenv CLIMATE $BASEDIR/data/climate/climate.txt              # DO NOT Change this variable (CLIMATE)

setenv FARM_ANN_OUTPUT $BASEDIR/results/FEM_${case}.${ANIMAL_TYPE}.annual.txt
setenv FARM_DAY_OUTPUT $BASEDIR/results/FEM_${case}.${ANIMAL_TYPE}.daily.txt

$BASEDIR/source/FEM_daily.out

