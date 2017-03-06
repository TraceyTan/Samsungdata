---
title: "CodeBook"
author: "Tracey Tan"
date: "5 March 2017"
output: md_document
---

## run_analysis.R

This run_analysis() function outputs a single, independent, tidy data set called
"avgsubj", with the average of the mean and s.d. for each measurement, broken
down by test subject and activity type.

The component variables of the data set are below.

1. testsubject: An integer value between 1-30, identifying the person performing 
	the activities.

2. activity: A character string describing the activity undertaken.  Can be one
	of six values: laying, sitting, standing, walking, walkingdownstairs,
	walkingupstairs.

3. to 8. tbodyaccmeanx, tbodyaccmeany, tbodyaccmeanz, 
     tbodyaccstdx, tbodyaccstdy, tbodyaccstdz
	The average value of the mean and s.d. of the body acceleration signal
	obtained by subtracting the gravity from the total acceleration. 
	Units are standard gravity units 'g'.

9 to 14. tgravityaccmeanx, tgravityaccmeany, tgravityaccmeanz	
      tgravityaccstdx, tgravityaccstdy, tgravityaccstdz	

15 to 20. tbodyaccjerkmeanx, tbodyaccjerkmeany, tbodyaccjerkmeanz,
       tbodyaccjerkstdx, tbodyaccjerkstdy, tbodyaccjerkstdz	

21 to 26. tbodygyromeanx, tbodygyromeany, tbodygyromeanz,
       tbodygyrostdx, tbodygyrostdy, tbodygyrostdz	
	The average of the mean and s.d. of the angular velocity vector, 
	measured by the gyroscope for each window sample. 
	The units are radians/second. 

27 to 32. tbodygyrojerkmeanx, tbodygyrojerkmeany, tbodygyrojerkmeanz,
       tbodygyrojerkstdx, tbodygyrojerkstdy	tbodygyrojerkstdz	
	Body linear acceleration and angular velocity were derived in time to
	obtain Jerk signals.

33 to 68. tbodyaccmagmean, tbodyaccmagstd,
	tgravityaccmagmean, tgravityaccmagstd,
	tbodyaccjerkmagmean, tbodyaccjerkmagstd,
	tbodygyromagmean, tbodygyromagstd,
	tbodygyrojerkmagmean, tbodygyrojerkmagstd,
	fbodyaccmeanx	fbodyaccmeany	fbodyaccmeanz	
	fbodyaccstdx	fbodyaccstdy	fbodyaccstdz	
	fbodyaccjerkmeanx	fbodyaccjerkmeany	fbodyaccjerkmeanz	
	fbodyaccjerkstdx	fbodyaccjerkstdy	fbodyaccjerkstdz	
	fbodygyromeanx	fbodygyromeany	fbodygyromeanz	
	fbodygyrostdx	fbodygyrostdy	fbodygyrostdz	
	fbodyaccmagmean	fbodyaccmagstd	
	fbodybodyaccjerkmagmean	fbodybodyaccjerkmagstd	
	fbodybodygyromagmean	fbodybodygyromagstd	
	fbodybodygyrojerkmagmean	fbodybodygyrojerkmagstd	

69 testortrain: Whether the subject was originally allocated to the 'test' or 
	'training' data set.

================================================================================

### Other notes 

This run_analysis.R() function:
* Creates a subfolder called "data" (unless it already exists)
* Downloads a zip file into it named "samsungdata.zip" from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* After downloading the zipfile, the function "unzip("samsungdata.zip", list=TRUE)" was used to view its contents.  The following files were identified to read in:
	UCI HAR Dataset/features.txt
	UCI HAR Dataset/activity_labels.txt
	UCI HAR Dataset/test/X_test.txt
	UCI HAR Dataset/test/y_test.txt
	UCI HAR Dataset/test/subject_test.txt
	UCI HAR Dataset/train/subject_train.txt 
	UCI HAR Dataset/train/X_train.txt
	UCI HAR Dataset/train/y_train.txt     
* Set variable names from 'features.txt'
* Merge the test and training data into one dataset 'samsungdata'
* Add a column called "activity", generated from 'y_test.txt', 'y_train.txt' and 'activities_labels.txt'
* Add a column called "testortrain", which indicates whether the data came from the 'test' or 'train' dataset.
* Add a column called "testsubject", identifying (by number, 1-30) the person who performed the activity.
* Extract from the dataset only the mean and s.d. for each measurement, found by searching variable names for "mean()" and "std()".
* Create a new dataset called "avgsubj", containing the average mean and s.d. of each measurement, for each test subject and each activity.
