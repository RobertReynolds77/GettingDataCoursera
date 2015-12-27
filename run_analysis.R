setwd("C:/Users/RJR/Documents/SpiderOak Hive/School/Coursera/Data Science Certification/03 Getting Data/Project/UCI HAR Dataset")
library(data.table)

## Read in the test and training datasets
trainy <- fread("train/y_train.txt"); names(trainy)[1] <- "activity"
trainx <- fread("train/X_train.txt");  
testx <- fread("test/X_test.txt"); 
testy <- fread("test/y_test.txt"); names(testy)[1] <- "activity"

## Read in the particpant numbers
trainsubjects <- fread("train/subject_train.txt") ; names(trainsubjects)[1] <- "subjectID"
testsubjects <- fread("test/subject_test.txt") ; names(testsubjects)[1] <- "subjectID"

## Attach the targets to the features
trainxy <- cbind(trainx,trainy)
testxy <- cbind(testx,testy)

## Attach the subject IDs to the features
trainxys <- cbind(trainxy,trainsubjects)
testxys <- cbind(testxy,testsubjects)

## Combine the test and training sets
dat1 <- rbind(trainxys,testxys)

## Name the columns using the labels from the features.txt file
features <- read.table("features.txt",stringsAsFactors=F)
colkeep <- features[grep("mean\\()|std\\()",features$V2,fixed=F),]
  colkeep[,2] <- gsub("mean\\()","Mean",colkeep$V2)
  colkeep[,2] <- gsub("std\\()","StDev",colkeep$V2)
  colkeep[,2] <- gsub("-","",colkeep$V2)

dat2 <- subset(dat1,select=c(colkeep[,1],562:563))
  names(dat2)[1:(ncol(dat2)-2)] <- colkeep[,2]
  
## Compute means by subjectID and activity then output to pipe-delimited text file
meanset <- with(dat2,aggregate(dat2,list(activitycat=activity,subjectIDcat=subjectID),mean))
  names(meanset)[1:68] <- paste("MEAN",names(meanset[1:68]),sep="")
  write.table(cbind(meanset[,69:70],meanset[,3:67]),file="../meanset.txt",sep="|",row.name=FALSE)
