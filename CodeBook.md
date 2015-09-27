The script run_analysis.r has to do the following actions:

1 - Merges the training and the test sets to create one data set.
2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
3 - Uses descriptive activity names to name the Activities in the data set
4 - Appropriately labels the data set with descriptive variable names. 
5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Collecting data

The script will load the following files:

* subject_train.txt
* subject_test.txt
* X_train.txt
* X_test.txt
* y_train.txt
* y_test.txt
* features.txt

And assign them to data sets.

#Processing the data

The mean and standard deviation will be calculated for the X_train and X_test. Then these data sets will be merged into one:

dt.x_test <- dt.x_test[,grepl("mean|std", dt.Labels.features)]
dt.x_train <- dt.x_train[,grepl("mean|std", dt.Labels.features)]

dt.mean_std_train_test <- rbind(dt.x_test, dt.x_train)

The activities IDs and Names will be merged into one dataset for the Y_test ans Y_train:

dt.y_test[,2] <- dt.Labels.activity[dt.y_test[,1]]
dt.y_train[,2] <- dt.Labels.activity[dt.y_train[,1]]

names(dt.y_test) <- c("Activity_ID", "Activity_Name")
names(dt.y_train) <- c("Activity_ID", "Activity_Name")
dt.Activities <- rbind(dt.y_test, dt.y_train)

The subject_train and subject_test will be aldo merged:

dt.Subject <- rbind(dt.Subject_test, dt.Subject_train)
colnames(dt.Subject) <- "Subject_Number"

Now, the tree datasets created (mean_std_train_test, Activities and Subject) will be merged in one dataset:

dt.Test_Train <- cbind(as.data.table(dt.Subject), dt.Activities, dt.mean_std_train_test)

This new dataset has the columns "Subject_Number", "Activity_ID", "Activity_Name" besides the measures of the X_test and X_train datasets.

Than, a new independent tidy data set with the average of each variable for each activity and each subject will be created:

ID   = c("Subject_Number", "Activity_ID", "Activity_Name")
data = setdiff(colnames(dt.Test_Train), ID)
dt.Tidy = melt(dt.Test_Train, id = ID, measure.vars = data)

dt.tidydata = dcast(dt.Tidy, Subject_Number + Activity_ID ~ variable, mean)

#Tidy data created

The tidy_data.txt consists of the following variables:
 "Subject_Number": The subject who performed the activity for each window sample.                 
 "Activity_ID"   : The ID of the activity that generates this row of analysis.   

 The following data are the average of each variable for each activity and each subject:
 [3] "tBodyAcc-mean()-X"               "tBodyAcc-mean()-Y"              
 [5] "tBodyAcc-mean()-Z"               "tBodyAcc-std()-X"               
 [7] "tBodyAcc-std()-Y"                "tBodyAcc-std()-Z"               
 [9] "tGravityAcc-mean()-X"            "tGravityAcc-mean()-Y"           
[11] "tGravityAcc-mean()-Z"            "tGravityAcc-std()-X"            
[13] "tGravityAcc-std()-Y"             "tGravityAcc-std()-Z"            
[15] "tBodyAccJerk-mean()-X"           "tBodyAccJerk-mean()-Y"          
[17] "tBodyAccJerk-mean()-Z"           "tBodyAccJerk-std()-X"           
[19] "tBodyAccJerk-std()-Y"            "tBodyAccJerk-std()-Z"           
[21] "tBodyGyro-mean()-X"              "tBodyGyro-mean()-Y"             
[23] "tBodyGyro-mean()-Z"              "tBodyGyro-std()-X"              
[25] "tBodyGyro-std()-Y"               "tBodyGyro-std()-Z"              
[27] "tBodyGyroJerk-mean()-X"          "tBodyGyroJerk-mean()-Y"         
[29] "tBodyGyroJerk-mean()-Z"          "tBodyGyroJerk-std()-X"          
[31] "tBodyGyroJerk-std()-Y"           "tBodyGyroJerk-std()-Z"          
[33] "tBodyAccMag-mean()"              "tBodyAccMag-std()"              
[35] "tGravityAccMag-mean()"           "tGravityAccMag-std()"           
[37] "tBodyAccJerkMag-mean()"          "tBodyAccJerkMag-std()"          
[39] "tBodyGyroMag-mean()"             "tBodyGyroMag-std()"             
[41] "tBodyGyroJerkMag-mean()"         "tBodyGyroJerkMag-std()"         
[43] "fBodyAcc-mean()-X"               "fBodyAcc-mean()-Y"              
[45] "fBodyAcc-mean()-Z"               "fBodyAcc-std()-X"               
[47] "fBodyAcc-std()-Y"                "fBodyAcc-std()-Z"               
[49] "fBodyAcc-meanFreq()-X"           "fBodyAcc-meanFreq()-Y"          
[51] "fBodyAcc-meanFreq()-Z"           "fBodyAccJerk-mean()-X"          
[53] "fBodyAccJerk-mean()-Y"           "fBodyAccJerk-mean()-Z"          
[55] "fBodyAccJerk-std()-X"            "fBodyAccJerk-std()-Y"           
[57] "fBodyAccJerk-std()-Z"            "fBodyAccJerk-meanFreq()-X"      
[59] "fBodyAccJerk-meanFreq()-Y"       "fBodyAccJerk-meanFreq()-Z"      
[61] "fBodyGyro-mean()-X"              "fBodyGyro-mean()-Y"             
[63] "fBodyGyro-mean()-Z"              "fBodyGyro-std()-X"              
[65] "fBodyGyro-std()-Y"               "fBodyGyro-std()-Z"              
[67] "fBodyGyro-meanFreq()-X"          "fBodyGyro-meanFreq()-Y"         
[69] "fBodyGyro-meanFreq()-Z"          "fBodyAccMag-mean()"             
[71] "fBodyAccMag-std()"               "fBodyAccMag-meanFreq()"         
[73] "fBodyBodyAccJerkMag-mean()"      "fBodyBodyAccJerkMag-std()"      
[75] "fBodyBodyAccJerkMag-meanFreq()"  "fBodyBodyGyroMag-mean()"        
[77] "fBodyBodyGyroMag-std()"          "fBodyBodyGyroMag-meanFreq()"    
[79] "fBodyBodyGyroJerkMag-mean()"     "fBodyBodyGyroJerkMag-std()"     
[81] "fBodyBodyGyroJerkMag-meanFreq()"



