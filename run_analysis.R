#read data sets and then combine them all in one main data set
x1 <- read.table(paste(getwd(),"/UCI HAR Dataset/test/X_test.txt",sep = ""))
y1 <- read.table(paste(getwd(),"/UCI HAR Dataset/test/y_test.txt",sep = ""))
z1 <- read.table(paste(getwd(),"/UCI HAR Dataset/test/subject_test.txt",sep = ""))
x2 <- read.table(paste(getwd(),"/UCI HAR Dataset/train/X_train.txt",sep = ""))
y2 <- read.table(paste(getwd(),"/UCI HAR Dataset/train/y_train.txt",sep = ""))
z2 <- read.table(paste(getwd(),"/UCI HAR Dataset/train/subject_train.txt",sep = ""))
combinedData1 <- cbind(z1,y1,x1)
combinedData2 <- cbind(z2,y2,x2)
combinedData <- rbind(combinedData1,combinedData2)

#read data sets for feature names and activity names
featureName <- read.table(paste(getwd(),"/UCI HAR Dataset/features.txt",sep = ""))
activityLabels <- read.table(paste(getwd(),"/UCI HAR Dataset/activity_labels.txt",sep = ""))

#read data set for column names and assign it to the column names of the main data set
columnNames <- c("SubjectID","ActivityID",as.vector(featureName$V2))
names(combinedData) <- columnNames

#remove duplicate columns
duplicateColumnName <- duplicated(colnames(combinedData))
combinedData <- combinedData[,!duplicateColumnName]

#Extract columns with mean or std in their name
meanStdCheck <- grep("mean|std",colnames(combinedData))
meanStdData <- cbind(combinedData[,(1:2)],combinedData[,meanStdCheck])
combinedData <- meanStdData

#Uses descriptive activity names to name the activities in the data set
combinedData[,2] <- activityLabels[match(combinedData[,2],activityLabels[,1]),2]

#Appropriately labels the data set with descriptive variable names. 
colnames(combinedData) <- gsub("\\(|\\)","",colnames(combinedData))
colnames(combinedData) <- gsub("std","StandardDeviation",colnames(combinedData))
colnames(combinedData) <- gsub("mad","MedianDeviation",colnames(combinedData))
colnames(combinedData) <- gsub("sma","SignalMagnitudeArea",colnames(combinedData))
colnames(combinedData) <- gsub("iqr","InterquartileRange",colnames(combinedData))
colnames(combinedData) <- gsub("arCoeff","AutorregresionCoeff",colnames(combinedData))
colnames(combinedData) <- gsub("maxInds","LargestMagnitudeIndex",colnames(combinedData))

#Create data set grouped by subject and activity and containing average of each feature
lastDataSet <- combinedData[order(combinedData$SubjectID, decreasing = FALSE),]
lastDataSet <- lastDataSet %>% group_by(SubjectID,ActivityID) %>% summarise_each(funs(mean(.,)))

#write the data set just created in a file
write.table(lastDataSet, file = "newData.txt", row.names = FALSE)
