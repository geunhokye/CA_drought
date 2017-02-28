#' ---
#' title: "vf_spatial"
#' author: "Christopher Hoover"
#' date: "February  28th, 2017"
#' ---
#' 
#' Check licensing in LICENSE.md at root of repository.
#' 

require(maptools)
require(rgdal)
require(ggplot2)
require(RColorBrewer)
require(mapproj)
require(tmap)
require(dplyr)
require(scales)

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
vf = subset(vf, County != 'California' & Sex == 'Total')
colnames(vf)[6:7] = c('Pop', 'Inc')
vf2 =  reshape(vf, timevar = c('Year'), idvar = c('County'), 
               drop = c('Disease', 'CI.lower', 'CI.upper', 'Unstable', 'Sex'), direction = 'wide')
for(i in 2:43){
  vf2[,i] = as.numeric(vf2[,i])
}
vf2$Count.tot = rowSums(vf2[,grep('Count.', colnames(vf2))][-1])
vf2$Inc.mean = rowMeans(vf2[,grep('Inc.', colnames(vf2))])

#Merge with counties shapefile
ca.vf = merge(ca, vf2, by.x = 'NAME', by.y = 'County', all.x = T)
writeSpatialShape(ca.vf, 'data/Spatial/VF_All_years/vf_2001-2014_cases_pop_rate')

#Go ahead and plot  ###############
inc.vf = colnames(ca.vf@data)[grep('Inc.', colnames(ca.vf@data))]
case.vf = colnames(ca.vf@data)[grep('Count.', colnames(ca.vf@data))]

vf_yearly =   tm_shape(ca.vf) +
  tm_polygons(c(inc.vf), 
              palette = "Reds", 
              style = 'fixed',
              breaks = c(0:10, 20, 30, 40, 50, 100, 200, 300),
              title = 'Incidence \n(Cases /\n100000 Person-Years)') +
  tm_facets(ncol = 5, nrow = 3, free.scales = FALSE) +
  tm_text(c(case.vf), size = rep(0.6,12)) +
  tm_layout(panel.labels = c(2001:2014, 'Total Cases / Mean Incidence')) +
  tm_credits('Numbers indicate \n#cases in county',
             position = c(0,0))

save_tmap(vf_yearly, 'data/plots/VF_yearly_incidence_by_county.png', 
          width = 3000, height = 2500)


#This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License #########
#http://creativecommons.org/licenses/by-nc/4.0/ by Karina Cucchi, Christopher Hoover and Justin Remais. This work was supported in part by the National Institute of Allergy and Infectious Diseases (grant R01AI125842), the National Science Foundation Water Sustainability and Climate Program (grant 1360330), and UCOP Multicampus Research Programs and Initiatives (MRPI) grant MRP-17-446315. Per the terms of this license, if you are making derivative use of this work, you must identify that your work is a derivative work, give credit to the original work, provide a link to the license, and indicate changes that were made.      