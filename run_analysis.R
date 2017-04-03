setwd("UCI HAR Dataset/")
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}
if(!require(tidyr)){
  install.packages("tidyr")
  libary(tidyr)
}
if(!require(purrr)){
  install.packages("purrr")
  library(purrr)
}
if(!require(magrittr)){
  install.packages("magrittr")
  library(magrittr)
}
features<-read.table("features.txt",col.names=c("ID","Variable"),stringsAsFactors = FALSE)
colNumsOfInterest<-grep("([mM]ean)|(std)",features[,2]) #returns integer vector of indices of
#columns of the data frame "features" with names that contain either "mean","Mean" or "std" 
colsOfInterest<-grep("([mM]ean)|(std)",features[,2],value=T) #returns the 
#actual vector of the column names of the data frame "features" that contain either "mean","Mean" or "std"
outLogical<-!(features$ID %in% colNumsOfInterest) #this is a logical vector
#the same length as names(features) that contains TRUE values for indices
#for which the names(features) DOES NOT contain either "mean","Mean" or "std"
featuresTagged<-features #a copy of features
featuresTagged[outLogical,"Variable"]<-"garbage" #featuresTagged$variable
#is assigned the value "garbage" wherever it doesn't contain "Mean","mean" or "std"
columnNames<-featuresTagged$Variable
trainXData<-read.table("train/X_train.txt",col.names = columnNames)
keepCols<-grep("garbage",names(trainXData),invert = TRUE)
#above three lines read in the training data and assign to keepCols
#the column indices to be retained
trainXData<-trainXData[,keepCols] 
#above line subsets trainXData based on the columns to be kept

subjectTrainData<-read.table("train/subject_train.txt",col.names="Subject")
#above line reads in train/subject_train.txt (these are the subject indices)
trainYData<-read.table("train/y_train.txt",col.names="Activity")
#above line reads in train/y_train.txt (these are the activity indices)
trainXData<-cbind(trainXData,trainYData,subjectTrainData)
#above line puts the Subject index data frame (subjectTrainData)
#and the activity index data frame (trainYData) in the the
#primary data frame (trainXData)

names(trainXData)<-c(colsOfInterest,"Activity","Subject")
#above line reassigns names of trainXData given addition of two new columns
trainXData<-trainXData%>%gather(key=Variable,value=Measurement,-c(Activity,Subject))
#above line reassigns gathers all the measurement variables into one column
#THIS IS VERY IMPORTANT AS THE "MEASUREMENT VARIABLES" ARE REALLY DISTINCT VALUES
#OF SINGLE VARIABLE- NAMELY, "MEASUREMENT"; 
#SEE link: https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
#for more information


activityList<-strsplit("Walking Walking_Upstairs Walking_Downstairs Sitting Standing Laying","\\s+")%>%unlist()
trainXData$Activity<-activityList[trainXData$Activity]
#above two lines replace activity indices wi the appropriate labels

trainXDataUpdate<-trainXData
##Now trainXData is in its final form- namely trainXDataUpdate; all that remains is
##to read in testXData, perform virtually the identical cleaning
##procedure and to row bind the two
testXData<-read.table("test/X_test.txt",col.names=columnNames)
keepCols<-grep("garbage",names(testXData),invert=TRUE)
testXData<-testXData[,keepCols]

subjectTestData<-read.table("test/subject_test.txt",col.names="Subject")
testYData<-read.table("test/y_test.txt",col.names="Activity")
testXDataBound<-cbind(testXData,testYData,subjectTestData)#I made this reassignment
#to textXdataBound because my workspace was showing multiple instances of
#testXdata that were different; I didn't seem to run into this issue with
#trainXdata

names(testXDataBound)<-c(colsOfInterest,"Activity","Subject")

testXDataBound<-testXDataBound%>%gather(key=Variable,value=Measurement,-c(Activity,Subject))
testXDataBound$Activity<-activityList[testXDataBound$Activity]

testXDataUpdate<-testXDataBound
#now testXData is in its final form- namely testXDataUpdate;
#now we're ready merge trainXDataUpdate and testXDataUpdate

combined<-rbind(trainXDataUpdate,testXDataUpdate) #combine trainXDataUpdate
#with testXDataUpdate
combinedFinal<-combined[,c(2,1,3,4)] #reorder columns

averages<-combinedFinal%>%group_by_(~ Subject,~ Activity,~ Variable)%>%summarize_(Average_Measurement= ~ mean(Measurement))


setwd("..")
fn<-"tidyAverages.txt"
file.create(fn)
write.table(averages,file=fn,quote=F,row.names=F)