This folder contains R scripts. The scripts can serve different purposes:

* downloading data from sources;

* clean/modify raw data into more convient processed data;

* formatting raw data in different formats (R objects, shapefiles, ...);

* plotting data.


# Download from source

* scrap_westnile.R imports case counts data from westnile.ca.gov and saves into raw_data/caseCounts_westnile

# Modify raw data

* westnile_cum2weekly.R reads the cumulative weekly data from raw_data/caseCounts_westnile (as imported from westnile.ca.gov using scrap_westnile.R), and calculates weekly counts from it. Saves into processed_data/caseCounts_westnile/weekly

* wnv_sums_CH.R

# Save in different file format

* vf_CHHS.R reads data in raw_data/health/vf_CHHS and exports as R object R_objects/vf_CHHS.rds

* wnv_CHHS.R reads data in raw_data/health/wnv_CHHS and exports as R object R_objects/wnv_CHHS.rds

* vf_spatial.R

# Plot data

* wnv_ts_plots.R

* wnv_yearly_plots.R