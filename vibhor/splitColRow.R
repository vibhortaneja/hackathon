#reading a file

stackOverflwPub <- read.csv(file.choose(),header =T , na.strings = c("NA"), stringsAsFactors = F)

#extract the name of the dimensions for your plotting purpose

req_dataframe <- stackOverflwPub[ , c("Professional" ,"Country","HaveWorkedLanguage")]


# if package is not installed automatically installed

list.of.packages <- c("tidyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(tidyr)

save_data <- separate_rows(req_dataframe, HaveWorkedLanguage)
write.csv(save_data , "req.csv")


