library(ggplot2) # Libarary for Data visualization
library(readr) # library to read CSV file
library(syuzhet) #library for sentimental analysis
library(tm)
library(wordcloud)
library(dplyr)
library(tidytext)
library(tidyr)
library(igraph)
library(ggraph)
library(wordcloud2)

demonitization_data <-read.csv("C:\\Users\\VIBHOR TANEJA\\Desktop\\hackathon\\Sentimental_Analysis\\Data\\demonetization-tweets.csv")
demonitization_bigrams <- unnest_tokens(demonitization_data, input = text, output = bigram, token = "ngrams", n=2)

demonitization_bigrams %>% count(bigram, sort = TRUE)
demonitization_bigrams_separated <- demonitization_bigrams %>% separate(bigram, c("word1", "word2"), sep = " ")
demonitization_bigrams_filtered <- demonitization_bigrams_separated %>% filter(!word1 %in% stop_words$word) %>% filter(!word2 %in% stop_words$word)

# new bigram counts:
demonitization_bigrams_counts <- demonitization_bigrams_filtered %>% count(word1, word2, sort = TRUE)
demonitization_bigrams_counts

AFINN <- get_sentiments("afinn")

not_words <- demonitization_bigrams_separated %>% filter(word1 == "not") %>% inner_join(AFINN, by = c(word2 = "word")) %>%
  count(word2, score, sort = TRUE) %>% ungroup()


not_words %>% mutate(contribution = n * score) %>% arrange(desc(abs(contribution))) %>%
  head(20) %>% mutate(word2 = reorder(word2, contribution)) %>%
  ggplot(aes(word2, n * score, fill = n * score > 0)) +
  geom_col(show.legend = FALSE) +
  xlab("Words preceded by \"not\"") +
  ylab("Sentiment score * number of occurrences") +
  coord_flip()


######################### Sentiments according to predefined library ########################################
demonitization_data_text<-as.character(demonitization_data$text)

filter_text<-gsub("(RT|via)((?:\\b\\w*@\\w+)+)","",demonitization_data_text) #removing Retweets
filter_text<-gsub("http[^[:blank:]]+","",filter_text) #clean html links
filter_text<-gsub("@\\w+","",filter_text)# removing people names
filter_text<-gsub("[[:punct:]]"," ",filter_text)#removing punctuations
filter_text<-gsub("[^[:alnum:]]"," ",filter_text)#removing number (alphanumeric)

sentiment_twitter<-get_nrc_sentiment((filter_text)) #sentimental analysis

Sentimentscores<-data.frame(colSums(sentiment_twitter[,])) #used to classify sentiment scores
names(Sentimentscores)<-"Score"
SentimentScores<-cbind("sentiment"=rownames(Sentimentscores),Sentimentscores)
rownames(SentimentScores)<-NULL

#Ploting of data
ggplot(data=SentimentScores,aes(x=sentiment,y=Score))+geom_bar(aes(fill=sentiment),stat = "identity")+
  theme(legend.position="none")+
  xlab("Sentiments")+ylab("scores")+ggtitle("Total sentiment based on scores")
