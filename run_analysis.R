### ============================================================================
### This function extracts a zipfile containing various datasets collected from
### data collected from the Samsung Galaxy S smartphone.  The output is a
### single, independent tidy data set with the average of each mean and s.d. for
### each measurement, broken down by test subject and activity type.

run_analysis <- function() {

# Download zipfile and unzip data files
     if(!file.exists("./data")){dir.create("./data")}
     fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     download.file(fileURL,"./data/samsungdata.zip")
     subject_test <- read.table(unz("data/samsungdata.zip", 
          "UCI HAR Dataset/test/subject_test.txt"))
     X_test <- read.table(unz("data/samsungdata.zip", 
          "UCI HAR Dataset/test/X_test.txt"))
     Y_test <- read.table(unz("data/samsungdata.zip", 
          "UCI HAR Dataset/test/y_test.txt"))
     subject_train <- read.table(unz("data/samsungdata.zip", 
          "UCI HAR Dataset/train/subject_train.txt"))
     X_train <- read.table(unz("data/samsungdata.zip", 
          "UCI HAR Dataset/train/X_train.txt"))
     Y_train <- read.table(unz("data/samsungdata.zip", 
          "UCI HAR Dataset/train/y_train.txt"))
     features <- read.table(unz("data/samsungdata.zip", 
          "UCI HAR Dataset/features.txt"))
     activities <- read.table(unz("data/samsungdata.zip", 
          "UCI HAR Dataset/activity_labels.txt"))

# Merge data sets
# Set variable names from "features.txt" and add labels from "y_test.txt", 
# "y_train.txt" and "activities_labels.txt"
     activities[,2] <- tolower(gsub("_", "",activities[,2], fixed=TRUE)) 
     testlabels <- rep(NA,nrow(Y_test)) # Initialise vector
     trainlabels <- rep(NA,nrow(Y_train))
     for(i in 1:nrow(Y_test)) testlabels[i] <- activities[as.integer(Y_test[i,1]),2]
     for(i in 1:nrow(Y_train)) trainlabels[i] <- activities[as.integer(Y_train[i,1]),2]
     testdata <- cbind(subject_test, testlabels, X_test, rep("test",length(testlabels)))
     traindata <- cbind(subject_train, trainlabels, X_train, rep("train",length(trainlabels)))
     names(traindata) <- names(testdata)
     samsungdata <- rbind(testdata, traindata)
     names(samsungdata) <- c("testsubject", "activity", tolower(features[,2]), "testortrain")

# Extract only the means or standard deviations.
     means <- grep("mean()", names(samsungdata), fixed=TRUE)
     stds <- grep("std()", names(samsungdata), fixed=TRUE)
     meansdcol <- c(1,2,sort(c(means,stds), decreasing=FALSE),ncol(samsungdata))
     meansd <- samsungdata[,meansdcol]
     names(meansd) <- gsub("(", "", names(meansd), fixed=TRUE) # clean up
     names(meansd) <- gsub(")", "", names(meansd), fixed=TRUE)
     names(meansd) <- gsub("-", "", names(meansd), fixed=TRUE)
     
# From the data set of means and s.d.'s, create a second, independent tidy data 
# set with the average of each variable for each activity and each subject. 
     splitsubject <- split(meansd, meansd$testsubject)
     avgsubj <- data.frame(0)
     nextrow <- 1
     for(i in 1:30) {
          extrarows <- length(levels(splitsubject[[i]]$activity))
          avgsubj[nextrow:(nextrow+extrarows-1),1] <- i
          avgsubj[nextrow:(nextrow+extrarows-1),2] <- levels(splitsubject[[i]]$activity)
          for(j in 3:(ncol(meansd)-1)) {
               avgsubj[nextrow:(nextrow+extrarows-1), j] <- tapply(as.numeric(
                    splitsubject[[i]][,j]), splitsubject[[i]]$activity, mean, 
                    na.rm=TRUE)
          }
          avgsubj[nextrow:(nextrow+extrarows-1),2] <- levels(splitsubject[[i]]$activity)
          avgsubj[nextrow:(nextrow+extrarows-1),ncol(meansd)] <- splitsubject[[i]][1,ncol(meansd)]
          nextrow <- nrow(avgsubj) + 1
     }
     names(avgsubj) <- names(meansd)
     avgsubj
}