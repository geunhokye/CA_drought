require(maptools)
require(rgdal)
require(ggplot2)
require(RColorBrewer)
require(mapproj)
require(tmap)
require(dplyr)
require(scales)

ca_wnv = readShapePoly('data/Spatial/WNV_Cases_by_County/CA_Counties_Census2010_WNV2006_2016.shp')
proj4string(ca_wnv) = CRS('+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs ')

  df.edit = as.data.frame(ca_wnv@data)
  df.edit2 = df.edit[,c(1:23,395:420)] #Get rid of census variables other than total population
  df.edit3 = df.edit2[,-c(2,4,5,6,8:14,17:20)] #Get rid of other variables that aren't needed
  df.edit3$inc_total = (df.edit3$cases_tota / (df.edit3$HD01_S001*11))*1000 # add total incidence variable
  
ca_wnv@data<-df.edit3  #Replace with smaller data frame
  inc_years = colnames(df.edit3)[c(23:30,32:35)]
  case_years = sort(colnames(df.edit3)[c(10:20,31)])
  
  
wnv_yearly =   tm_shape(ca_wnv) +
                  tm_polygons(c(inc_years), 
                              palette = "OrRd", 
                              style = 'fixed',
                              breaks = c(0, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1),
                              title = 'Incidence \n(Cases /\n1000 Person-Years)') +
                  tm_facets(ncol = 4, nrow = 3, free.scales = FALSE) +
                  tm_text(c(case_years), size = rep(0.6,12)) +
                  tm_layout(panel.labels = c(2006:2016, 'total')) +
                  tm_credits('Numbers indicate \n#cases in county',
                             position = c(0,0))

save_tmap(wnv_yearly, 'WNV_yearly_incidence_by_county.png', width = 2500, height = 2000)