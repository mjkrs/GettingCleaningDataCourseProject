# GettingCleaningDataCourseProject
Course Project for Coursera's Data Science::Getting and Cleaning Data

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
Subject-Activity-Measurement Variable triples.

## Methods
1.The file features.txt was read into an R data frame (features) and the rows holding variable name that
have one among ("Mean","mean", "std") in them were extracted- specifically, both the variable names
and the indices were extrated into separate vectors. The extracted indices correspond to columns to be retained in both X_train.txt and X_test.txt. A copy (featuresTagged) of the data frame holding the original info
held in features.txt was made and the variable names that did not contain one among ("Mean","mean", "std")
were given the designation "garbage". 

2.The file train/X_train.txt was read into an R data frame (trainXData) using the Varible column of featuresTagged
as the column names. trainXData was next subsetted- keeping only those columns that did not have "garbage" in their name.

3.The files train/subject_train.txt and train/y_train.txt were also read into separate R data frames. These data frames were next column bound to trainXData using the cbind function. The names of trainXData are now what they were followed by "Activity" and "Subject". 

4.At this point, all of the measure variables are separate variables in the dataset. This- per my interpretation of tidy data- (echoed by mentor David Hood here <a href="https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/" title="Link to David Hood's page regarding the assignment!">David Hood's page</a>) is a problem.

