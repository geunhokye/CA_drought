require(maptools)
require(rgdal)
require(ggplot2)
require(RColorBrewer)
require(mapproj)
require(tmap)
require(dplyr)
require(scales)

ca_wnv = readShapePoly('data/Spatial/WNV_All_years/CA_Counties_mergeCensus2010_mergeWNV2006_2016.shp')
proj4string(ca_wnv) = CRS('+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs ')

  inc_years = colnames(ca_wnv@data)[grep('Inc_', colnames(ca_wnv@data))]
  case_years = colnames(ca_wnv@data)[grep('HC_', colnames(ca_wnv@data))]
  
#Human cases Map  
wnv_yearly =   tm_shape(ca_wnv) +
                  tm_polygons(c(inc_years), 
                              palette = "Reds", 
                              style = 'fixed',
                              breaks = c(0, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1),
                              title = 'Incidence \n(Cases /\n1000 Person-Years)') +
                  tm_facets(ncol = 4, nrow = 3, free.scales = FALSE) +
                  tm_text(c(case_years), size = rep(0.6,12)) +
                  tm_layout(panel.labels = c(2006:2016, 'Average')) +
                  tm_credits('Numbers indicate \n#cases in county',
                             position = c(0,0))

save_tmap(wnv_yearly, 'data/plots/WNV_yearly_incidence_by_county.png', 
          width = 2500, height = 2000)

#Dead birds map
dbs = colnames(ca_wnv@data)[grep('DB_', colnames(ca_wnv@data))]
wnv_dbs = tm_shape(ca_wnv) +
            tm_polygons(c(dbs), 
                        palette = "Purples", 
                        style = 'fixed',
                        breaks = c(0:10, 50, 100, 500, 1000, 2000),
                        title = 'Dead birds reported') +
            tm_facets(ncol = 4, nrow = 3, free.scales = FALSE) +
            tm_text(c(dbs), size = rep(0.6,12)) +
            tm_layout(panel.labels = c(2006:2016, 'Total')) +
            tm_credits('Numbers indicate \n#dead birds in county',
                       position = c(0,0))

save_tmap(wnv_dbs, 'data/plots/WNV_dead_birds_reported_by_county.png', 
          width = 2500, height = 2000)

#Positive mosquito samples map
mss = colnames(ca_wnv@data)[grep('MS_', colnames(ca_wnv@data))]
wnv_mss = tm_shape(ca_wnv) +
            tm_polygons(c(mss), 
                        palette = "YlGn", 
                        style = 'fixed',
                        breaks = c(0:10, 50, 100, 500, 1000, 2000),
                        title = 'Positive Mosquito \nSamples Found') +
            tm_facets(ncol = 4, nrow = 3, free.scales = FALSE) +
            tm_text(c(mss), size = rep(0.6,12)) +
            tm_layout(panel.labels = c(2006:2016, 'Total')) +
            tm_credits('Numbers indicate \n#pos. mosquito samples in county',
                       position = c(0,0))

save_tmap(wnv_mss, 'data/plots/WNV_positive_mos_samples_reported_by_county.png', 
          width = 2500, height = 2000)

#Sentinel chickens map
scs = colnames(ca_wnv@data)[grep('SC_', colnames(ca_wnv@data))]
wnv_scs = tm_shape(ca_wnv) +
            tm_polygons(c(scs), 
                        palette = "YlOrBr", 
                        style = 'fixed',
                        breaks = c(0:10, 50, 100, 500, 1000),
                        title = 'Seroconverted Sentinel \nChickens') +
            tm_facets(ncol = 4, nrow = 3, free.scales = FALSE) +
            tm_text(c(scs), size = rep(0.6,12)) +
            tm_layout(panel.labels = c(2006:2016, 'Total')) +
            tm_credits('Numbers indicate #seroconverted\nsentinel chickens in county',
                       position = c(0,0))

save_tmap(wnv_scs, 'data/plots/WNV_sentinel_chickens_by_county.png', 
          width = 2500, height = 2000)