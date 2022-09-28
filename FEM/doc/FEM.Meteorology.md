# Meteorology inputs for FEM

One of the enhancements made to the FEM for the 2020 NEI of livestock waste is re-designing the system to adopt spatially and temporally enhanced local meteorology for the NH3 emission factor estimates. A limited small number of meteorological observations without standard identifiers (WBAN ID) were used for 2014 NEI FEM simulations. In fact, the 2014 and 2017 FEM simulations used a single monthly average value for wind speed, ambient temperature, and precipitation. The FEM interpolated this monthly average value to hourly using different techniques.  For ambient temperature, a standard deviation was used to raise and lower the mean temperature in the month.  For wind speed, the average monthly value was used for all hours.  For precipitation, monthly amounts were divided into days (and hours) based upon a parameter defining the frequency of rain in a month.  All of these interpolations carry uncertainty.

To enhance the spatiotemporal quality of 2020 NEI, one of the SMOKE (Spare Matrix Operator Kerner Emission) utility programs, called **GenTPro** (**Gen**erating **T**emporal **Pro**files) was updated to generate county-level daily average meteorological inputs for FEM based on the gridded hourly meteorology data from Meteorology-Chemistry Interface Processor (MCIP) model simulations over the U.S. Utilizing the MCIP hourly meteorology for FEM simulation allows us to enhance the spatial and temporal representations of meteorology on NH3 emissions from the agricultural livestock sector. **GenTPro** can generate the spatially and temporally resolved county-level daily average meteorology inputs (e.g., temperatures, wind speed, and precipitation) for use in generating daily FEM simulations over 3,100 counties in the U.S. The FEM is updated to accommodate these newly designed county-level daily average meteorological data. The format of meteorology data for FEM is shown in Table 2.

### Table 2. Format of county-specific daily average meteorological variables.
| Column | Variable Name | Type | Description |
| :------------ |:-------- |:-------------------|:-------|
|A	|FIPS| 	5 strings|	County, State and County code [ex: 37001]
|B	|Month|	Integer|	Calendar Month [ex: 1, 2,,,,12]|
||	Day 1	|Real|	Average meteorology for Day 1|
||	Day 2	|Real|	Average meteorology for Day 2|
||	…	|Real|	Average meteorology for Day…|
||	Day N|	Real|	Average meteorology for Day N|
