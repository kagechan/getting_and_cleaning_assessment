# Getting and Cleaning Data Course Project
## Purpose
 This R script is used to prepare tidy data that can be used for later analysis from the raw data from several wearable computers.

## What this R script does
 This R script deals with the raw data as follows:

 1. Merges the training and the test sets taken from the Coursera Course page to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement.  
    (Extracts only the measurements whose names are mean() or std() with grep function)
 3. Uses descriptive acitivity names to names the activities in the data set.  
    (Used y_test.txt file and activity_label.txt file to merge Activity names and y_train data)
 4. Appropriately labels the data set with descriptive variable names.  
    (Add activity names to the extracted data set in procedure 2.)
 5. From the data set in step 4, creates a second, independent tidy data set
    with the average of each variable for each activity and each subject.

