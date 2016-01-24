#Read clean comments 
comments1 <- read.csv("data//Video1_cleancomments.csv", header = FALSE, as.is = TRUE)
comments2 <- read.csv("data//Video2_cleancomments.csv", header = FALSE, as.is = TRUE)


poldat1<-polarity(comments1[,1])
poldat2<-polarity(comments2[,1])

plot(poldat1)
plot(poldat2)

