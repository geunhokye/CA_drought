#' ---
#' title: "Import wnv data from CHHS into R sp object"
#' author: "Karina Cucchi"
#' date: "February  28th, 2017"
#' ---
#' 
#' Check licensing in LICENSE.md at root of repository.
#' 
#' The data is read from raw_data/health/wnv_CHHS.
#' 
#' It is formatted and stored into a R sp object stored in R/R_objects.
#' 

# IMPORTANT : The default working directory is CA_drought/data/R/R_scripts
# use setwd(paste0(<pathToGitRepo>,'CA_drought/data/R/R_scripts'))

#'
#' # Import raw data #
#'

# Import data from csv file
dataPath = '../../raw_data/health/wnv_CHHS/West_Nile_Virus_Cases__2006-present.csv'

data_wnv <- read.csv(file = dataPath,header = T,sep = ',',colClasses = "character")

head(data_wnv)

#'
#' # format data #
#'
#'
#' ## get california shape file from raster package ##
#'

library(raster)    

# directly retrieves data from gadm.org in the form of a SpatialPolygonsDataFrame -- very cool
us <- getData('GADM', country='USA', level=2)  #Get the County Shapefile for the US
cal <- subset(x = us,NAME_1=="California") # select only counties belonging to california
rm(us)

cal@data <- cal@data[,c("NAME_2","HASC_2")]

plot(cal)

#'
#' ## map data from CHHS to the sp object ##
#'

head(cal@data)
head(data_wnv)

# this will be added as a new field to the sp object
field_wnv <- list()

for(i in 1:nrow(cal)){ # loop over counties
  
  idx_wnv2cal <- which(data_wnv$County %in% cal$NAME_2[i])
  # all counties don't have the same length
  # only weeks with actual reporting
  cat(paste0(length(idx_wnv2cal),' '))
  
  # select data corresponding to county i
  subset_county_i <- data.matrix(data_wnv[idx_wnv2cal,
                                          c('Year','Week.Reported','Positive.Cases')],
                                 rownames.force = F)
  
  # append to list
  field_wnv <- c(field_wnv,list(subset_county_i))
  
}

cal$wnv_CHHS <- field_wnv
names(cal)

#'
#' ## Save in rds file ##
#'

saveRDS(object = cal,file = '../R_objects/wnv_CHHS.rds')
rm(list = ls())

