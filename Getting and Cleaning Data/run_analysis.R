##Getting and Cleaning Data Project

##You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Download and unzip data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./project_data/Dataset.zip")
unzip(zipfile="./project_data/Dataset.zip",exdir="./data")

mypath <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(mypath, recursive=TRUE)
files

##Read in the activity files 
dataActivityTest  <- read.table(file.path(mypath, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(mypath, "train", "Y_train.txt"),header = FALSE)

##Read in the subject files
dataSubjectTrain <- read.table(file.path(mypath, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(mypath, "test" , "subject_test.txt"),header = FALSE)

##Read in features files
dataFeaturesTest  <- read.table(file.path(mypath, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(mypath, "train", "X_train.txt"),header = FALSE)


## Concat training and test data sets using rbind
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)

##Set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(mypath, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

##Merge columns into a single data frame
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

## Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

## Subset Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )

## Read descriptive activity names 
activityLabels <- read.table(file.path(mypath, "activity_labels.txt"),header = FALSE)

## label the data set with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

##Create tidy data set and output
library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "finaldata.txt",row.name=FALSE)

