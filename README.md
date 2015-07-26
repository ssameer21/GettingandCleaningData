### GettingandCleaningData

-> Change your working directory to the folder where 'UCI HAR Dataset' folder is located

-> Place the script 'run_analysis.R' in this folder

-> Load the following library: dplyr

-> Source the 'run_analysis.R' script

-> The script will perform the steps mentioned in the project and will write the ouput of the Step 5 to a txt file 'newData.txt'    and place it in the current wokring directory

-> For the explanation of the code see below:

> # Reading the data sets provided and merging them to create one single data set on which the operations will be performed:

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

