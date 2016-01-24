#LIBRARIES
install.packages("plyr") # install library  plyr for ldply
library("plyr")
install.packages("rjson") # install library JSON
library("rjson")



# BASIC CONFIGURATION
# this is my API youtube key you can get a new one following the steps in this page:
#https://developers.google.com/youtube/v3/getting-started

# API documentation  https://developers.google.com/youtube/v3/docs/videos/list
Key <- "Your key here"
Part <- "id" # id is the alpha numeric youtube video identifier
Chart <- "mostPopular" # The chart parameter identifies the chart that you want to retrieve
Region <- "US"   # The parameter value is an ISO 3166-1 alpha-2 country code
Maxresults <-50 #The maxResults parameter specifies the maximum number of items that should be retrieved (1-50) 

# Build the URL we want to call
url1 <- paste("https://www.googleapis.com/youtube/v3/videos?part=", Part, "&chart=", Chart,"&maxResults=" , Maxresults  , "&regionCode=", Region,"&key=",Key, sep="")

res1 <- fromJSON(file=url1)
length(res1$items)
# Which slots are there for each result?
names(res1$items[[1]])
# Look at id of the first item
res1$items[[1]]$id
# Helper function to turn one video id in JSON format into a data.frame
parseRow <- function(x) {
  return( data.frame(id=x$id))
}

# Call the parseRow function for every video in the result set
df1 <- ldply(res1$items, parseRow)
#take 2 random videos 

popular_videos=sample(df1$id,size=2, replace=FALSE)

#open the videos on browser
#browseURL(paste("https://www.youtube.com/watch?v=",popular_videos[1] , sep = "" ))
#browseURL(paste("https://www.youtube.com/watch?v=",popular_videos[2] , sep = "" ))
   


popular_videos<-c("CevxZvSJLk8") #katy perry

# Helper function to turn one video id in JSON format into a data.frame
# you can use this web to verify the JSON structure, it helps to figure out the structure: 
# http://jsonviewer.stack.hu/#http://gdata.youtube.com/feeds/api/videos/F3ev88fqMKo/comments?orderby=published&alt=json&max-results=50&start-index=1
parseRow2 <- function(x) {
  return( data.frame(id=x$id$"$t",
                     published=x$published$"$t",
                     updated=x$updated$"$t",
                     category=x$category[[1]]$term,
                     title=x$title$"$t",
                     content=x$content$"$t",
                     link=x$link[[3]]$href,
                     author=x$author[[1]]$name$"$t",
                     AuthorUri=x$author[[1]]$uri$"$t",
                     YtChannelId=x$"yt$channelId"$"$t",
                     YtGooglePlusUserId=x$"yt$googlePlusUserId"$"$t",
                     YtReplyCount=x$"yt$replyCount"$"$t",
                     YtVideo=x$"yt$videoid"$"$t"))
}


#function to sleep
delay <- function(x)
{
  p1 <- proc.time()
  Sys.sleep(x)
  proc.time() - p1 # The cpu usage should be negligible
}


MaxResults<-"50" # max number of comments to retrieve, valid between 1 and 50
OrderBy<-"published"
#NumberPages<-5 #each page has 50 video comments
StartIndex<-"1"

for (v in 1: length(popular_videos) )
{
  VideoId<-popular_videos[v]
 
 
  df2<-NULL
  url2<-paste("http://gdata.youtube.com/feeds/api/videos/",VideoId,"/comments?orderby=",OrderBy,"&alt=json&max-results=",MaxResults,"&start-index=",StartIndex,sep="")
  print(paste("Comments for: ",VideoId))
 
  while (url2 != "")
  {
    res2 <- fromJSON(file=url2)  
    dfaux <- ldply(res2$feed$entry, parseRow2)
    NumComments<-nrow(dfaux)
    print(paste("number of comments: ",toString(NumComments)))
    if (NumComments>0)
    {
      if(is.null(df2))
      {
        df2<-dfaux
        
      }
      else
      {
        df2<-rbind(df2,dfaux)
      }
      
    }
    #delay(5)
    
    #youtube API uses a token for pagination purposes, after the first query is executed, youtube API responds with some  
    # URL, one of this URLs is used to paging results forward. In the following lines I look for the "next"
    # paging result and if I can't find the "next" URL, that means that API will not retrieve more comments
    # (1000 comments limit) or the video doesn't have more comments.
    # update: the 1000 comments limit is not true, I think this applies to other types of listing like videos,
    # but not for commnents, actually I used Katy Perry's video (CevxZvSJLk8) and I stoped the progrma after 2632 comments.  
    # I suggest to read the API documentation to clarify this topic.
    # https://developers.google.com/youtube/2.0/reference#Paging_through_Results
    nextlink<-res2$feed$link
    
    # condition to finish the loop
    url2<-"" 
    for (l in 1:length(nextlink)) 
     {
       if (nextlink[[l]]$rel=="next") #next link exists
       {
          url2<-nextlink[[l]]$href 
       }
      }
   
    
  }
  
  print(paste("Total number of comments: ",nrow(df2)))
  # writes comments to file
  write.csv(df2, file = paste("Video_",VideoId, ".csv",sep=""), row.names=FALSE )
  
}



