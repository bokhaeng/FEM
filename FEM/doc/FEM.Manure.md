# Farm Manure Management Practices Inputs for FEM

s mentioned above, NH3 emission factors from livestock waste is also a function of manure management practices employed by the producers (i.e. what housing, storage and application methods are used).  It can significantly impact on the conditions of the manure and waste (e.g. water content, total ammoniacal nitrogen concentration) and as a result, it can increase or reduce the emissions of ammonia from these sources.  
The FEM model requires county-level farm manure management inputs which describe the type of animal housing, manure storage, and application methods used for a particular location.  Each location is expected to have some combination of practices; for example, in a single county, some of swine farms may use deep-pit housing, lagoon storage, and irrigation application while other farms use shallow-pit housing with lagoon storage and injection application.

A farm configuration is a unique combination of manure management practices that describe the operation of the farm. Each farm configuration is executed by the FEM, and the county-level daily NH3 emission factor is the average of all farm configuration FEM simulations, weighted by farm size and probability of occurrence.


### Table 3. FEM Farm Manusre Management Practices configuration file
|FEM Submodel| Configuration | Value| Description|
| :------------ |:-------------------|:-------|:---------------------|
|Grazing|	confined_summer|	1 or 0|	Seasonal summer Grazing|
|	|confined_winter|	1 or 0|	Seasonal Winter Grazing|
|	|pasture|	1 or 0|	Pasture resistance|
|	|drylot|	1 or 0|	Beef=Drylot, Poultry-Litter|
|Housing|	tiestall|	1 or 0|	Dairy=Tiestall, Swine=Deep-Pit, Poultry=High-Rise|
|	|freestall|	1 or 0|	Dairy=Freestall, Swine=Shallow-Pit, Poultry=Manure Belt|
|	|nohousing|	1 or 0|	No enclosed housing|
|	|liquid|	1 or 0|	Liquid phase animal waste|
|	|solid|	1 or 0|	Dry phase animal waste|
|Storage|	lagoon|	1 or 0|	Lagoon storage|
|	|earthbasin|	1 or 0|	Earth basin storage|
|	|slurrytank|	1 or 0|	Slurry tank storage|
|Application|	irrigation|	1 or 0|	Irrigation application|
|	|injection|	1 or 0|	Injection application|
|	|trailinghose|	1 or 0|	Trailinghose application|
|	|broadcast|	1 or 0|	Broadcast applicatoin|
|	|summer_application|	1 or 4	|Summer: [1=daily, 2=weekly, 3=monthly, 4=seasonal]|
|	|winter_application|	1 or 4	|Winter: [1=daily, 2=weekly, 3=monthly, 4=seasonal]|
|Farm practice|Probability	|Fraction|	Probability of occurrence (e.g., 0.1, 0.2,,)||
