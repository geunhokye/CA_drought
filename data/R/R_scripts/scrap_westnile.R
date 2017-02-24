
#' 
#' execute this script from the working directory data/R/R_scripts
#' 
#' This script reads case counts data from westnile.ca.gov
#' Data are reported either yearly or weekly.
#' 
#' example of url for yearly:
#' http://www.westnile.ca.gov/case_counts.php?year=2016&option=print
#' 
#' example of url for weekly cumulative:
#' http://www.westnile.ca.gov/case_counts.php?year=2015&limit_week=52&option=print
#' 
#' 
#' The function scrapeUrl_westnile reads data from one url
#' and saves it in a csv file.
#' 

#' # scraping function #
#' 
#' This is the function actually scraping the data.
#' It is called in for loops in the following sections.

scrapeUrl_westnile <- function(url_name,path_save){
  
  web_page <- readLines(url_name)
  
  # this is where the table with data can be found
  table_all <- web_page[grep(pattern = 'Human Cases',x = web_page)]
  
  # get names of fields
  fields_start <- unlist(strsplit(x = table_all,split = '<B>'))
  fields_temp <- strsplit(x = unlist(x = fields_start[2:6]),split = '</B>')
  # keep every first element
  fields_names <- sapply(fields_temp, "[[", 1)
  rm(fields_start,fields_temp)
  
  table_byLine <- unlist(strsplit(x = table_all,split = '\t'))
  table_byLine <- table_byLine[grep(pattern = "</tr>",x = table_byLine,invert = T)]
  
  table_final <- array(data='',dim = c(0,5))
  colnames(table_final) <- fields_names; rm(fields_names)
  for(iLine in 2:(length(table_byLine)-1)){
    
    table_line <- table_byLine[iLine]
    
    # get county
    county <- strsplit(x = unlist(strsplit(table_line,split = '<b>')),split = '</b>')[[2]][1]
    
    # get fields in line
    ## get start
    fields_start <- unlist(strsplit(x = table_line,split = '<td align=center>'))
    fields_final <- unlist(strsplit(x=fields_start[2:5],split = "</td>"))
    
    table_final <- rbind(table_final,c(county,fields_final))
    
  }
  
  write.table(x = table_final,
              file = path_save,
              quote = F,sep = ',',row.names = F)
  
  
}

#' # download yearly data #


for(year in 2006:2016){
  
  # this is the url where the data is contained
  url_name <- paste0('http://westnile.ca.gov/case_counts.php?year=',
                     year,'&option=print')
  
  # this is the path to where the data will be saved
  file_path <- paste0('../../raw_data/caseCounts_westnile/yearly/',year,'.csv')
  
  scrapeUrl_westnile(url_name,file_path)
  
}

#' # download weekly cumulative data #

# loop over all years and all weeks in years
# download data as they are in the website

# STOP before 2016 : weekly data are not updated for year 2016
for(year in 2006:2015){
  
  for(week in 1:53){
    
    url_name <- paste0('http://westnile.ca.gov/case_counts.php?year=',
                       year,'&limit_week=',week,'&option=print')
    
    # this is the path to where the data will be saved
    dir_path <- paste0('../../raw_data/caseCounts_westnile/weeklyCumulative/',year)
    # create directory of not existing
    if(!dir.exists(dir_path)){dir.create(dir_path)}
    file_path <- paste0(dir_path,'/',year,'_week',week,'.csv')
    
    scrapeUrl_westnile(url_name,file_path)
  }
  
}

# now we can read it all again and separate by weekly additions

for(year in 2006:2015){
  
  # this is the path containing all files in year
  dir_data <- paste0('../../raw_data/caseCounts_westnile/weeklyCumulative/',year)
  
  # this is the directory for saving the data
  dir_save <- paste0('../../raw_data/caseCounts_westnile/weekly/',year)
  if(!dir.exists(dir_save)){dir.create(dir_save)}
  
  # week 1 is just the same as in cumulative folder
  file_path <- paste0(dir_data,'/',year,'_week1.csv')
  df_week1 <- read.csv(file = file_path,sep = ',',
                       colClasses = 'character')
  df_week1[df_week1=='-'] <- 0
  path_save <- paste0('../../raw_data/caseCounts_westnile/weekly/',year,
                      '/',year,'_week1.csv')
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
    path_save <- paste0('../../raw_data/caseCounts_westnile/weekly/',year,
                        '/',year,'_week',week,'.csv')
    write.table(x = data_save,
                file = path_save,
                quote = F,sep = ',',row.names = F)
    
    rm(df_previous,data_previous,df_current,data_current,data_diff,data_save)
    
  }
  
}



