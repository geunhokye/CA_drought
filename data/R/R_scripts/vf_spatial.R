require(maptools)
require(mapproj)
require(dplyr)
require(gtools)

#Base data files to merge for final spatial datasets ###############
  #CA counties shapefile:
    ca = readShapePoly('data/Spatial/CA_counties/CA_counties.shp')
    #project it:  
    prj = '+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs '
      proj4string(ca) = CRS(prj)
    #Get rid of unneeded variables  
      ca@data <- ca@data[,-c(2,4,7:14)]
  #Valley fever data
    vf = read.csv('data/raw_data/health/vf_CHHS/ValleyFever_CA_2001-2014_by_County.csv')

#This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License http://creativecommons.org/licenses/by-nc/4.0/ by Karina Cucchi, Christopher Hoover and Justin Remais. This work was supported in part by the National Institute of Allergy and Infectious Diseases (grant R01AI125842), the National Science Foundation Water Sustainability and Climate Program (grant 1360330), and UCOP Multicampus Research Programs and Initiatives (MRPI) grant MRP-17-446315. Per the terms of this license, if you are making derivative use of this work, you must identify that your work is a derivative work, give credit to the original work, provide a link to the license, and indicate changes that were made.      