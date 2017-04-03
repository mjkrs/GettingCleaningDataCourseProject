# GettingCleaningDataCourseProject
Course Project for Coursera's Data Science::Getting and Cleaning Data

## Included Files
* README.md (The Readme)  
* CodeBook.md (Contains list of variable names in the tidy dataset and the values that they can take on)  
* run_analysis.R (The script to generate the tidy data from the files in UCI_HAR folder included with the project description on Coursera)  
* tidyAverages.txt (the tidy dataset)  

## Remarks on Tidy data, how to load tidy data file into R and how to run script to regenerate tidy data

### Remarks on Tidy data
A tidy data set contains one row per observation, one column per variable, and  
one table per observational unit. In this case the observations are Subject-Activity-(Measurement Statistic) triples.  
The tidy data set contains one row per such observations. The variables in our scenario are 
Subject,Activity, Measurement Statistic name, and Measurement statistic value. Measurement statistic name  
is encoded in the column "Variable" and measurement statistic value is encoded in the column "Measurement".  
The observational unit the entirety of measurements performed in the UCI HAR study- this includes BOTH  
the "train" group AND the "test" group. 

### How to load Tidy dataset into R
Use command 
```R
tidy<-read.table("tidyAverages.txt",header=T)  
View(tidy)  
```
### How to run script to regenerate tidy data
1. Download UCI_HAR data folder for project (provided on Coursera link for this project) and unzip it into your working directory.   
2. Load the script run_analysis.R into your working directory. Source the script. For this step. Use the following commands:  
```R  
fn<-"https://raw.githubusercontent.com/rawnoob25/GettingCleaningDataCourseProject/master/run_analysis.R"
download.file(fn,destfile="run_analysis.R")  
source("run_analysis.R")  
```
You should now get have tidyAverages.txt in your working directory.


## Overview
We were provided with data measuring signals for linear and rotational movements performed
by subjects wearing smartphones. There were 30 subjects in all, but 70% of them were assign to 
a "train" group" and 30% to a "test" group. These movements were tied to 6 gross motor activities-
namely "Walking", "Walking Upstairs", "Walking Downstars", "Sitting", "Standing",
and "Laying". 

The issue was that all of this information was spread across 8 files. "features.txt"
contained the actual names of the statistics (e.g. mean, standard deviation, signal magnitude are,
and interquartile range, among others) reported for measurements taken along with their index codes. 
"activity_labels.txt" contained the activities for which measurements where taken along with
their index codes.

The train group and test group each had a file with the actual measurements. There was
one column for each of the features in "features-info.txt" and the column indices here
match up with the numbers listed alongside each feature name in "features.txt". These 
files were respectively "X_train.txt" and "X_test.txt". Each row in X_train.txt
and X_test.txt was tied to an activity-subject pair. HOWEVER, the actual indices corresponding
to the subjects and activities were in separate files (more on this below). 

The train group and test group each also had a file with the subject ID for each observation
in X_train.txt and X_test.txt respectively. This information was respectively in subject_train.txt
and subject_test.txt.

The train group and test group each also had a file with the activity ID for each observation
in X_train.txt and X_test.txt respectively. This information was respectively in y_train.txt
and y_test.txt

The challenge was to put all this data into one R data frame, pull out data only involving a mean 
or standard deviation of a measurement and to ultimately write out: for each Subject, for each Activity,
for each Variable related to a mean or standard deviation, an average value (averaged over
Subject-Activity-(Measurement Variable statistic) triples.

## Methods
1. The file features.txt was read into an R data frame (features) and the rows holding variable name that
have one among ("Mean","mean", "std") in them were extracted- specifically, both the variable names
and the indices were extrated into separate vectors. The extracted indices correspond to columns to be retained in both X_train.txt and X_test.txt. A copy (featuresTagged) of the data frame holding the original info
held in features.txt was made and the variable names that did not contain one among ("Mean","mean", "std")
were given the designation "garbage". 

2. The file train/X_train.txt was read into an R data frame (trainXData) using the Varible column of featuresTagged
as the column names. trainXData was next subsetted- keeping only those columns that did not have "garbage" in their name.

3. The files train/subject_train.txt and train/y_train.txt were also read into separate R data frames. These data frames were next column bound to trainXData using the cbind function. The names of trainXData are now what they were followed by "Activity" and "Subject". 

4. At this point, all of the measure variables are separate variables in the dataset. This- per my interpretation of tidy data- (echoed by mentor David Hood here <a href="https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/" title="Link to David Hood's page regarding the assignment!">David Hood's page</a>) is a problem.

An observation in this experiment is a Subject-Activity-(Measurement variable statistic) triple. So it would make sense for all of the "measurement variables statistics" names to be captured in a single column and their corresponding values in another. To make this happen, I used the gather function in the tidyr package- all variables EXCEPT Subject and Activity were gathered into a single column (Variable) and their respective values placed in another single column (Measurement). This dataset still has the issue of having multiple observations for a Subject-Activity-(Measurement variable statistic) triple. But this will be addressed at the end of the cleaning procedure. 

In any event, trainXData has four columns- Subject, Activity, Variable and Measurement.

5. The issue now is that the data in the "Activity" column of trainXData are still numbers. At this point, these numbers are replaced with the appropriate activity labels using the folowing mapping taken from activity_labels.txt (note the case has been
changed to improve readability): 1->Walking, 2-> Walking_Upstairs,
3->Walking_Downstairs, 4->Sitting, 5->Standing, 6->Laying. The data frame trainXData is now in its clean form; it's now
stored with reference variable trainXDataUpdate

6. Steps 2 through 5 are repeated for the file test/X_test.txt, merging in the information through column binding from files
test/subject_test.txt and test/y_test.txt. This information is ultimately stored in the R data frame textXDataUpdate. 

7. The data in trainXDataUpdate and testXDataUpdate are merged using the row bind function and stored in the reference
vaiable "combined". The columns of "combined" are then reordered so that the column order is
Subject-Activity-Variable-Measurement. This reordered data frame is given the reference variable "combinedFinal".

8. Using the group_by and summarize functions in the dplyr package, the tidy dataset (averages) holds the mean value of each
measurement variable statistic for every distinct Subject-Activity-Variable triple. Note the column "Variable" here denotes a 
measurement variable statistic.

9. The final tidy dataframe is written to the file tidyAverages.txt using the write.table function.




