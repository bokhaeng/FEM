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

- **BASEDIR**: Define the location of FEM home folder
- **CASE**: Define the case name for FEM simulation (e.g., NEI)
- **YEAR**: Define the modeling year for FEM simulation (e.g., 2023)
- **COUNTRY**: Define the country name for FEM simulation (e.g., USA)
- **ANIMAL_TYPE**: Define the animal type (e.g., beef, swine, dairy, layer, or broiler)
- **SCC**: Define the SCC for the animal type 
- **ANIMAL_COUNTS**: Define the location of county-level animal counts input file
- **FARM_CONFIG**: Define the location of county-level farm manure management practices input file
- **PARAMETERS**: Define the location of FEM model parameters input file
 **TEPERATURE**: Define the location of county-level daily average temperature input file
- **WIND_SPEED**: Define the location of county-level daily average wind speed input file
- **PRECIPITATION**: Define the location of county-level daily total precipitation input file
- **PARAM_DEFAULT**: Temporary parameter filename
- **CLIMATE**: Temporary climate (temperature+WS+precipitation) filename
- **FARM_ANN_OUTPUT**: Define the filename and location of [SMOKE-ready FF10 ARINV](https://www.cmascenter.org/smoke/documentation/5.0/html/ch06s02s04.html#d0e29824) annual total NH3 emissions 
- **FARM_DAY_OUTPUT**: Define the filename and location of [SMOKE-ready FF10 ARDAY](https://www.cmascenter.org/smoke/documentation/5.0/html/ch06s02s02.html) daily total NH3 emissions

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
