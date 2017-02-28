#' ---
#' title: "wnv_ts_plots"
#' author: "Christopher Hoover"
#' date: "February  28th, 2017"
#' ---
#' 
#' Check licensing in LICENSE.md at root of repository.
#' 

require(dplyr)
require(gtools)

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

#Weekly files for each year ############
#2006 **********************************************************************
for(i in 1:53){
  w.sum(2006, i)
}
list06 = mget(ls(pattern = 'y[1-2]'))
  all06 = Reduce(function(...) merge(..., all=T), list06)
  all06 = all06[, mixedsort(names(all06))]

#2007 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'w.sum')))    
for(i in 1:53){
  w.sum(2007, i)
}
list07 = mget(ls(pattern = 'y[1-2]'))
  all07 = Reduce(function(...) merge(..., all=T), list07)
  all07 = all07[, mixedsort(names(all07))]

#2008 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'all07', 'w.sum')))    
for(i in 1:53){
  w.sum(2008, i)
}
list08 = mget(ls(pattern = 'y[1-2]'))
  all08 = Reduce(function(...) merge(..., all=T), list08)
  all08 = all08[, mixedsort(names(all08))]

#2009 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'all07', 'all08', 'w.sum')))    
for(i in 1:53){
  w.sum(2009, i)
}
list09 = mget(ls(pattern = 'y[1-2]'))
  all09 = Reduce(function(...) merge(..., all=T), list09)
  all09 = all09[, mixedsort(names(all09))]

#2010 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'all07', 'all08', 'all09', 'w.sum')))    
for(i in 1:53){
  w.sum(2010, i)
}
list10 = mget(ls(pattern = 'y[1-2]'))
  all10 = Reduce(function(...) merge(..., all=T), list10)
  all10 = all10[, mixedsort(names(all10))]

#2011 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'all07', 'all08', 'all09', 'all10', 'w.sum')))    
for(i in 1:53){
  w.sum(2011, i)
}
list11 = mget(ls(pattern = 'y[1-2]'))
  all11 = Reduce(function(...) merge(..., all=T), list11)
  all11 = all11[, mixedsort(names(all11))]

#2012 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'all07', 'all08', 'all09', 'all10', 'all11', 'w.sum')))    
for(i in 1:53){
  w.sum(2012, i)
}
list12 = mget(ls(pattern = 'y[1-2]'))
  all12 = Reduce(function(...) merge(..., all=T), list12)
  all12 = all12[, mixedsort(names(all12))]

#2013 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'all07', 'all08', 'all09', 'all10', 'all11', 
                        'all12', 'w.sum')))    
for(i in 1:53){
  w.sum(2013, i)
}
list13 = mget(ls(pattern = 'y[1-2]'))
  all13 = Reduce(function(...) merge(..., all=T), list13)
  all13 = all13[, mixedsort(names(all13))]

#2014 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'all07', 'all08', 'all09', 'all10', 'all11', 
                        'all12', 'all13', 'w.sum')))    
for(i in 1:53){
  w.sum(2014, i)
}
list14 = mget(ls(pattern = 'y[1-2]'))
  all14 = Reduce(function(...) merge(..., all=T), list14)
  all14 = all14[, mixedsort(names(all14))]

#2015 **********************************************************************
rm(list=setdiff(ls(), c('all06', 'all07', 'all08', 'all09', 'all10', 'all11', 
                        'all12', 'all13', 'all14', 'w.sum')))    
for(i in 1:53){
  w.sum(2015, i)
}
list15 = mget(ls(pattern = 'y[1-2]'))
  all15 = Reduce(function(...) merge(..., all=T), list15)
  all15 = all15[, mixedsort(names(all15))]

rm(list=setdiff(ls(), c('all06', 'all07', 'all08', 'all09', 'all10', 'all11', 
                        'all12', 'all13', 'all14', 'all15', 'w.sum')))    

#Plot time series by week ###########
plot(c(1:53), colSums(all06[,grep('HC_', colnames(all06))]), type = 'l', lwd = 2,
     xlab = 'time (weeks)', ylab = 'WNV Human Cases', xlim = c(0,55), ylim = c(0,75),
     main = 'Human WNV Cases by Week, 2006-2015')
  lf = function(df,clr){
    lines(c(1:53), colSums(df[,grep('HC_', colnames(df))]), col = clr, lwd = 2)
  }
  lf(all07,clr=2)
  lf(all08,clr=3)
  lf(all09,clr=4)
  lf(all10,clr=5)
  lf(all11,clr=6)
  lf(all12,clr=7)
  lf(all13,clr=8)
  lf(all14,clr='orange')
  lf(all15,clr='pink')
    legend('topleft', lwd = 2, col = c(1:8, 'orange', 'pink'),
           legend = c(2006:2015), title = 'Year', cex = 0.6)
    
#This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License #############
#http://creativecommons.org/licenses/by-nc/4.0/ by Karina Cucchi, Christopher Hoover and Justin Remais. This work was supported in part by the National Institute of Allergy and Infectious Diseases (grant R01AI125842), the National Science Foundation Water Sustainability and Climate Program (grant 1360330), and UCOP Multicampus Research Programs and Initiatives (MRPI) grant MRP-17-446315. Per the terms of this license, if you are making derivative use of this work, you must identify that your work is a derivative work, give credit to the original work, provide a link to the license, and indicate changes that were made.  