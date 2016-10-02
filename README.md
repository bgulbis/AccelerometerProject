# AccelerometerProject

## Project Description
The goal of this project is to create a script which will tidy-up data from the Human Activity Recognition database containing the recordings of 30 subjects performing activities of daily living while carrying a waist-mounted smartphone with embedded inertial sensors. The script is saved in the file run\_analysis.R and outputs a text file with the tidy data named tidy\_data.txt.

## Creating the tidy data file
The following steps should be taken to create the tidy data file:

1. Download the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
1. Unzip the file and extract into a folder called "UCI HAR Dataset" within the working directory of the run\_analysis.R script.
1. In R, open the file run\_analysis.R and source the script. This will clean the data and create the tidy dataset.

## Description of run\_analysis.R script
This script performs the following actions:

1. Merges the training and the test data sets to create one data set.
   
   The data for the test and train data sets are each contained in 3 files that make up the set: x\_test.txt, y\_test.txt, and subject\_test.txt. These files are read in and then the x, y, and subject data for test and train are combined.

2. For each measurement, extracts the mean and standard deviation measures.
   
   Only the columns which contain mean and standard deviation measures are retained in the tidy data. Columns such as "meanFreq" are not considered to be measures of mean and are not included.

3. Renames the activities using descriptive activity names.
   
   There were six activities performed by the subjects: walking, walking upstairs, walking downstairs, sitting, standing, and laying. The activity variable is changed from using a numeric value to indicate which activity was performed to a descriptive activity name of the factor class. The descriptive activity names were taken from the activity_labels.txt file. 

4. Labels the data set columns with descriptive variable names. 
   
   The column names for all of the measurement vairables are changed to more descriptive names. The descriptive naming schema used includes up to six parts:
   
  * Signal domain: time or frequency
  * Sensor acceleration signal: body or gravity
  * Sensor signal: accelerometer or gyroscope
  * Signal derivation: jerk or NA
  * Signal calculation: magnitude or NA
  * Calculation: mean or standard deviation
  * Axis: x-axis, y-axis, or z-axis

5. Creates a tidy data set with the average of each variable for each activity and each subject.
   
   The combined data set is grouped by person and then by activity, and then the average is calculated for each mean and standard deviation measurement. The resulting data set is output in a wide form of tidy data into a text file called tidy_data.txt which can be used for future analysis. 

