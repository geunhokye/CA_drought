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
    
#Census data from 2010: *NOTE: may want to get demographic data for each year in the future
  cens = read.csv('data/raw_data/2010census/DEC_10_DP_DPDP1.csv')
    cens = cens[,-1]
  
#Yearly WNV summaries:
y.sum = function(year){
  
    path = paste('data/raw_data/caseCounts_westnile/yearly/', year, '.csv', sep='')
    name1 = paste('y', year, sep='')
    
    df = read.csv(path, colClasses = c(rep('character',5)))
    
    df[df == '-'] = 0
    
    for(i in 2:5){
      df[,i] = as.numeric(df[,i])
    }
    
    colnames(df)[c(2:5)] = paste(c('HC_', 'DB_','MS_', "SC_"), year, sep = '')
    
    assign(name1, df, envir = .GlobalEnv)
    
}
  for(i in 2006:2016){
    y.sum(i)
  }

#Merge all years together
y.list = mget(ls(pattern = 'y[1-2]'))
y.all = Reduce(function(...) merge(..., all=T), y.list)

y.all$HC_Total = rowSums(y.all[,grep('HC_', colnames(y.all))])
y.all$DB_Total = rowSums(y.all[,grep('DB_', colnames(y.all))])
y.all$MS_Total = rowSums(y.all[,grep('MS_', colnames(y.all))])
y.all$SC_Total = rowSums(y.all[,grep('SC_', colnames(y.all))])

#Make shapefile of yearly summary info for each county ############
  ca.cens = merge(ca, cens, by.x = 'geoid_num', by.y = 'GEO.id2', all.x = TRUE)
  ca.y = merge(ca.cens, y.all, by.x = 'NAME', by.y = 'County', all.x = TRUE)
    cols = ncol(ca.y@data)
  
  for(i in 1:length(grep('HC_', colnames(ca.y@data)))){
    #Add columns for incidence: cases / 1000 person years
    ca.y@data[,(cols+i)] = 
      (ca.y@data[grep('HC_', colnames(ca.y@data))][i] / ca.y@data$HD01_S001)*1000 
    
    colnames(ca.y@data)[cols+i] = paste('Inc_', as.character(2005+i), sep = '')
  }
    
  #correct total incidence (i.e. average incidence across all 11 years)
    ca.y@data[,ncol(ca.y@data)] = rowMeans(ca.y@data[grep('Inc_', colnames(ca.y@data))][1:11])

    colnames(ca.y@data)[ncol(ca.y@data)] = 'Inc_Total' 
    
  #Save yearly summaries file  
    #writeSpatialShape(ca.y, 'data/Spatial/WNV_All_years/CA_Counties_mergeCensus2010_mergeWNV2006_2016.shp')
    

#Weekly files for each year ############
rm(list=setdiff(ls(), 'ca'))    
w.sum = function(year, week){
      
  path = paste('data/raw_data/caseCounts_westnile/weekly/', year, '/', year, '_week', week,'.csv', sep='')
  name1 = paste('y', year,'w', week, sep='')
      
  df = read.csv(path, colClasses = c(rep('character',5)))
      
  df[df == '-'] = 0
      
  for(i in 2:5){
    df[,i] = as.numeric(df[,i])
  }
      
  colnames(df)[c(2:5)] = paste(c('HC_', 'DB_','MS_', "SC_"), name1, sep = '')
      
  assign(name1, df, envir = .GlobalEnv)
      
}

#2006 **********************************************************************
  for(i in 1:53){
    w.sum(2006, i)
  }
  list06 = mget(ls(pattern = 'y[1-2]'))
  all06 = Reduce(function(...) merge(..., all=T), list06)
    all06 = all06[, mixedsort(names(all06))]

    ca06 = merge(ca, all06, by.x = 'NAME', by.y = 'County', all.x = T)   
    
  writeSpatialShape(ca06, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2006.shp')  
    
#2007 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2007, i)
  }
  list07 = mget(ls(pattern = 'y[1-2]'))
  all07 = Reduce(function(...) merge(..., all=T), list07)
    all07 = all07[, mixedsort(names(all07))]
  
    ca07 = merge(ca, all07, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca07, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2007.shp')  
  
#2008 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2008, i)
  }
  list08 = mget(ls(pattern = 'y[1-2]'))
  all08 = Reduce(function(...) merge(..., all=T), list08)
    all08 = all08[, mixedsort(names(all08))]
  
    ca08 = merge(ca, all08, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca08, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2008.shp')  
  
#2009 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2009, i)
  }
  list09 = mget(ls(pattern = 'y[1-2]'))
  all09 = Reduce(function(...) merge(..., all=T), list09)
    all09 = all09[, mixedsort(names(all09))]
  
    ca09 = merge(ca, all09, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca09, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2009.shp')  
  
#2010 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2010, i)
  }
  list10 = mget(ls(pattern = 'y[1-2]'))
  all10 = Reduce(function(...) merge(..., all=T), list10)
    all10 = all10[, mixedsort(names(all10))]
  
    ca10 = merge(ca, all10, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca10, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2010.shp')  
  
#2011 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2011, i)
  }
  list11 = mget(ls(pattern = 'y[1-2]'))
  all11 = Reduce(function(...) merge(..., all=T), list11)
    all11 = all11[, mixedsort(names(all11))]
  
    ca11 = merge(ca, all11, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca11, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2011.shp')  
  
#2012 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2012, i)
  }
  list12 = mget(ls(pattern = 'y[1-2]'))
  all12 = Reduce(function(...) merge(..., all=T), list12)
    all12 = all12[, mixedsort(names(all12))]
  
    ca12 = merge(ca, all12, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca12, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2012.shp')  
  
#2013 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2013, i)
  }
  list13 = mget(ls(pattern = 'y[1-2]'))
  all13 = Reduce(function(...) merge(..., all=T), list13)
    all13 = all13[, mixedsort(names(all13))]
  
    ca13 = merge(ca, all13, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca13, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2013.shp')  
  
#2014 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2014, i)
  }
  list14 = mget(ls(pattern = 'y[1-2]'))
  all14 = Reduce(function(...) merge(..., all=T), list14)
    all14 = all14[, mixedsort(names(all14))]
  
    ca14 = merge(ca, all14, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca14, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2014.shp')  
  
#2015 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2015, i)
  }
  list15 = mget(ls(pattern = 'y[1-2]'))
  all15 = Reduce(function(...) merge(..., all=T), list15)
    all15 = all15[, mixedsort(names(all15))]
  
    ca15 = merge(ca, all15, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca15, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2015.shp')  
  
#2016 **********************************************************************
rm(list=setdiff(ls(), c('ca', 'w.sum')))    
  for(i in 1:53){
    w.sum(2016, i)
  }
  list16 = mget(ls(pattern = 'y[1-2]'))
  all16 = Reduce(function(...) merge(..., all=T), list16)
    all16 = all16[, mixedsort(names(all16))]
  
    ca16 = merge(ca, all16, by.x = 'NAME', by.y = 'County', all.x = T)   
  
  writeSpatialShape(ca16, 'data/Spatial/WNV_Yearly_Summaries/CA_Counties_WNV2016.shp')  
  
  
#This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License #############
  #http://creativecommons.org/licenses/by-nc/4.0/ by Karina Cucchi, Christopher Hoover and Justin Remais. This work was supported in part by the National Institute of Allergy and Infectious Diseases (grant R01AI125842), the National Science Foundation Water Sustainability and Climate Program (grant 1360330), and UCOP Multicampus Research Programs and Initiatives (MRPI) grant MRP-17-446315. Per the terms of this license, if you are making derivative use of this work, you must identify that your work is a derivative work, give credit to the original work, provide a link to the license, and indicate changes that were made.  