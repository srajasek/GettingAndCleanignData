

##Task # 1.Merges the training and the test sets to create one data set.
        ## Read training & test data sets
        workingdir <- getwd()
        parentLocation <- "C:/XXX/Data Science - Coursera/Getting & Cleaning Data/Project1/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset"
        testDataLocation <- "C:/XXX/Data Science - Coursera/Getting & Cleaning Data/Project1/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test"
        trainingDataLocation <- "C:/XXX/Data Science - Coursera/Getting & Cleaning Data/Project1/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train"
        
        testSubjectdt <- read.table(paste(testDataLocation, "/subject_test.txt", sep=""),  header = F, stringsAsFactors = F, fill = T)
        testXtestdt <- read.table(paste(testDataLocation, "/X_test.txt", sep=""),  header = F, stringsAsFactors = F, fill = T)
        testYtestdt <- read.table(paste(testDataLocation, "/Y_test.txt", sep=""),  header = F, stringsAsFactors = F, fill = T)
        
        trainingSubjectdt <- read.table(paste(trainingDataLocation, "/subject_train.txt", sep=""),  header = F, stringsAsFactors = F, fill = T)
        trainingXtestdt <- read.table(paste(trainingDataLocation, "/X_train.txt", sep=""),  header = F, stringsAsFactors = F, fill = T)
        trainingYtestdt <- read.table(paste(trainingDataLocation, "/Y_train.txt", sep=""),  header = F, stringsAsFactors = F, fill = T)
        
        ## Merge train & test data sets into one dataset.
        mergedData <- cbind(rbind(testSubjectdt, trainingSubjectdt),
                            rbind(testXtestdt, trainingXtestdt),
                            rbind(testYtestdt, trainingYtestdt))
        
## Task #4.Appropriately labels the data set with descriptive variable names. 
        
        ## Get variables names from features.txt
        features <- read.table(paste(parentLocation, "/features.txt", sep=""),
                               header = F, stringsAsFactors = F, fill = T)
        
        ## Set meaningful names for first columns, those from Subject and Y
        colnames(mergedData)[1:2] <- c("Subject", "Activity")
        ## Set names for all other columns, those coming from X, according to features data frame
        colnames(mergedData)[3:563] <- features[, 2]
        
        
## Task #2.Extracts only the measurements on the mean and standard deviation for each measurement. 
        
        ## Subset mergedData to only include columns that have "mean", "std", "Activity" or "Subject" and do NOT have "meanFreq" in their name
        mergedData <- mergedData[, grepl("mean()|std()|Activity|Subject", colnames(mergedData)) & !grepl("meanFreq", colnames(mergedData))]


## Task #3.Uses descriptive activity names to name the activities in the data set

        activities <- read.table(paste(parentLocation, "/activity_labels.txt", sep=""),
                                 header = F, stringsAsFactors = F, fill = T)
        
        ## Appropriately label the data set with descriptive activity names.
        mergedData$Activity <- factor(mergedData$Activity, levels = activities[, 1], labels = activities[, 2])
        


## Task #5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
        
        install.packages("plyr")
        library(plyr)
        tidyData <- ddply(mergedData,
                          .(Subject, Activity),
                          .fun=function(x) { colMeans(x[ ,-c(1:2)]) })
        
        ## Write out resulting tidy data set into CSV
        write.table(tidyData, paste(workingdir, "/tidydata.txt", sep=""), row.names = FALSE)
        
