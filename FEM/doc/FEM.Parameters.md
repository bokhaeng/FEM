# Model Parameters

The FEM is a mass balance between an empirical approach and a first-principles process-based model.  A nitrogen mass balance and a process description of ammonia losses are used, but the FEM model parameters are designed to be tuned to reproduce measured emissions factors from the NAEMS campaign mentioned earlier. The 2014 NEI livestock waste emissions were estimated with the FEM by Dr. McQuilling as a part of her Ph.D. thesis. The NAEMS data and literature data were used to validate these FEM NH3 emission factors estimated as a function of the nitrogen present in the waste and the mass transfer resistance in the evaporation and volatilization of that nitrogen. These manure-characteristic and resistance parameters are based on widely used theoretical formulas and are not tuned. Especially, the surface resistance from diffusion closest to the gas-liquid (manure) interface is a function of parameters as well as temperature which ensures the modeled ammonia emission factors are consistent with observations. Table 4 describes the types of parameters and inputs critical to the model.

The main goal of the FEM applications for the livestock waste NEI development is not necessarily to capture the emissions of single farms perfectly, but rather to capture the effects of various parameters on emissions on a farm typical of a certain set of practices. Thus, then the FEM can be applicable for the nationwide livestock waste NH3 emissions rather than an individual farm NH3 emission prediction. The final FEM configuration will be based on developing similar county-level annual NH3 emission factors to the ones from 2014 NEI by re-tuning the manure characteristics and model parameters (e.g., mass transfer resistances, urea concentration, manure volume, and pH) in 2020 NEI FEM simulations. However, due to the limited and inconsistent information on 2014 NEI FEM simulation configurations and inputs from the Dr. McQuilling’s work, EPA was unable to reproduce the 2014 NH3 emissions. Given these qualitative differences between the FEM simulations due to the limited transferred information, a brand new setup of FEM simulations for 2020 NEI NH3 emissions was designed based on new county-level daily meteorology inputs (Section 6), new county-level animal manure management practice inputs, and the 2014 NEI NH3 emission factors and the NAEMS results, which extensively used to evaluate and tune the 2020 NEI FEM simulations by constraining the FEM simulation results.

### Table 4. Description and sources of model inputs and parameters
|Data Type| Description| Data Source | Input or Tuned Parameter?|
| :------------ |:-------------------|:-------|:---------------------|
|Meteorology|	Temperature (°C), Wind speed (m/s), Precipitation (mm)|	MCIP gridded hourly meteorology over U.S. domain|	County-level daily average meteorology data|
|Manure Management Practice|	Type of housing, storage, or application|	Unique to each farm type; farm types have a unique set of inputs|Input value|
|Model Parameters|	Manure characteristics & Surface mass transfer resistance from manure to atmosphere|	Tuned based on literature and NAEMS observations to agree with previous work; constant for a particular management practice (for a particular animal type)| 	Tuned Manure characteristics & Surface Resistance Parameters|

## 1. Manure characteristics
Manure characteristics are important input parameters to the model because they govern the amount of nitrogen available for volatilization/emissions (whether or not the nitrogen present is likely to be volatilized), and how well the waste can infiltrate into the soil during manure application (Figure 2). There are a limited number of studies that describe the manure nitrogen and manure pH for each animal type.  As a result, there is considerable uncertainty in these input values which can result in significant uncertainty in predicted emissions from the model.
The FEM is sensitive to all of these manusre characteristic parameters, such as mass transfer resistances, urea concentration, manure volume, and pH from the processes/sub-models (housing, storage, application, and/or grazing). While empirical mass transfer resistance calculation parameters listed play a critical role in tuning the FEM to the measurement values to arrive at emission factors, there is a limitation on tuning these parameter values to match the NAEMS results.  Tuning the manure characteristic parameters (urea concentrations and manure volume inputs) were required to match the NAEMS results.
The manure characteristic parameters have been tuned in the 2020 NEI development based on information extracted from published literature as well as reports from the NAEMS study.  Table 5 presents the tuned values of manure volume, nitrogen concentration, and pH levels in the waste from each type of animal used in the 2020 NEI FEM simulations based on the NAEMS measurements.

### Table 5. Tuned model Input parameters related to manure characteristics
|Parameter Name|	Animal Type|	Value Used in Model|	Units|
| :------------ |:-------------------|:-------|:---------------------|
|Manure Volume|	Beef Cattle|	8.0|	animal<sup>-1</sup> day<sup>-1</sup>|
||	Dairy Cattle|	6.0	|animal<sup>-1</sup> day<sup>-1</sup>|
||	Swine|	6.0|	animal<sup>-1</sup> day<sup>-1</sup>|
||	Poultry-Laye|	0.07|	animal<sup>-1</sup> day<sup>-1</sup>|
||	Poultry-Broiler|	0.6|	animal<sup>-1</sup>|
|Manure Urea Concentration|	Beef Cattle|	10.0	|kg N animal<sup>-1</sup> year<sup>-1</sup>|
||	Dairy Cattle|	14.0	|kg N animal<sup>-1</sup> year<sup>-1</sup>|
||	Swine	|19.0	|kg N animal<sup>-1</sup> year<sup>-1</sup>|
||	Poultry-Layer	|0.5	|kg N animal<sup>-1</sup> year<sup>-1</sup>|
||	Poultry-Broiler	|0.05	|kg N animal<sup>-1</sup>|
|Housing pH|	Beef Cattle	|7.0	||
||	Dairy Cattle|	7.7	||
||	Swine|	7.0	||
||	Poultry-Layer|7.3	||
||	Poultry-Broiler|	7.3	||
|Storage pH	|Dairy Cattle|	7.3	||
||	Swine	|7.7	||
|Application pH	|Beef Cattle|	7.8	||
||	Dairy Cattle|	7.5	||
||	Swine	|7.8	||
||	Poultry-Laye|	7.2	||
||	Poultry-Broiler|7.3	||
|Storage pH|	Beef Cattle	|7.7||
||Dairy Cattle|	7.7	||

## 2. Mass Transfer Resistances
Along with the manure characteristic parameters, there are tunable mass transfer resistance parameters associated with each submodel in the FEM.  These tunable parameters allow adjustment of model-predicted emissions and correct for the unknowns and uncertainties of the input parameters and to ensure that the model-predicted values are consistent with those that have been reported in the literature and in the NAEMS campaign; they are constant for a particular farm type—tuning is not done for a particular farm—and as a result, there can be significant disagreement between model predictions and the measured emissions for a single farm.  The goal of the FEM is not necessarily to capture the emissions of single farms perfectly, but rather to capture the effects of various parameters on emissions on a farm typical of a certain set of practices.
In the FEM, NH3 emissions are estimated as a function of the nitrogen present in the waste and the mass transfer resistance in the evaporation and volatilization of that nitrogen.  This resistance is made up of the following three parts:  the aerodynamic (r<sub>a</sub>), quasi-laminar (r<sub>b</sub>), and surface resistances (r<sub>s</sub>).  Aerodynamic and quasi-laminar resistances are used to describe the resistance to transport in the gaseous layer above the animal wastes.  These parameters are based on widely used theoretical formulas and are not tuned. The third part of the resistance is the surface resistance from diffusion closest to the gas-liquid (manure) interface.  Here, the surface resistance is a function of tuned parameters as well as temperature, which ensures the modeled ammonia emission factors are consistent with observations; Table 6 lists the tuned mass transfer resistance parameters used for each animal and each submodel in the 2020 NEI FEM simulations. These values are specific to a particular practice for a particular animal type.  This means that a free-stall dairy with lagoon storage and injection application would employ the same tuned parameters whether it was located in New York or California. Conversely, two farms in the same location but utilizing different manure management practices would have different tuned parameters in their submodels.  

### Table 6. Model parameters used for beef, swine and poutry.

|Submodel	|Description|	Animal Type	|Tuning/Evaluation Sources|
| :------------ |:-------------------|:-------|:---------------------|
|Housing|	Resistance parameters H1, H2|	Dairy Cattle|H=0.1 (s•m<sup>-1</sup>•°C<sup>-1</sup>), H2=-0.015 (s2m-2)|
|||Swine|H=0.1 (s•m<sup>-1</sup>•°C<sup>-1</sup>), H2=-0.08 (s<sup>2</sup>m<sup>-2</sup>)|
|||Poultry-Broiler|H=0.15 (s•m<sup>-1</sup>•°C<sup>-1</sup>), H2=-0.0035 (s<sup>2</sup>m<sup>-2</sup>)|
|||Poultry-Layer| H=0.1 (s•m<sup>-1</sup>•°C<sup>-1</sup>), H2=-0.001 (s<sup>2</sup>m<sup>-2</sup>)|
|Storage|	Resistance parameters S1, S2|	Dairy Cattle| S1=0.1(s•m<sup>-1</sup>), S2=1.00(s•m<sup>-1</sup>•°C<sup>-1</sup>)
|||Swine| S1=0.2(s•m<sup>-1</sup>), S2=4.00(s•m<sup>-1</sup>•°C<sup>-1</sup>)|
|Application|Resistance parameters A1, A2, A3|	Dairy Cattle|	A=0.0004(s•m<sup>-1</sup>), A2=8.8, A3=1.4|
|||Swine|A=0.001(s•m<sup>-1</sup>), A2=-10, A3=20|
|||Poutry|A=0.001(s•m<sup>-1</sup>), A2=-0.01, A3=0.2|
|Grazing|	Resistance parameters  G1, G2|	Dairy Cattle|G= 0.12(s•m<sup>-1</sup>),  G2=5.4
|||Beef Cattle| G= 0.12(s•m<sup>-1</sup>),  G2=5.4
