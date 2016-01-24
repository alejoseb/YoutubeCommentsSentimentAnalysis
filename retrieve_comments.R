#DESCRIPTION:
# This file is the original code to retrieve random popular videos.
# The updated code was merged with the random_popular_vidreo.R file



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


i<-1
df2<-NULL
for (i in 1:3)
{
  MaxResults<-"50" # max number of comments to retrieve, valid between 1 and 50
  VideoId<-"F3ev88fqMKo"
  OrderBy<-"published"
  print(toString(i))
  StartIndex<-toString(i) # index or page of comments, depends on MaxResults and number of video's comments
  url2<-paste("http://gdata.youtube.com/feeds/api/videos/",VideoId,"/comments?orderby=",OrderBy,"&alt=json&max-results=",MaxResults,"&start-index=",StartIndex,sep="")
  res2 <- fromJSON(file=url2)
  dfaux <- ldply(res2$feed$entry, parseRow2)
  NumComments<-nrow(dfaux)
  NumComments
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
  delay(5)
}

write.csv(df2, file = paste( "Video_",VideoId , ".csv",eps=""), row.names=FALSE )


