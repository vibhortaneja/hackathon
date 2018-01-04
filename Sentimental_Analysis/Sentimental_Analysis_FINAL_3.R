library(NLP)
library(RColorBrewer)
library(readr) # CSV file I/O, e.g. the read_csv function
library(tm)
library(stringr)
library(wordcloud)
library(RWeka)
library(RSentiment)
library(SnowballC)

tweet=read.csv('C:\\Users\\vibhor.5.taneja\\Desktop\\hackathon\\Sentimental_Analysis\\Data\\demonetization-tweets-3.csv',stringsAsFactors = FALSE)
text <- as.character(tweet$text)
set.seed(100)
sample <- sample(text, (length(text)))
corpus <- Corpus(VectorSource(list(sample)))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords('english'))
corpus <- tm_map(corpus, stemDocument)
dtm_up <- DocumentTermMatrix(VCorpus(VectorSource(corpus[[1]]$content)))
freq_up <- colSums(as.matrix(dtm_up))

sentiments_up <- calculate_sentiment(names(freq_up))
sentiments_up <- cbind(sentiments_up, as.data.frame(freq_up))
sent_pos_up <- sentiments_up[sentiments_up$sentiment=='Positive',]
sent_neg_up <- sentiments_up[sentiments_up$sentiment=='Negative',]
cat("Negative sentiments: ",sum(sent_neg_up$freq_up)," Positive sentiments: ",sum(sent_pos_up$freq_up))

wordcloud(sent_pos_up$text,sent_pos_up$freq,min.freq=5,random.order=FALSE,colors=brewer.pal(6,"Dark2"))

wordcloud(sent_neg_up$text,sent_neg_up$freq,min.freq=5,random.order=FALSE,colors=brewer.pal(6,"Dark2"))
