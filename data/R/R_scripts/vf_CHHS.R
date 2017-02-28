#' ---
#' title: "Import vf data from CHHS into R sp object"
#' author: "Karina Cucchi"
#' date: "February  28th, 2017"
#' ---
#' 
#' Check licensing in LICENSE.md at root of repository.
#' 
#' The data is read from raw_data/health/vf_CHHS.
#' 
#' It is formatted and stored into a R sp object stored in R/R_objects.
#' 

# IMPORTANT : The default working directory is CA_drought/data/R/R_scripts
# use setwd(paste0(<pathToGitRepo>,'CA_drought/data/R/R_scripts'))

#'
#' # Import raw data #
#'

# Import data from csv file
dataPath = '../../raw_data/health/vf_CHHS/Infectious_Disease_Cases_by_County__Year__and_Sex__2001-2014.csv'

data_all <- read.csv(file = dataPath,header = T,sep = ',',colClasses = "character")
data_vf <- subset(data_all,Disease == 'Coccidioidomycosis')
rm(data_all)

head(data_vf)
unique(data_vf$County)
unique(data_vf$Year)

nrow(data_vf)
sum(as.numeric(data_vf$Count))

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
head(data_vf)

# 58 counties in sp object
length(cal)
# 58 counties + california in data_vf object
length(unique(data_vf$County))

# NAME_2 is the county field in sp object
# County is the county field in data_vf

# create vf field
vf_field_Total <- list()
vf_field_Male <- list()
vf_field_Female <- list()
# names of relevant columns to store in sp object for each sex field
names_col <- c("Year","Count","Population",
               "Rate","CI.lower","CI.upper","Unstable")

for(i in 1:nrow(cal)){ # loop over counties in sp package
  
  # find indices of lines in data_vf
  # corresponding to county i in sp object cal
  idx_vf2cal <- which(data_vf$County %in% cal$NAME_2[i])
  
  # check that 42 lines for each county subset (14 years * 3 types of sex)
  # print(length(idx_vf2cal))
  
  # info relating to county one on data_vf
  subset_county_i <- data_vf[idx_vf2cal,]
  
  for (sex in c("Total","Male","Female")){
    # only subset corresponding to total
    subset_countyi_sex <- subset(x = subset_county_i,Sex==sex)
    # transform relevant data to matrix containing numerical values
    subset_countyi_data <- suppressWarnings(data.matrix(subset_countyi_sex[,names_col],
                                                        rownames.force = F))
    # in unstable field: replace asteriks by 1s and empty fields by 0s
    subset_countyi_data[,'Unstable'] <- 1*(subset_countyi_sex$Unstable=="*")
    # dash is whe count is zero and stability indicator cannot be calculated
    subset_countyi_data[,'Unstable'][subset_countyi_sex$Unstable=="-"] <- NA
    
    # append obtained data matrix to corresponding field
    assign(x = paste0('vf_field_',sex),
           value = c(get(paste0('vf_field_',sex)),list(subset_countyi_data)))
  }
  
}

# write fields in cal sp object
cal$vf_CHHS_Total  <- vf_field_Total
cal$vf_CHHS_Male   <- vf_field_Male
cal$vf_CHHS_Female <- vf_field_Female

names(cal)

#'
#' ## Save in rds file ##
#'

saveRDS(object = cal,file = '../R_objects/vf_CHHS.rds')
rm(list = ls())



