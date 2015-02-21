require("data.table")
require("reshape2")

#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "destfile", method <- "curl")

## read file
dt_features <- read.table('./features.txt',header<-FALSE)
dt_activity <- read.table('./activity_labels.txt',header<-FALSE)
sbt_train <- read.table('./train/subject_train.txt',header<-FALSE)
x_train <- read.table('./train/x_train.txt',header<-FALSE)
y_train <- read.table('./train/y_train.txt',header<-FALSE)

# Set column names for data imported above
colnames(dt_activity) <- c('activityId','activityType');
colnames(sbt_train) <- "subjectId"
colnames(x_train) <- dt_features[,2] 
colnames(y_train) <- "activityId"

# Create the final training set by merging y_train, sbt_train, and x_train
dt_train <- cbind(y_train, sbt_train, x_train)

# Read data of the test file
sbt_test <- read.table('./test/subject_test.txt',header<-FALSE)
x_test <-   read.table('./test/x_test.txt',header<-FALSE); #imports x_test.txt
y_test <-   read.table('./test/y_test.txt',header<-FALSE); #imports y_test.txt

# Assign column names to the test data file
colnames(sbt_test) <- "subjectId"
colnames(x_test)  <- dt_features[,2] 
colnames(y_test)   <- "activityId"

# Create final test data by merging the x_test, y_test and sbt_test data
dt_test<- cbind(y_test,sbt_test,x_test)

# create final dataset, combine training and test data
dataset <- rbind(dt_train,dt_test)

# Create a vector for the column names from the finalData, which will be used
# to select the desired mean() & stddev() columns
colNames <- colnames(dataset)

# 2. Extract only the mean and standard deviation for each measurement. 

# Create a variable for the ID, mean() & stddev()
data1<- (grepl("activity..",colNames) | grepl("subject..",colNames) 
                  | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) 
                  & !grepl("mean..-",colNames) | grepl("-std..",colNames)
                  & !grepl("-std()..-",colNames))

# Subset dataset based on the logicalVector to keep only desired columns
data2 <- dataset[data1==TRUE]

# 3. Use descriptive activity names to name the activities in the data set

# Merge the finalData set with the acitivityType table to include descriptive activity names
finalData <- merge(data2, activityType,by='activityId',all.x=TRUE);

# Updating the colNames vector to include the new column names after merge
colNames  <- colnames(finalData) 

# 4. Appropriately label the data set with descriptive activity names. 

# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] <- gsub("\\()","",colNames[i])
  colNames[i] <- gsub("-std$","StdDev",colNames[i])
  colNames[i] <- gsub("-mean","Mean",colNames[i])
  colNames[i] <- gsub("^(t)","time",colNames[i])
  colNames[i] <- gsub("^(f)","freq",colNames[i])
  colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] <- gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
}

# Reassigning the new descriptive column names to the finalData set
colnames(finalData) <- colNames

# 5. Create a second, independent tidy data set with the average of each variable

# Create a new table, finalDataNoActivityType without the activityType column
finalDataNoActivityType <- finalData[,names(finalData) != 'activityType']

# Summarizing the finalDataNoActivityType table to include just 
# the mean of each variable for each activity and each subject
tidyData <- aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) 
                      != c('activityId','subjectId')],
                      by=list(activityId= finalDataNoActivityType$activityId,
                      subjectId = finalDataNoActivityType$subjectId),mean)

# Merging the tidyData with activityType to include descriptive acitvity names
tidyData <- merge(tidyData, activityType, by='activityId', all.x = TRUE)

# Export the tidyData set 
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep= '\t')

