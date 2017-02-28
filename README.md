# CA_drought

This repository stores data and code for the CA drought and public health MRPI proposal.

## data

[data](https://github.com/kcucchi/CA_drought/tree/master/data) is the parent tree to lead to all of the below data. All available variables and associated attributes are summarized in [data_codebook.docx](https://github.com/kcucchi/CA_drought/tree/master/data/data_codebook.docx).

### raw_data

folder [raw_data](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data) corresponds to data directly downloaded from sources (often csv files).

* [2010census](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/2010census) contains data downloaded from the US 2010 census as a source for demographic data. This file is extensive (>300 variables) due to in depth demographic info. See the file "DEC_10_DP_DPDP1_metadata.csv" for variable codes and descriptions
  
* [animals](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/animals) contains detailed reporting, collection, testing, and WNV-status data for birds and mosquitoes; separated into individual csvs for each year data is available
  
* [caseCounts_westnile](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/caseCounts_westnile) contains case counts downloaded from westnile.ca.gov.
  * [weekly](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/caseCounts_westnile/weekly) has for each year: a csv for weeks 1-53 of that year reporting the number of human cases, dead birds, mosquito pools, and sentinel chickens in that week and folder
  * [yearly](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/caseCounts_westnile/yearly) contains this info summed over all weeks for the entire year
  
* [health](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/health) contains data from CA Health and Human Services (CHHS) for valley fever (to be expanded on) and WNV case counts for each county

See more extended description of datasets inside folder hierarchy.

### R

folder [R](https://github.com/kcucchi/CA_drought/tree/master/data/R) contains R scripts used to derive shapefiles, plots, etc. and R objects reading files in raw_data to be used for later analyzes.

See description of files in folder.

### Spatial

folder [Spatial](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial) contains:

*  [CA_counties](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial/CA_counties) which contains a shapefile of all counties in california used to join tabular data in [raw_data](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data) to space
*  [WNV_All_years](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial/WNV_All_years) contains a shapefile with both demographic data from the 2010 census and yearly summaries of human cases and incidence, dead birds, mosquitoes sampled, and sentinel chickens for each county from 2006 - 2016; this shapefile was used to produce the annual plot collations in [plots](https://github.com/kcucchi/CA_drought/tree/master/data/plots)
*  [WNV_Yearly_Summaries](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial/WNV_Yearly_Summaries) contains a shapefile corresponding to each year from 2006 - 2016 with weekly counts of human cases, dead birds reported, mosquito samples, and sentinel chickens
*  [CA_MRPI.gdb](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial/CA_MRPI.gdb) contains a geodatabase with the above spatial data for integration with ArcGIS
  
### plots

folder [plots](https://github.com/kcucchi/CA_drought/tree/master/data/plots) contains plots derived from shapefiles in [Spatial](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial) showing human incidence, dead bird reports, mosquito pools, and sentinel chickens from 2006 - 2016 by county for the state of California

# Licensing
  
This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License http://creativecommons.org/licenses/by-nc/4.0/ by Karina Cucchi, Christopher Hoover and Justin Remais. This work was supported in part by the National Institute of Allergy and Infectious Diseases (grant R01AI125842), the National Science Foundation Water Sustainability and Climate Program (grant 1360330), and UCOP Multicampus Research Programs and Initiatives (MRPI) grant MRP-17-446315. Per the terms of this license, if you are making derivative use of this work, you must identify that your work is a derivative work, give credit to the original work, provide a link to the license, and indicate changes that were made.
