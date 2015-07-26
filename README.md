# Getting and Cleaning Data

-> Change your working directory to the folder where 'UCI HAR Dataset' folder is located

-> Place the script 'run_analysis.R' in this folder

-> Load the following library: dplyr

-> Source the 'run_analysis.R' script

-> The script will perform the steps mentioned in the project and will write the ouput of the Step 5 to a txt file 'newData.txt'    and place it in the current wokring directory

-> For the explanation of the code see below:

> ### Reading the data sets provided and merging them to create one single data set on which the operations will be performed:

```{r}
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
```
The X_test data set is stored in x1. X_train is stored in x2. Similarly, Y_test, Y_train are in y1, y2 respectively.
Same for subject_test and subject_train.

combinedData1 contains subject_test, y_test, X_test, combined by column. 
combinedData1 contains subject_train, y_train, X_train, combined by column

Finally, combinedData is formed from binding combinedData1&2 by row

Step 1 of the project is over

> ### Next, read feature names and activity names, and assign them to the column names of the combinedData

In the first part the feature names and the activity names are read from the text file and then the fearure names are assigned the column names of the combinedData

```{r}
#read data sets for feature names and activity names
featureName <- read.table(paste(getwd(),"/UCI HAR Dataset/features.txt",sep = ""))
activityLabels <- read.table(paste(getwd(),"/UCI HAR Dataset/activity_labels.txt",sep = ""))

#read data set for column names and assign it to the column names of the main data set
columnNames <- c("SubjectID","ActivityID",as.vector(featureName$V2))
names(combinedData) <- columnNames
```

> ### Create Tidy data by removing duplicate columns and then extracting the mean and std columns

The below code first checks for duplicate columsn and then removes them from the combinedData, keeping only the unique column names and data.

```{r}
#remove duplicate columns
duplicateColumnName <- duplicated(colnames(combinedData))
combinedData <- combinedData[,!duplicateColumnName]

#Extract columns with mean or std in their name
meanStdCheck <- grep("mean|std",colnames(combinedData))
meanStdData <- combinedData[,meanStdCheck]
```

Once that is done, the column names with 'mean' or 'std' in them are extracted and stored in meanStdData

This completes Step 2.

> ### Activity codes in the data set are replaced with descriptive names

```{r}
#Uses descriptive activity names to name the activities in the data set
combinedData[,2] <- activityLabels[match(combinedData[,2],activityLabels[,1]),2]
```

Step 3 is complete.

> ### Column names are made as descriptive as possible

```{r}
#Appropriately labels the data set with descriptive variable names. 
colnames(combinedData) <- gsub("\\(|\\)","",colnames(combinedData))
colnames(combinedData) <- gsub("std","StandardDeviation",colnames(combinedData))
colnames(combinedData) <- gsub("mad","MedianDeviation",colnames(combinedData))
colnames(combinedData) <- gsub("sma","SignalMagnitudeArea",colnames(combinedData))
colnames(combinedData) <- gsub("iqr","InterquartileRange",colnames(combinedData))
colnames(combinedData) <- gsub("arCoeff","AutorregresionCoeff",colnames(combinedData))
colnames(combinedData) <- gsub("maxInds","LargestMagnitudeIndex",colnames(combinedData))
```

Step 4 is complete.

> ### Column names are made as descriptive as possible

```{r}
#Create data set grouped by subject and activity and containing average of each feature
lastDataSet <- combinedData[order(combinedData$SubjectID, decreasing = FALSE),]
lastDataSet <- lastDataSet %>% group_by(SubjectID,ActivityID) %>% summarise_each(funs(mean(.,)))

#write the data set just created in a file
write.table(lastDataSet, file = "newData.txt", row.names = FALSE)
```

Step 5 is complete.
