run_analysis <- function(fName = "data.txt") {
  setInternet2(TRUE)
  zipFile <- 'getdata-projectfiles-UCI-HCR-Dataset.zip'
  unzipDir <- 'UCI HAR Dataset'
  
  ## Download the specified zip file if it doesn't exist in the current directory.
  if (!(zipFile %in% dir())) {
    print("Downloading data file...")
    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
              destfile=zipFile)
  }
  
  ## Unzip the zip file downloaded before.
  unzip(zipFile, overwrite = FALSE)
  
  ## Read Training Data into trainDat, ytrainDat.
  trainDat <- read.table(file="UCI HAR Dataset/train/X_train.txt", header = FALSE)
  ytrainDat <- read.table(file="UCI HAR Dataset/train/y_train.txt", header = FALSE, 
                          col.names=c("activity"))
  ## And subject data for the training data.
  trainSubDat <- read.table(file="UCI HAR Dataset/train/subject_train.txt", header=FALSE)
  
  ## Read Feature and activity label.
  featureLab <- read.table(file="UCI HAR Dataset/features.txt", header=F,
                           col.names = c("value", "FeatureName"))
  actLab <- read.table(file="UCI HAR Dataset/activity_labels.txt", header=F, 
                       col.names=c("value", "actName"))
  colnames(trainDat) <- as.character(featureLab$FeatureName)

  ## Read Test Data into testDat, ytestDat.
  testDat <- read.table(file="UCI HAR Dataset/test/X_test.txt", header= FALSE)
  ytestDat <- read.table(file="UCI HAR Dataset/test/y_test.txt", header= FALSE,
                         col.names=c("activity"))
  ## And subject data for the test data.
  testSubDat <- read.table(file="UCI HAR Dataset/test/subject_test.txt", header=FALSE)
  colnames(testDat) <- as.character(featureLab$FeatureName)

  ## 1. Merges the training and the test sets to create one data set.
  dataSet <- rbind(trainDat, testDat)
  
  ## 2. Extracts only the measurements on the mean and standard deviation
  ##    for each measurement.
  ##    (Extract only the measurements whose names are mean() or std())
  extDataSet <- dataSet[,grep(pattern = "(mean|std)\\(\\)", colnames(dataSet))]
  
  ## 3. Uses descriptive activity names to name the activities in the data set
  ##    Used y_test.txt file and activity_label.txt fileto merge Activity names
  ##    and y_train Data.
  yDataSet <- rbind(ytrainDat, ytestDat)
  subData  <- rbind(trainSubDat, testSubDat)
  yDataSet <- merge(yDataSet, actLab, by.x = "activity", by.y = "value", all = F)
  
  ## 4. Appropriately labels the data set with descriptive variable names.
  ## add activity names to the extracted data set in procedure 2.
  extDataSetColnames <- colnames(extDataSet)
  extDataSet <- cbind(subData, yDataSet$actName, extDataSet)
  colnames(extDataSet) <- c("Subject", "Activity", extDataSetColnames)

  ## 5.From the data set in step 4, creates a second, independent tidy data set
  ##   with the average of each variable for each activity and each subject.
  splitData <- split(extDataSet, list(extDataSet$Subject, extDataSet$Activity),drop=TRUE)
  aveData <- sapply(splitData, function(subAct) {
    dataCols <- grep("Subject|Activity", names(subAct),invert=TRUE)
    subAct <- subAct[,dataCols]
    colMeans(subAct,na.rm=TRUE)
  })
  df = data.frame(t(aveData))
  
  ## Write merged data frame
  write.table(df, file=fName, row.names=FALSE)
}