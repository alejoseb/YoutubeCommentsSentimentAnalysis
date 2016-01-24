#install.packages("qdap")

#browseVignettes(package = 'qdap')

library(qdap)


########################################################################################
###Cleaning and Munging of comments for Video1
########################################################################################

csample1 <- read.csv("data//Video1_rawcomments.csv", header = FALSE, as.is = TRUE)

# check_text function is supplied with a text variable that outputs a list, designed to check text for the potential sources of errors.
#textc <- check_text(csample1)

cs <- list()
for (i in 1:nrow(csample1)) {
  
  # Remove Bracketed text
  cs[i] <- bracketX(csample1[i,1])
  
  #General text cleaning function that removes extra white spaces other textual anomalies that may cause errors
  cs[i] <- scrubber(cs[i])
  
  #Strip text of unwanted characters
  cs[i] <- strip(cs[i])
  
  #Remove leading or trailing white spaces
  cs[i] <- Trim(cs[i])
  
  #Remove escaped characters
  cs[i] <- clean(cs[i])
  
  #remove blank/empty cells
  cs[i] <- blank2NA(cs[i])
  
  #Add space after a comma
  cs[i] <- comma_spacer(cs[i])
  
  #Replace incomplete sentence end marks
  cs[i] <- incomplete_replace(cs[i])
}

#Check the list again for possible potential errors using 
#check_text(cs)

#Convert the list 'cs' into dataframe 'comments1'
comments1 <- do.call(rbind.data.frame, cs)

#Write the data frame into a new csv file
write.csv(comments1,"data/Video1_cleancomments.csv", row.names=FALSE)

#Remove NAs from the dataset and write the data back to the csv file
csample1 <- read.csv("data//Video1_cleancomments.csv", header = FALSE, as.is = TRUE)
csample1<-na.omit(csample1)
write.csv(csample1,"data/Video1_cleancomments.csv", row.names=FALSE)

########################################################################################
###Cleaning and Munging of comments for Video2
########################################################################################

csample2 <- read.csv("data//Video2_rawcomments.csv", header = FALSE, as.is = TRUE)
# check_text function is supplied with a text variable that outputs a list, designed to check text for the potential sources of errors.
#textc <- check_text(csample2)
cs <- list()
for (i in 1:nrow(csample2)) {
  
  # Remove Bracketed text
  cs[i] <- bracketX(csample2[i,1])
  
  #General text cleaning function that removes extra white spaces other textual anomalies that may cause errors
  cs[i] <- scrubber(cs[i])
  
  #Strip text of unwanted characters
  cs[i] <- strip(cs[i])
  
  #Remove leading or trailing white spaces
  cs[i] <- Trim(cs[i])
  
  #Remove escaped characters
  cs[i] <- clean(cs[i])
  
  #remove blank/empty cells
  cs[i] <- blank2NA(cs[i])
  
  #Add space after a comma
  cs[i] <- comma_spacer(cs[i])
  
  #Replace incomplete sentence end marks
  cs[i] <- incomplete_replace(cs[i])
}

#Check the list again for possible potential errors using 
#check_text(cs)


#Convert the list 'cs' into dataframe 'comments2'
comments2 <- do.call(rbind.data.frame, cs)

#remove NA from the list dataframe
comments2 <- na.omit(comments2)

#Write the dataframe with cleancomments into a new csv file
write.csv(comments2,"data//Video2_cleancomments.csv", row.names=FALSE)

#Remove NAs from the dataset and write the data back to the csv file
csample2 <- read.csv("data//Video2_cleancomments.csv", header = FALSE, as.is = TRUE)
csample2<-na.omit(csample2)
write.csv(csample2,"data/Video2_cleancomments.csv", row.names=FALSE)
