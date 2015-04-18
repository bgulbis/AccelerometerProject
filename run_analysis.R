## Getting and Cleaning Data - Course Project
## script: run_analysis.R
## 
## Description: This script performs the following actions:
## 1. Merges the training and the test data sets to create one data set.
## 2. For each measurement, extracts the mean and standard deviation measures.
## 3. Renames the activities using descriptive activity names.
## 4. Labels the data set columns with descriptive variable names. 
## 5. Creates a tidy data set in a wide form with the average of each variable for each 
##    activity and each subject.

## The data for this script was obtained from: 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## The data should be unzipped into a folder called "UCI HAR Dataset" within 
## the working directory of this script.

## The dplyr library will be used for table manipulation.
library(dplyr)

## Get the test data sets, by reading in the 3 files that make up the set:
## x_test.txt contains the measurements
## y_test.txt contains the labels for the measurements
## subject_test.txt contains the subject id number
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")
testSbj <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Get the train data sets, follows the same settings as the test data set.
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSbj <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Merge the x, y, and subject data sets from test and train.
## Rename the columns for y and subject data with descriptive names.
dataX <- bind_rows(testX, trainX)
dataY <- bind_rows(testY, trainY) %>% rename(activity = V1)
dataSbj <- bind_rows(testSbj, trainSbj) %>% rename(person = V1)

## Get the column names for the x data from features.txt.
ftr <- read.table("UCI HAR Dataset/features.txt")

## Get the labels for each activity from activity_labels.txt which will be used
## to make descriptive activity names. Format all the labels as lower-case.
act <- read.table("UCI HAR Dataset/activity_labels.txt")
act[[2]] <- tolower(act[[2]])

## Find the columns which are either a mean or standard deviation.
## Note: columns such as "meanFreq" are not considered as measures of mean
## and will not be included in the tidy data set.
keepX <- grep("mean\\(|std\\(", ftr[[2]])

## Make the names of the columns more descriptive. Convert to lower-case names.
Xnames <- tolower(as.character(ftr[keepX,2]))
## Remove parenthesis from the names.
Xnames <- gsub("\\(\\)", "", Xnames)
## Names which start with "t" are time values, use "time" instead.
Xnames <- gsub("^t", "time-", Xnames)
## Names which start with "f" are frequency values, use "frequency" instead. 
Xnames <- gsub("^f", "frequency-", Xnames)
## Names which contain "acc" represent accelerometer measures, use "accelerometer".
Xnames <- gsub("acc", "-accelerometer", Xnames)
## Names which contain "gyro" reperseent gyroscope measures, use "gyroscope".
Xnames <- gsub("gyro", "-gyroscope", Xnames)
## "std" represents standard deviation, use "standdev".
Xnames <- gsub("std", "standdev", Xnames)
## Names with "jerK" reperesents Jerk measurements
Xnames <- gsub("jerk", "-jerk", Xnames)
## Names with "mag" represents magnitude measurements, use "magnitude".
Xnames <- gsub("mag", "-magnitude", Xnames)
## The letter x, y, or z at the end of name describes which axis the value
## is measuring, substitute a more descriptive name for each axis.
Xnames <- gsub("x$", "x-axis", Xnames)
Xnames <- gsub("y$", "y-axis", Xnames)
Xnames <- gsub("z$", "z-axis", Xnames)
## Fix those names which contain body twice
Xnames <- gsub("bodybody", "body", Xnames)

## Select only those columns that have mean or standard deviation.
data <- select(dataX, keepX) 
## Use the descriptive column names created above.
colnames(data) <- Xnames
## Join the subject, y, and x data columns together in one table called "data".
## Make the subject id (person column) into a factor.
## Make the activity label (from y data set) into a factor using the levels
## and labels for the factors from the activity_labels.txt file.
data <- bind_cols(dataSbj, dataY, data) %>%
        mutate(person = factor(person), 
               activity = factor(activity, levels=act[[1]], labels=act[[2]]))

## Remove the individual data frames which are no longer needed.
rm(testX, testY, testSbj, trainX, trainY, trainSbj, dataX, dataY, dataSbj)

## Group the data by person and then by activity. For each measure, 
## calculate the mean using the summarise_each function (this will apply 
## the mean to each column in the table).
tidy <- group_by(data, person, activity) %>%
            summarise_each(funs(mean))

## Outupt the tidy data into a text file.
write.table(tidy, "tidy_data.txt", row.names=FALSE)

## End of the script