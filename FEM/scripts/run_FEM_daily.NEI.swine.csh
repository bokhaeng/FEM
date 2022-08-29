#!/bin/csh -f

# FEM inputs

setenv BASEDIR /usr/home/FEM/

setenv case 2020
setenv ANIMAL_TYPE swine
setenv ANIMAL_COUNTS $BASEDIR/data/activity_data/swine_pop.${case}.txt

setenv COUNTY $BASEDIR/data/activity_data/state_county.${ANIMAL_TYPE}.${case}.txt
setenv FARM_CONFIG $BASEDIR/data/activity_data/farm_prob.${ANIMAL_TYPE}.${case}.txt
setenv PARAMETERS $BASEDIR/data/params/tuned_params.${ANIMAL_TYPE}.NEI.txt

# Meteorology inputs
setenv TEPERATURE $BASEDIR/data/climate/TPRO_DAY_FEM_TEMP2_county_2020.txt
setenv WIND_SPEED $BASEDIR/data/climate/TPRO_DAY_FEM_WSPD10_county_2020.txt
setenv PRECIPITATION $BASEDIR/data/climate/TPRO_DAY_FEM_Precip_county_2020.csv

# FEM output files
setenv PARAM_DEFAULT $BASEDIR/data/params/default_params.txt  # DO NOT Change this variable (CLIMATE)
setenv CLIMATE $BASEDIR/data/climate/climate.txt              # DO NOT Change this variable (CLIMATE)
setenv ANIMPOP $BASEDIR/data/activity_data/animal_pop.txt     # DO NOT Change this variable (ANIMPOP)

setenv FARM_ANN_OUTPUT $BASEDIR/results/FEM_${case}.${ANIMAL_TYPE}.annual.txt
setenv FARM_MON_OUTPUT $BASEDIR/results/FEM_${case}.${ANIMAL_TYPE}.monthly.txt
setenv FARM_DAY_OUTPUT $BASEDIR/results/FEM_${case}.${ANIMAL_TYPE}.daily.txt

$BASEDIR/source/FEM_daily.out

