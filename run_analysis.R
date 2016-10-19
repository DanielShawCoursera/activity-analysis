# downloads the file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","data.zip")
unzip("data.zip")

# reads two datasets and their labels
dataTest <- read.table("UCI HAR Dataset/test/X_test.txt")
dataTest2 <- read.table("UCI HAR Dataset/test/Y_test.txt")
dataTest3 <- read.table("UCI HAR Dataset/test/subject_test.txt")
dataTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
dataTrain2 <- read.table("UCI HAR Dataset/train/Y_train.txt")
dataTrain3 <- read.table("UCI HAR Dataset/train/subject_train.txt")
features <- read.table("UCI HAR Dataset/features.txt")
labels <- features[[2]]

# merges two datasets and labels the big data set with descriptive variable names
dataAlltemp <- rbind(dataTest,dataTrain)
names(dataAlltemp) <- labels
dataAlltemp2 <- rbind(dataTest2,dataTrain2)
names(dataAlltemp2) <- "activity"
dataAlltemp3 <- rbind(dataTest3,dataTrain3)
names(dataAlltemp3) <- "subject"
dataAll <- cbind(dataAlltemp3,dataAlltemp2,dataAlltemp)

# extract mean and standard deviations
index <- grep("(mean)|(std)",labels)
dataSubset <- dataAll[,c(1,2,index+2)]

# uses descriptive activity names to name the activities in the data set
activityLabels <-  read.table("UCI HAR Dataset/activity_labels.txt")
dataSubset$activity <- as.factor(dataSubset$activity)
levels(dataSubset$activity) <- activityLabels[,2]

# creates a second, independent tidy data set with the average of each variable
# for each activity and each subject
dataSubset$subject <- as.factor(dataSubset$subject)
dataFeatures <- dataSubset[,3:length(dataSubset)]
dataSplit <- split(dataFeatures,list(dataSubset$subject,dataSubset$activity))
dataAverage <- as.data.frame(t(sapply(dataSplit,colMeans)))
subject <- sub("\\.[A-Za-z|_]+","",row.names(dataAverage))
activity <- sub("[1-9]\\.","",row.names(dataAverage))
SubAndActivity = data.frame("subject"=subject,"activity"=activity)
dataClean <- cbind(SubAndActivity,dataAverage)

#writes the data
write.table(dataClean,"activityAnalysis.txt",row.names = FALSE) 