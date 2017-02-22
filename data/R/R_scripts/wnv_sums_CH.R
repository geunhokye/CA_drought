dataPath_ch = 'data/raw_data/health/wnv_CHHS/West_Nile_Virus_Cases__2006-present.csv'

wnv_ch <- read.csv(file = dataPath_ch,header = T,sep = ',')

#Get yearly and total summaries for cases per county ##############
  cnt = unique(wnv_ch$County)
  yrs = unique(wnv_ch$Year)
#Generate data frame to fill
wnv.years = data.frame('County' = cnt,
                     'cases_2006' = 0,
                     'cases_2007' = 0,
                     'cases_2008' = 0,
                     'cases_2009' = 0,
                     'cases_2010' = 0,
                     'cases_2011' = 0,
                     'cases_2012' = 0,
                     'cases_2013' = 0,
                     'cases_2014' = 0,
                     'cases_2015' = 0,
                     'cases_2016' = 0,
                     'cases_total' = 0)
#Fill dataframe
for(i in 1:nrow(wnv.years)){
  for(j in c(2006:2016)){
    wnv.years[i,(j-2004)] = sum(wnv_ch$Positive.Cases[wnv_ch$Year == j 
                                           & wnv_ch$County == wnv.years[i,1]])
  }
  
}
for(i in 1:nrow(wnv.years)){
  wnv.years[i,13] = sum(wnv.years[i,2:12])
}

#wnv.years file saved to github:
# https://github.com/kcucchi/CA_drought/tree/master/data/raw_data/health/wnv_CHHS
# write.csv(wnv.years, 'data/raw_data/health/wnv_CHHS/wnv_sums_ch.csv', row.names = FALSE)