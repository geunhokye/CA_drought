# CA_drought

stores data, code and documents for the CA drought and public health MRPI proposal.

## data

[data](https://github.com/kcucchi/CA_drought/tree/master/data) contains all data

folder [raw_data](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data) corresponds to data directly downloaded from sources (often csv files).
  within[raw_data]:
    folder[2010census](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/2010census) contains data downloaded from the US 2010 census as a source for demographic data. This file is extensive (>300 variables) due to in depth demographic info. See the file "DEC_10_DP_DPDP1_metadata.csv" for variable codes and descriptions
    folder[animals](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/animals) contains detailed reporting, collection, testing, and WNV-status data for birds and mosquitoes; separated into individual csvs for each year data is available
    folder[caseCounts_westnile](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/caseCounts_westnile) contains two subfolders: folder[weekly](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/caseCounts_westnile/weekly) has for each year: a csv for weeks 1-53 of that year reporting the number of human cases, dead birds, mosquito pools, and sentinel chickens in that week and folder[yearly](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/caseCounts_westnile/yearly) contains this info summed over all weeks for the entire year
    folder[health](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/health) contains data from CA Health and Human Services (CHHS) for valley fever (to be expanded on) and WNV case counts for each county

folder [R](https://github.com/kcucchi/CA_drought/tree/master/data/R) contains R scripts used to derive shapefiles, plots, etc. and R objects reading files in raw_data.

folder [plots](https://github.com/kcucchi/CA_drought/tree/master/data/plots) contains plots derived from shapefiles in [Spatial] showing human incidence, dead bird reports, mosquito pools, and sentinel chickens from 2006 - 2016 by county for the state of California

folder[Spatial](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial) contains: folder[CA_counties](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial/CA_counties) which contains a shapefile of all counties in california used to join tabular data in folder[raw_data](https://github.com/kcucchi/CA_drought/tree/master/data/raw_data) to space
folder[WNV_All_years](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial/WNV_All_years) contains a shapefile with both demographic data from the 2010 census and yearly summaries of human cases and incidence, dead birds, mosquitoes sampled, and sentinel chickens for each county from 2006 - 2016; this shapefile was used to produce the annual plot collations in folder[plots](https://github.com/kcucchi/CA_drought/tree/master/data/plots)
folder[WNV_Yearly_Summaries](https://github.com/kcucchi/CA_drought/tree/master/data/Spatial/WNV_Yearly_Summaries) contains a shapefile corresponding to each year from 2006 - 2016 with weekly counts of human cases, dead birds reported, mosquito samples, and sentinel chickens