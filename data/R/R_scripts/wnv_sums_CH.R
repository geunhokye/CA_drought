dataPath_ch = 'data/raw_data/health/wnv_CHHS/West_Nile_Virus_Cases__2006-present.csv'

wnv_ch <- read.csv(file = dataPath_ch,header = T,sep = ',')

#Get yearly and total summaries for cases per county ##############
cnt = sort(unique(wnv_ch$County))      #All counties
yrs = c(unique(wnv_ch$Year), 'total')  #All yearsand totals

#Generate data frame to fill
wnv.sum = data.frame('County' = rep(cnt, length(yrs)),
                     'Year' = rep(yrs, each = length(cnt)),
                     'Cases' = 0)
#Fill dataframe
for(i in 1:nrow(wnv.sum)){
  wnv.sum[i,3] = sum(wnv_ch$Positive.Cases[wnv_ch$Year == wnv.sum[i,2] 
                                           & wnv_ch$County == wnv.sum[i,1]])
}

for(i in (nrow(wnv.sum)-length(cnt)+1):nrow(wnv.sum)){
  wnv.sum[i,3] = sum(wnv.sum$Cases[wnv.sum$County == wnv.sum[i,1]])
}
