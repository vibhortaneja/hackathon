library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function
library(tm)
library(wordcloud)
library(plyr)
library(lubridate)
library(syuzhet)


#Import the twitter data set
demonitization_data=read.csv('C:\\Users\\VIBHOR TANEJA\\Desktop\\hackathon\\Sentimental_Analysis\\Data\\demonetization-tweets-2.csv',stringsAsFactors = FALSE)
options(warn=-1)
summary(demonitization_data)

demonitization_data$created_date=as.Date(demonitization_data$created,format='%Y-%m-%d %H:%M:%S')#convert created to date format
demonitization_data$hour = format(as.POSIXct(demonitization_data$created,format="%Y-%m-%d %H:%M:%S"),"%H")#Extract Hour from the date
demonitization_data$isRetweetNum=ifelse(demonitization_data$isRetweet==FALSE,0,1)#Numerical variable to indicate whether a tweet was retweet
demonitization_data$retweetedNum=ifelse(demonitization_data$retweeted==FALSE,0,1)#Total number of times a tweet was tetweeted
demonitization_data$tweet=c(1)#Additional column that will help us in summing up total tweets

options(repr.plot.width=6, repr.plot.height=4)
HourFrame=as.data.frame(table(demonitization_data$hour))
colnames(HourFrame)=c("Hour","TweetCount")
HourFrame$Hour=as.numeric(HourFrame$Hour)
y=ddply(demonitization_data, .(demonitization_data$hour), numcolwise(sum))
HourFrame$retweetedNum=y$isRetweetNum
ggplot(HourFrame,aes(x=Hour))+geom_line(aes(y = TweetCount, colour = "TotalTweets")) + 
  geom_line(aes(y = retweetedNum, colour = "Retweets"))

################################## device data ###########################################
devices=demonitization_data$statusSource
devices <- gsub("","", devices)
devices <- strsplit(devices, ">")
devices <- sapply(devices,function(x) ifelse(length(x) > 1, x[2], x[1]))

devices_source=as.data.frame(table(devices))
colnames(devices_source)=c("Device","TweetCount")
devices_source=devices_source[devices_source$TweetCount>50,]
devices_source=devices_source[order(-devices_source$TweetCount),]

ggplot(devices_source,aes(x=reorder(Device, -TweetCount),y=TweetCount,fill=TweetCount))+geom_bar(stat='identity') +coord_flip()

################ Most Popular users ######################################################
y=ddply(demonitization_data, .(screenName), numcolwise(sum))
popularUsers=y[,c("screenName","retweetCount","tweet")]
popularUsers=popularUsers[order(-popularUsers$retweetCount),]
popularUsers=head(popularUsers,n=10)
popularUsers

################ Most Replies ###############################################################
Replies=demonitization_data[is.na(demonitization_data$replyToSN)==FALSE,]
y=ddply(Replies, .(replyToSN), numcolwise(sum))
Replies=y[,c("replyToSN","tweet")]
Replies=Replies[order(-Replies$tweet),]
Replies=head(Replies,n=20)
colnames(Replies)=c("User","RepliesReceived")
Replies
