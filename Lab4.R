#import txts
shakespeare <- read.csv("~/Documents/OPERATIONS_RESEARCH/Q7/DataAnalytics/Labs/Lab_4_Instructions/TXT_MapReduce/Task4/shakespeare_output.txt", header=FALSE)
twain <- read.csv("~/Documents/OPERATIONS_RESEARCH/Q7/DataAnalytics/Labs/Lab_4_Instructions/TXT_MapReduce/Task4/twain_output.txt", header=FALSE)

#format files
#change colomn names
colnames(shakespeare) = c("Word", "Frequency")
colnames(twain) = c("Word", "Frequency")
#remove first row because it counts " " and is not neccessary
shakespeare = shakespeare[-1,]
twain = twain[-1,]
#remove "[" and "]" in each column
library(stringr)
shakespeare$Word=substring(shakespeare$Word, 2)
shakespeare$Frequency=str_sub(shakespeare$Frequency, 1, str_length(shakespeare$Frequency)-1)
twain$Word=substring(twain$Word, 2)
twain$Frequency=str_sub(twain$Frequency, 1, str_length(twain$Frequency)-1)
#create one data set for all words that appear in either text
data <- merge(shakespeare, twain, by.x="Word", by.y="Word", all = TRUE)
#assign NAs the value 0
data[is.na(data)] <- 0


#Most common words
#Change column names for clarity
colnames(data)=c("Word","shakespeare_Freq","twain_Freq")
#change frequencies into class numeric
data$shakespeare_Freq=as.numeric(data$shakespeare_Freq)
data$twain_Freq=as.numeric(data$twain_Freq)


#Bar chart
total=nrow(data)
(similar=(nrow(data[data$shakespeare_Freq>0 & data$twain_Freq>0,]))/total)
(dissimilar=(1-similar))

barplot(c(similar, dissimilar),col=c("lightgreen","maroon"),ylab="Percentage", xlab="Words", main="Text Similarity")


#legend("topleft", legend=c("Similar Words", "Dissimilar Words"),
#       col=c("lightgreen", "maroon"), cex=0.8)


plot(data$shakespeare_Freq,data$twain_Freq, xlab="Shakespeare Word Frequency", ylab="Twain Word Frequency", main="Word Frequncy Comparison of William Shakespeare and Mark Twain")
sub=data[data$shakespeare_Freq>10000 & data$twain_Freq>30000,]
text(sub$shakespeare_Freq,sub$twain_Freq,sub$Word, cex=0.6, pos=2, col="red")

library(tm)
#create a list of stop words with SMART dictionary
st=stopwords("SMART")
#remove stopwords from dataset
data=data[-which(data$Word %in% st),]
par(mfrow=c(1,1))
plot(data$shakespeare_Freq,data$twain_Freq, xlab="Shakespeare Word Frequency", ylab="Twain Word Frequency", main="Word Frequncy Comparison of William Shakespeare and Mark Twain")
sub=data[data$shakespeare_Freq>1000 & data$twain_Freq>2000,]
text(sub$shakespeare_Freq,sub$twain_Freq,sub$Word, cex=0.6, pos=2, col="red")


#head(data1[order(data1$twain_Freq,data1$shakespeare_Freq,decreasing=TRUE),])

library(wordcloud)
par(mfrow=c(1,2))
png("wordcloud_packages.png", width=12,height=8, units='in', res=300)
wordcloud(data$Word, data$shakespeare_Freq, min.freq =1000, scale=c(5, .2), random.order = FALSE, random.color = FALSE, colors= c("indianred1","indianred2","indianred3","indianred"))
png("wordcloud_packages.png", width=12,height=8, units='in', res=300)
wordcloud(data$Word, data$twain_Freq, min.freq =1000, scale=c(5, .2), random.order = FALSE, random.color = FALSE, colors= c("lightsteelblue1","lightsteelblue2","lightsteelblue3","lightsteelblue"))

corpus <- Corpus(VectorSource(data$Words))
TermDocumentMatrix(corpus)

#normalize frequencies
data$shake_norm=data$shakespeare_Freq/sum(data$shakespeare_Freq)
data$twain_norm=data$twain_Freq/sum(data$twain_Freq)
#create an average score column
data$avg=(data$shake_norm+data$twain_norm)/2
#create word cloud by averages

wordcloud(data$Word, data$avg, min.freq =.5, scale=c(5, .2), random.order = FALSE, random.color = TRUE)



data=data[order(data$avg,decreasing=TRUE),]
