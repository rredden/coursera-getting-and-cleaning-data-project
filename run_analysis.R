library(plyr)
#library(dplyr)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


# Step 1
# Merge the training and test sets to create one data set
###############################################################################

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
#train <- cbind(subject_train, y_train, x_train)

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
#test <- cbind(subject_test, y_test, x_test)

#allData <- rbind(train, test)

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)


# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
# The column names(measurements) are being added
###############################################################################

features <- read.table("UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]


# Step 3
# Use descriptive activity names to name the activities in the data set
# The row names(ativities) is being added
###############################################################################

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"


# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(y_data, x_data, subject_data)


# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################
all_data2 <- aggregate(. ~subject + activity, all_data, mean)
all_data2 <- all_data2[order(all_data2$subject,all_data2$activity),]

write.table(all_data2, file = "tidydata.txt",row.name=FALSE)
