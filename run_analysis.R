## assuming the dataset has already been unzipped into the working directory in the folder named: ./UCI HAR Dataset/

library(dplyr)

## read subject_train and subject_test
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## combine both subject_train+test into subjectID vector
SubjectID <- c(subject_train$V1,subject_test$V1)

## read training and tests labels
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")

## Combine the Y-train+test labels into a single dataframe
Ytrain <- c(Y_train$V1)
Ytest <-c(Y_test$V1)
ActivityID=c(Ytrain,Ytest)

## create vector with activity names to associate with ActivityID
ActivityName <- NULL
ActNames = c("Walking", "Walking_Upstairs", "Walking_Downstairs", "Sitting", "Standing", "Laying")
for (i in 1:length(ActivityID)){ActivityName[i] <- ActNames[ActivityID[i]]}

## read features.txt
features <- read.table("./UCI HAR Dataset/features.txt")

## find the features that contain std information
stds <- grep("std()", features$V2, ignore.case = FALSE, perl = FALSE, value = FALSE, 
             fixed = FALSE, useBytes = FALSE, invert = FALSE)
## find the features that contain means information (and then remove ones with meanFreq)
means <- grep("mean()", features$V2, ignore.case = FALSE, perl = FALSE, value = FALSE, 
              fixed = FALSE, useBytes = FALSE, invert = FALSE)
means_Freq <- grep("meanFreq()", features$V2[means], ignore.case = FALSE, perl = FALSE, value = FALSE, 
                   fixed = FALSE, useBytes = FALSE, invert = FALSE)
means <- means[-c(means_Freq)]
wanted <- sort(c(means,stds))

## read training and tests sets, merge data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X <- rbind(X_train,X_test)

## rename X columns, and take only ones with means and stds
newnames <- gsub("()", "", features$V2, fixed=TRUE)
names(X) <- newnames
X <- X[,wanted]

## merging all data in new data frame
neatData <- data.frame(SubjectID, ActivityName, X)

## Creating empty vectors to add values to for Step5
Subject <- integer()
Activity <- character()
Measurement <- character()
Average <- numeric()

## Calculating average of every measurement for every activity for every subject
count <- 1
## looping through all subjects
for (sub in 1:30) {
        ## for every subject looping through all activities
        for (act in 1:6){
                ## creatong a temporary dataframe that contains only one subject and one activity
                tmpframe <- filter(neatData, SubjectID == sub & ActivityName == ActNames[act])
                ## for every subject and activity, loopig through all measurements
                for (meas in 3:68) {
                        Subject[count] <- sub
                        Activity[count] <- ActNames[act]
                        Measurement[count] <- names(neatData[meas])
                        Average[count] <- mean(tmpframe[,meas])
                        count <- count+1
                }
        }
}

## putting Subject, Activity, Measurement, & Average vectors into a final data frame
FinalDataFrame <- data.frame(Subject,Activity,Measurement,Average)

## writing final tidy data to ./tidydata.txt
write.table(FinalDataFrame, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE, sep = "\t", quote = FALSE)
