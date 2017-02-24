
# loop over all years and all weeks in years

year=2014
week=35

for(year in 2006:2016){
  for(week in 53){
    
    web_name <- paste0('http://westnile.ca.gov/case_counts.php?year=',
                       year,'&limit_week=',week,'&option=print')
    
    web_page <- readLines(web_name)
    
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
                file = paste0('../../raw_data/caseCounts_westnile/',year,'_week',week,'.csv'),
                quote = F,sep = ';',row.names = F)
    
  }
}


