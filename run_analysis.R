# Coursera "Getting and Cleaning Data" Project Assignment
# by Cocu
# 18-10-2015

#The datasets were unzipped into the Folder "UCI HAR Dataset"
# set working directory
setwd("/Users/christiankukuk/R workspace/UCI HAR Dataset")


# PART1: Prepare and merge data into one dataset

# Load data
Activity_Labels <- read.table("activity_labels.txt",   header = FALSE)
Activity_Test   <- read.table("Y_test.txt",            header = FALSE)
Activity_Train  <- read.table("Y_train.txt",           header = FALSE)

Subject_Train   <- read.table("subject_train.txt",     header = FALSE)
Subject_Test    <- read.table("subject_test.txt",      header = FALSE)

Feature_Names   <- read.table("features.txt",          header = FALSE)
Features_Test   <- read.table("X_test.txt",            header = FALSE)
Features_Train  <- read.table("X_train.txt",           header = FALSE)

# Look at the data variables
str(Activity_Test)
str(Activity_Train)
str(Subject_Test)
str(Subject_Train)
str(Features_Train)
str(Features_Test)

# Assigin column names for activity and subject datasets
colnames(Activity_Labels) = c('Activity_ID','Activity_Type')
colnames(Activity_Train)  = "Activity_ID"
colnames(Activity_Test)   = "Activity_ID"
colnames(Subject_Test)   = "Subject_ID"
colnames(Subject_Train)   = "Subject_ID"

#Merge Data for Subjects, Features and Activities
Subject_data <- rbind(Subject_Train, Subject_Test)
Activity_data<- rbind(Activity_Train, Activity_Test)
Feature_data<- rbind(Features_Train, Features_Test)

#Check merged data
str(Subject_data)
names(Subject_data) # ok

str(Activity_data)
names(Activity_data)   #ok

#For feature data the names had to be set first
colnames(Feature_data)= Feature_Names[, 2]
str(Feature_data)
names(Feature_data)

# merge columns to get the data frame "total_data"
dataCombine <- cbind(Subject_data, Activity_data)
total_data <- cbind(Feature_data, dataCombine)

# Check: Look at the datasets
head(total_data)      
str(total_data)  
# 'data.frame':	10299 obs. of  563 variables:
# ok


# PART2:
# Extracts only the measurements on the mean and standard deviation for each measurement

# Therefore, look at feature names
Feature_Names

# Select only those features including "mean" or "std"
Sub_Features <- Feature_Names$V2[grep("mean\\(\\)|std\\(\\)", Feature_Names$V2)]
# include "subject" and "activity"
Features_selected <- c("Subject_ID", "Activity_ID", as.character(Sub_Features))
#QC
Features_selected

# Set exctracted data
extracted_data <- subset(total_data, select=Features_selected)
#QC
head(extracted_data)
str(extracted_data)


# PART3:
# Uses descriptive activity names to name the activities in the data set

# Merge the data set with the acitivityType table to include descriptive activity names
descriptive_data = merge(extracted_data, Activity_Labels, by='Activity_ID', all.x=TRUE)

# Check results
levels(descriptive_data$Activity_Type)

# PART4:
# Appropriately labels the data set with descriptive variable names

# remove ()
# mean is replaced by Mean
# std is replaced by StdDev
# prefix t is replaced by time
# prefix f is replaced by freq
# lower upper case transofmration for body, gravitiy, gyro
# BodyBody is replaced by Body
# Gyro is replaced by Gyroscope
# Mag is replaced by Magnitude
# Acc is replaced by Accelerometer

names(descriptive_data) <- gsub("\\()","",names(descriptive_data))
names(descriptive_data) <- gsub("-std","StdDev",names(descriptive_data))
names(descriptive_data) <- gsub("-mean","Mean",names(descriptive_data))
names(descriptive_data) <- gsub("^(t)","time",names(descriptive_data))
names(descriptive_data) <- gsub("^(f)","freq",names(descriptive_data))
names(descriptive_data) <- gsub("([Gg]ravity)","Gravity",names(descriptive_data))
names(descriptive_data) <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",names(descriptive_data))
names(descriptive_data) <- gsub("[Gg]yro","Gyroscope",names(descriptive_data))
names(descriptive_data) <- gsub("Mag","Magnitude",names(descriptive_data))
names(descriptive_data) <- gsub("Acc", "Accelerometer", names(descriptive_data))

# QC: Check names
names(descriptive_data)
str(descriptive_data)
# data.frame':	10299 obs. of  69 variables:
# looks fine!

# PART5:
# Creates a second,independent tidy data set and ouput it

# First, remove column activity type from descriptive_data
tmp_data <- descriptive_data[,names(descriptive_data) != 'Activity_Type'];


# Now, include mean of each variable for each activity and each subject
tidy_data <- aggregate(tmp_data[,names(tmp_data) != c('Activity_ID','Subject_ID')],
                          by=list(activityId=tmp_data$Activity_ID,
                                  subjectId = tmp_data$Subject_ID),
                                  mean);

# Now re-include activity type
tidy_data    = merge(tidy_data, Activity_Type, by='Activity_ID',all.x=TRUE);

# Check final dataset for its tidiness
head(tidy_data)
names(tidy_data)
str(tidy_data)
# data.frame':	180 obs. of  68 variables:


# Create output text file
write.table(tidy_data, file = "tidy_data.txt",row.name=FALSE)
