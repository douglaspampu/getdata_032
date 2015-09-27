#Author: Douglas Cesar Pampu

# 1 - Merges the training and the test sets to create one data set.
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3 - Uses descriptive activity names to name the Activities in the data set
# 4 - Appropriately labels the data set with descriptive variable names. 
# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
library(reshape2)

#Load the datasets
dir_train <- "data/project/UCI HAR Dataset/train"
dir_tests <- "data/project/UCI HAR Dataset/test"

#Load subject Train and Subject Test datasets

dt.Subject_train <- read.table(paste(dir_train, "subject_train.txt", sep="/"))
dt.Subject_test <- read.table(paste(dir_tests, "subject_test.txt", sep="/"))

#x_train and x_test

dt.x_train <- read.table(paste(dir_train, "X_train.txt", sep="/"))

dt.x_test <- read.table(paste(dir_tests, "X_test.txt", sep="/"))

#y_train and y_test

dt.y_train <- read.table(paste(dir_train, "y_train.txt", sep="/"))

dt.y_test <- read.table(paste(dir_tests, "y_test.txt", sep="/"))

#Load the features, skips the first column with the row number
dt.Labels.features <- read.table("data/project/UCI HAR Dataset/features.txt")[,2]

# Uses descriptive activity names to name the Activities in the data set
# Label the test and train data sets
names(dt.x_test) <- dt.Labels.features
names(dt.x_train) <- dt.Labels.features

#Extracts only the measurements on the mean and standard deviation for each measurement.

#Extract he standard deviation and mean for X dataset
dt.x_test <- dt.x_test[,grepl("mean|std", dt.Labels.features)]
dt.x_train <- dt.x_train[,grepl("mean|std", dt.Labels.features)]

#Merge X train and test dataset
dt.mean_std_train_test <- rbind(dt.x_test, dt.x_train)

#Load the Activities labels, skips the first column with the row number
dt.Labels.activity <- read.table("data/project/UCI HAR Dataset/activity_labels.txt")[,2]

#Add a column for the Activities labels and name them
dt.y_test[,2] <- dt.Labels.activity[dt.y_test[,1]]
dt.y_train[,2] <- dt.Labels.activity[dt.y_train[,1]]

names(dt.y_test) <- c("Activity_ID", "Activity_Name")
names(dt.y_train) <- c("Activity_ID", "Activity_Name")

#Merge Y train and test dataset
dt.Activities <- rbind(dt.y_test, dt.y_train)

#Merge Subject Test and Train
dt.Subject <- rbind(dt.Subject_test, dt.Subject_train)
colnames(dt.Subject) <- "Subject_Number"

#Merge X dataset, Y dataset and Subject dataset
dt.Test_Train <- cbind(as.data.table(dt.Subject), dt.Activities, dt.mean_std_train_test)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

ID   = c("Subject_Number", "Activity_ID", "Activity_Name")
data = setdiff(colnames(dt.Test_Train), ID)
dt.Tidy = melt(dt.Test_Train, id = ID, measure.vars = data)

dt.tidydata = dcast(dt.Tidy, Subject_Number + Activity_ID ~ variable, mean)

# Write the new dataset

write.table(dt.tidydata, file = "tidy_data.txt", row.name = FALSE)