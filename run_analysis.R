# Step 1. Downloading and unzipping dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Step 2. Merging the training and the test sets to create one data set:
# Reading trainings tables:
x_train_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train_data <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train_data <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test_data <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test_data <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features_data <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels_data = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Assigning column names:
colnames(x_train_data) <- features[,2] 
colnames(y_train_data) <-"activityId"
colnames(subject_train_data) <- "subjectId"

colnames(x_test_data) <- features_data[,2] 
colnames(y_test_data) <- "activityId"
colnames(subject_test_data) <- "subjectId"

colnames(activityLabels_data) <- c('activityId','activityType')

# Merging all data in one set:
mrg_train_data <- cbind(y_train_data, subject_train_data, x_train_data)
mrg_test_data <- cbind(y_test_data, subject_test_data, x_test_data)
setAllInOne <- rbind(mrg_train_data, mrg_test_data)

# Step 3. Extracting only the measurements on the mean and standard deviation for each measurement
# Reading column names
colNames <- colnames(setAllInOne)

# create vector for defining ID, mean and standard deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) )

# Making nessesary subset from setAllInOne
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# Step 4.Using descriptive activity names to name the activities in the data set:
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# Step 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject:
# Making second tidy data set
secTidyDataSet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidyDataSet <- secTidyDataSet[order(secTidyDataSet$subjectId, secTidyDataSet$activityId),]

# Writing second tidy data set in txt file
write.table(secTidyDataSet, "secTidyDataSet.txt", row.name=FALSE)