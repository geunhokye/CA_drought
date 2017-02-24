
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
              quote = F,sep = ';',row.names = F)
  
  
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

for(year in 2006:2016){
  
  for(week in 53){
    
    url_name <- paste0('http://westnile.ca.gov/case_counts.php?year=',
                       year,'&limit_week=',week,'&option=print')
    
    # this is the path to where the data will be saved
    dir_path <- paste0('../../raw_data/caseCounts_westnile/weekly/',year)
    # create directory of not existing
    if(!dir.exists(dir_path)){dir.create(dir_path)}
    file_path <- paste0(dir_path,'/',year,'_week',week,'.csv')
    
    scrapeUrl_westnile(url_name,file_path)
  }
  
}







