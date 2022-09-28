# How to Install and Run FEM

## Install FEM

1. Download the latest version of [FEM](https://github.com/bokhaeng/FEM)
2. Compile the source codes using Fortran compilers, such as ifort, pgf90, or gfortran. Note that the current version of Makefile is designed for pgf90 Fortran compiler. Please update the Makefile based on your Fortran compiler.
3. Compile the FEM source codes
```
cd /FEM/source/
make all
```
3. Check the existence of an executable called "**FEM.out**"

Note that the current version of Makefile is designed for pgf90 Fortran compiler. Please update the Makefile based on your Fortran compiler.


## The list of variables for the FEM run script:
To check the list of variables for inputs, output, and run configurations, please oo to the FEM run script folder located at: /FEM/scripts and check out the following FEM operational variables:

1. **BASEDIR**: Define the location of FEM home folder
2. **CASE**: Define the case name for FEM simulation
3. **ANIMAL_TYPE**: Define the animal type (e.g., beef, swine, dairy, layer, or broiler)
4. **ANIMAL_COUNTS**: Define the location of county-level animal counts input file
5. **COUNTY**: Define the location of the county input file that holds the list of counties targeted in this FEM simulation
6. **FARM_CONFIG**: Define the location of county-level farm manure management practices input file
7. **PARAMETERS**: Define the location of FEM model parameters input file
8. **TEPERATURE**: Define the location of county-level daily average temperature input file
9. **WIND_SPEED**: Define the location of county-level daily average wind speed input file
10. **PRECIPITATION**: Define the location of county-level daily total precipitation input file
11. **FARM_ANN_OUTPUT**: Define the filename and location of annual total NH3 emissions  
12. **FARM_MON_OUTPUT**: Define the filename and location of monthly total NH3 emissions
14. **FARM_DAY_OUTPUT**: Define the filename and location of daily total NH3 emissions

## Run FEM:
Invoke animal-secific FEM run scripts to run the FEM simulation


```
cd /FEM/scripts
run_FEM_daiily_NEI.${animal}.csh
```

Once the FEM run is complete, please check the log file as well as the output files located at

```
cd /FEM/results
```
