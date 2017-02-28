#' ---
#' title: "Count weekly data from weekly cumulative"
#' author: "Karina Cucchi"
#' date: "February  28th, 2017"
#' ---
#' 
#' Check licensing in LICENSE.md at root of repository.
#' 
#' reads cumulative weekly counts from raw_data/caseCounts_westnile/weeklyCumulative/
#' 
#' saves weekly counts in processed_data/caseCounts_westnile/weekly/
#' 

# IMPORTANT : The default working directory is CA_drought/data/R/R_scripts
# use setwd(paste0(<pathToGitRepo>,'CA_drought/data/R/R_scripts'))

# read all cumulative data and separate by weekly additions

path_cumulative = '../../raw_data/caseCounts_westnile/weeklyCumulative/'

for(year in 2006:2015){
  
  # this is the path containing cumulative data for given year
  dir_data <- paste0(path_cumulative,year)
  
  # this is the directory for saving the data
  dir_save <- paste0('../../processed_data/caseCounts_westnile/weekly/',year)
  if(!dir.exists(dir_save)){dir.create(dir_save)}
  
  # week 1 is just the same as in cumulative folder
  file_path <- paste0(dir_data,'/',year,'_week1.csv')
  df_week1 <- read.csv(file = file_path,sep = ',',
                       colClasses = 'character')
  # replace fields without values by zeros
  df_week1[df_week1=='-'] <- 0
  
  # now save data in weekly folder
  path_save <- paste0(dir_save,'/',year,'_week1.csv')
  write.table(x = df_week1,
              file = path_save,
              quote = F,sep = ',',row.names = F)
  
  # deal will all other weeks
  for(week in 2:53){
    
    # get counts from previous weeks
    file_path <- paste0(dir_data,'/',year,'_week',(week-1),'.csv')
    df_previous <- read.csv(file = file_path,sep = ',',
                            colClasses = 'character')
    # replace NAs by zeros
    df_previous[df_previous=='-'] <- 0
    # turn the dataframe into a matrix
    data_previous <- data.matrix(df_previous[,c('Human.Cases','Dead.Birds',
                                                'Mosquito.Samples','Sentinel.Chickens')])
    
    # get counts for current week
    file_path <- paste0(dir_data,'/',year,'_week',week,'.csv')
    df_current <- read.csv(file = file_path,sep = ',',
                           colClasses = 'character')
    # replace NAs by zeros
    df_current[df_current=='-'] <- 0
    # turn the dataframe into a matrix
    data_current <- data.matrix(df_current[,c('Human.Cases','Dead.Birds',
                                              'Mosquito.Samples','Sentinel.Chickens')])
    
    
    # compute the difference
    data_diff <- data_current - data_previous
    
    # write in csv file
    data_save <- data.frame(County=df_current$County)
    data_save <- cbind(data_save,as.data.frame(data_diff))
    path_save <- paste0('../../processed_data/caseCounts_westnile/weekly/',year,
                        '/',year,'_week',week,'.csv')
    write.table(x = data_save,
                file = path_save,
                quote = F,sep = ',',row.names = F)
    
    rm(df_previous,data_previous,df_current,data_current,data_diff,data_save)
    
  }
  
}

