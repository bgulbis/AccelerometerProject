## Getting and Cleaning Data - Course Project
## script: run_analysis.R
## 
## This script performs the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for 
##      each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. Creates a second, independent tidy data set with the average of each 
##      variable for each activity and each subject.

## obtain data from source
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

library(dplyr)

## get the test data sets
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")
testSbj <- read.table("UCI HAR Dataset/test/subject_test.txt")

## get the train data sets
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSbj <- read.table("UCI HAR Dataset/train/subject_train.txt")

## merge test and train
dataX <- bind_rows(testX, trainX)
dataY <- bind_rows(testY, trainY) %>% rename(activity = V1)
dataSbj <- bind_rows(testSbj, trainSbj) %>% rename(person = V1)

## get the column names for the X data, contained in features.txt
ftr <- read.table("UCI HAR Dataset/features.txt")

## find the columns which are either a mean or standard deviation
keepX <- grep("mean|std", ftr[[2]])

## select only those columns that have mean or standard deviation
data <- select(dataX, keepX)
colnames(data) <- as.character(ftr[keepX,2])
data <- bind_cols(dataSbj, dataY, data) %>%
        mutate(person = as.factor(person), activity = as.factor(activity))

## cleanup data frames which are no longer needed
rm(testX, testY, testSbj, trainX, trainY, trainSbj, dataX, dataY, dataSbj)
