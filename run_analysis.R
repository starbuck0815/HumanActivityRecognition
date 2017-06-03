# This script loads the "UCI Human Activity Recognition Using Smartphones Data Set".
# test and training data sets are merged with their subject and activity labels,
# ans subsequently the provided mean() and std() data are filtered and 
# aggregated per subject and activity in order to produce a final tidy datset

# Structure in steps 1-5 are taken from the assignemnt instructions

library(plyr)
library(data.table)
library(reshape2)

# replace with your desired working directory
setwd("C:/Users/Phil/Desktop/Coursera/cleaning")


##----load data----
if(!file.exists("data")){
        dir.create("data")
}

zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url=zip_url, destfile="./data/ActivityData.zip", method="curl")    
dateDownloaded <- Sys.time()
unzip("./data/ActivityData.zip", exdir="./data")




####
#Step1: Merges the training and the test sets to create one data set.
####

####----column/feature names ----
#read feature names from "features.txt"
#returns table with col1=FeatureNumber, col2=FeatureName
feature_names<-read.table("./data/UCI HAR Dataset/features.txt")
colnames(feature_names)<-c("FeatureNumber", "FeatureName")

###-----training set----
#read training data set
training_set<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
#add column name information (=FeatureNames)
colnames(training_set)<-feature_names$FeatureName

# read training data labels (single column with activity number)
training_labels<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
colnames(training_labels)<-"ActivityNumber"

# read subject information (single column with subject number)
training_subjects<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
colnames(training_subjects)<-"SubjectNumber"

# add activity and subject numbers to test data set
training_set_labeled<-cbind(training_set, training_labels, training_subjects)

###-----test set----
#read test data set
test_set<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
#add column name information (FeatureNames)
colnames(test_set)<-feature_names$FeatureName

# read test data labels (single column with activity number)
test_labels<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
colnames(test_labels)<-"ActivityNumber"

# read subject information (single column with subject number)
test_subjects<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
colnames(test_subjects)<-"SubjectNumber"
# add activity and subject numbers to test data set
test_set_labeled<-cbind(test_set, test_labels, test_subjects)

### - test & data set combined ---
# merge labeled training and test data set
full_dataset<-rbind(training_set_labeled, test_set_labeled)


####
#Step2: Extracts only the measurements on the mean and standard deviation for each measurement.
####

# Based on "features_info.txt" and the featurenames in "feature_names", the 
# column names of interest contain the string "mean()" and "std()", respectively;
# need to escape metacharacters "(" and ")" via "\\(" and "\\)" in grep search.
# Also ensure to keep the columns with Activity and Subject labels

mean_std_data<-full_dataset[,grep("mean\\(\\)|std\\(\\)|ActivityNumber|SubjectNumber", 
                                  colnames(full_dataset))]

####
#Step3: Uses descriptive activity names to name the activities in the data set
####

#read activity labels to translate activity number into descriptive activity names
activity_names<-read.table("./data/UCI HAR Dataset/activity_labels.txt")
# 2-column table with Number and Name of Activities
colnames(activity_names)<-c("ActivityNumber", "ActivityName")

# replace Activity Numbers by descriptive Activity names
mean_std_data$ActivityNumber<-mapvalues(mean_std_data$ActivityNumber, 
                                        from=activity_names$ActivityNumber,
                                to=as.character(activity_names$ActivityName))
# rename column for clarity
setnames(mean_std_data, old="ActivityNumber", new="ActivityName")

###
#Step4: Appropriately labels the data set with descriptive variable names.
###

#this step has been carried out at the very beginning, where the Feature names
# have been used to label the test and training data set

###
#Step5: From the data set in step 4, creates a second, independent tidy data set
#       with the average of each variable for each activity and each subject.
###


# reshape data
molten_data<-melt(mean_std_data, id=c("ActivityName","SubjectNumber"))
# calculate mean of every variable over each activity and subject number:
tidy_df<-dcast(molten_data, ActivityName+SubjectNumber~variable, mean)
# rename all column names  appropriately with suffix "-avg"
# except for Activity and Subject column (Cols 1,2)
colnames(tidy_df)<-c(colnames(tidy_df[,1:2]), paste0(colnames(tidy_df[,-(1:2)]),"-avg"))

#final format of tidy data frame: 
# each row contains all averaged measurements for each (activity / subject)
# combination

#write results to file
write.table(tidy_df, file="./data/week4_activity_tidy.txt", row.names=FALSE)
