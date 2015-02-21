
The script run_analysis.R performs the 5 steps instructed in the course project.

First, all the file was downloaded in the working directory and the the required library was imported.
Then the files were read into R.

The file column names were using colnames() function.

With cbind() a data file was created both for test (dt_test) file and the train (dt_train) file. 


Then, only those columns with the mean and standard deviation measures are taken from the whole dataset. After extracting these columns, they are given the correct names, taken from features.txt.
As activity data is addressed with values 1:6, we take the activity names and IDs from activity_labels.txt and they are substituted in the dataset.
On the whole dataset, those columns with vague column names are corrected.
Finally, we generate a new dataset with all the average measures for each subject and activity type (30 subjects * 6 activities = 180 rows). The output file is called averages_data.txt, and uploaded to this repository.

Variables
x_train, y_train, x_test, y_test, sbt_train and sbt_test contain the data from the downloaded files.
- dataset was created by merging the dt_test and dt_train.
- data1 was created as a logical vector by taking only the measurement that had the mean and the standard deviation as instructed in the project.
- data2 is only the value that were true in data1
- finalData is the merging of data2 with activityType one of the column from previous file that was loaded. 

for question 5 the variable finalDataNoActivityType was created to get a tableset with finalData that didn't content the variable activityType. All on the step of creating a tidy data set.

tidyData was then created and file was exported with the same name in txt format. 
