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
1. The file features.txt was read into an R data frame and the rows holding variable name that
have one among ("Mean","mean", "std") in them were extracted- specifically, both the variable names
and the indices were extrated into separate vectors. A copy of the data frame holding the original info
held in features.txt was made and the variable names that did not contain one among ("Mean","mean", "std")
were given the designation "garbage". 

2.A copy

The extracted indices correspond to columns to be retained in both X_train.txt and X_test.txt.
