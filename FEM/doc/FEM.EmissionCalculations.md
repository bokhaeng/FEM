# Emissions Calculations

The general approach to calculating NH3 emissions due to livestock is to multiply the emission factor (in kg per year per animal) by the number of animals in the county. The county-level NH3 emissions factors are estimated using the FEM and county-level daily meteorology (ambient temperature, wind speed, and precipitation). Once the FEM estimates NH3 emission factors by animal type, the county-level NH3 emission factors (EF<sub>c,a,2020</sub>) will be multiplied with the latest 2020 NEI animal population (A<sub>c,a,2020</sub>) to compute the 2020 county-level NH3 emissions (E<sub>c,a,2020</sub>) for all animal types.

***E<sub>NH3 c,a,2020</sub> = EF<sub>NH3 c,a,2020</sub> / A<sub>c,a,2020</sub>***

  - *E<sub>NH3 c,a,2020</sub> = NH3 Emissions for animal type (a) and county (c) in unit of short tons*

  - *EF<sub>NH3 c,a,2020</sub> = NH3 Emission Factor from the FEM for animal type (a) and county (c) in unit of kg/animal-head*
  - *A<sub>c,a,2020</sub> = Animal count for animal type (a) and county (c) in unit of animal-head*


  VOC emissions were estimated by multiplying a constant national VOC/NH3 emissions ratio of 0.08 by the county-level NH3 emissions. Hazardous air pollutants (HAP) emissions were estimated by multiplying the county-level VOC emissions by HAP/VOC ratios, which are obtained from the literature and can vary by animal type.  The VOC emissions (E_<sub>c,a,2020</sub>) are calculated using the ratio of VOC to NH3 emissions from livestock.  That ratio is 0.08 kg of VOC for every kg of NH3.  HAP emissions were estimated by multiplying the county-level VOC emissions by HAP/VOC ratios from Table 1 below.

  ***E<sub>VOC c,a,2020</sub> = VOC/NH3 * EF<sub>NH3 c,a,2020</sub>***

  - *E<sub>VOC c,a,2020</sub> = VOC Emissions for animal type (a) and county (c) in unit of short tons*
  - *VOC/NH3 = 0.08 (constant value of VOC/NH3 ratio*
  - *E<sub>NH3 c,a,2020</sub> = NH3 Emissions for animal type (a) and county (c) in unit of short tons*


### Table 1. VOC speciation fractions used to estimate HAP Emissions for the Livestock Sector
| Animal Type | HAP | Fraction of VOC |
| :------------ |:-------------------|:-------|
| Beef Cattle | 1, 184-Dichlorobenzene|0.0013|
|Beef Cattle|	Methyl isobutyl Ketone|	0.0008|
|Beef Cattle|	Toluene|	0.0110|
|Beef Cattle|	Chlorobenzene|	0.0001|
|Beef Cattle|	Phenol|	0.0006|
|Beef Cattle|	Benzene|	0.0001|
|Poultry---Layers|	Methyl isobutyl ketone|	0.0169|
|Poultry---Layers|	Toluene|	0.0018|
|Poultry---Layers|	Phenol|	0.0024|
|Poultry---Layers|	N-hexane|	0.0111|
|Poultry---Layers|	Chloroform|	0.0025|
|Poultry---Layers|	Cresol/Cresylic Acid|	0.0048|
|Poultry---Layers|	Acetamide|	0.0075|
|Poultry---Layers|	Methanol|	0.0608|
|Poultry---Layers|	Benzene|	0.0052|
|Poultry---Layers|	Ethyl Chloride|	0.0031|
|Poultry---Layers|	Acetonitrile|	0.0088|
|Poultry---Layers|	Dichloromethane|	0.0002|
|Poultry---Layers|	Carbon Disulfide|	0.0034|
|Poultry---Layers|	2-Methyl Napthalene|	0.0006|
|Poultry-Broilers|	Methyl isobutyl ketone|	0.0169|
|Poultry-Broilers|	Toluene|	0.0018|
|Poultry-Broilers|	Phenol|	0.0024|
|Poultry-Broilers|	N-hexane|	0.0111|
|Poultry-Broilers|	Chloroform|	0.0025|
|Poultry-Broilers|	Cresol/Cresylic Acid|	0.0048|
|Poultry-Broilers|	Acetamide|	0.0075|
|Poultry-Broilers|	Methanol|	0.0608|
|Poultry-Broilers|	Benzene|	0.0052|
|Poultry-Broilers|	Ethyl Chloride|	0.0031|
|Poultry-Broilers|	Acetonitrile|	0.0088|
|Poultry-Broilers|	Dichloromethane|	0.0002|
|Poultry-Broilers|	Carbon Disulfide|	0.0034|
|Poultry-Broilers|	2-Methyl Napthalene|	0.0006|
|Dairy Cattle|	Toluene|	0.0018|
|Dairy Cattle|	Cresol/Cresylic Acid|	0.0276|
|Dairy Cattle|	Xylenes|	0.0046|
|Dairy Cattle|	Methanol|	0.3542|
|Dairy Cattle|	Acetaldehyde|	0.0141|
|Swine|	Toluene|	0.0047|
|Swine|	Phenol (Carbolic Acid)|	0.0179|
|Swine|	Benzene|	0.0035|
|Swine|	Acetaldehyde|	0.0155|
