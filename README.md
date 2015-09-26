# Getting_and_Cleaning_Data_Project

This is the README file for the code run_analysis.R used to tidy the data and produce the text file tidydata.txt.

In order to run the code the following conditions must be met:
- the code has to be placed in the working directory (./run_analysis.R)
- the data has to be unzipped and placed in the working directory as ./UCB HAR Dataset/ with all the data left inside the way it comes (in their original directories)
- the dplyr package has to be installed as the code uses some of the library's commands

To run the code, all is needed is to source it:
source("./run_analysis.R")

This will run the code and create the tidy data text file ./tidydata.txt in the working directory

The following is the working of the code line-by-line with the reasoning explained underneath each when needed:
- (3) the dplyr library is called
  - some functions from this library are used in this code

- (6) the ./UCI HAR Dataset/train/subject_train.txt file is read into the variable subject_train
- (7) the ./UCI HAR Dataset/test/subject_test.txt file is read into the variable subject_test

- (10) the numbers identifying the subjects are taken from subject_train and subject_test and put into the vector SubjectID
  - this was done because dataframes are more difficult to deal with than vectors when it comes to combining and using in another dataframe for the complete dataset.
  - Also, this method ensures the order of the data remains the same, with the training data first then the test data to follow. Merging dataframes can mess up the order of the data making it useless, while adding vectors together doesn't.

- (13) the ./UCI HAR Dataset/train/Y_train.txt file is read into the variable Y_train
- (14) the ./UCI HAR Dataset/test/Y_test.txt file is read into the variable Y_test

- (17) the activity labels from the training subjects are taken from the dataframe Y_train and placed in the vector Ytrain
- (18) the activity labels from the test subjects are taken from the dataframe Y_test and placed in the vector Ytest
- (19) Ytrain and Ytest are then combined into the vector ActivityID so it can be easily added to a dataframe later
  - as with the SubjectID, vectors are easier to deal with than dataframes, and maintain the order of the data with trainig first then test.

- (22) an empty vector called ActivityName is opened
- (23) a vector containing the names of the activities is created
- (24) by looping through the activity numbers and matching them with their names, the ActivityNames vector is filled with the names of the activities in the correct order

- (27) the ./UCI HAR Dataset/features.txt file is read into the dataframe features, with the features named in features$V2

- (30,31) using grep() function to find the features containing the string "std", and putting the indices in the variable: stds
- (33,34) using grep() function to find the features containing the string "mean", and putting the indices in the variable: means
- (35,36) using grep() function to find the features containing the string "meanFreq", and putting the indices in the variable: means_Freq
- (37) removing the indices of the features containing "meanFreq" from the vector "means"
- (38) creating a vector named "wanted" with the indices from stds and means combined and sorted in order
  - these lines were performed due to the question asking for only the means and standard deviations of the activity data, which I interpreted to exclude means weighted with the frequency (meanFreq)

- (41) the ./UCI HAR Dataset/train/X_train.txt file is read into the dataframe X_train
- (42) the ./UCI HAR Dataset/test/X_test.txt file is read into the dataframe X_test
- (43) both X_train and X_test are row binded into the new dataframe X
  - I couldn't use vectors in this case since the entire dataframe is needed, and it makes picking the wanted activities easier to find with the indices saved in "wanted" corresponding to the column numbers in the X dataframe

- (46) parenthesis "()" are removed from the activity names, and the names are placed in the vector: newnames
  - symbols do not behave well when used to name columns in dataframe, removing then ahead of using ensures the variable names are not truncated or misread
- (47) the names of the activities in the X dataframe are switched from "V1, V2, ..., V591" to the feature names given in the features.txt file
  - this step is done in correspondence to step 3 in the assignment askng to use descriptive activity names to name the activities in the data set. Since these names are already given in features.txt, I found them descriptive and concise enough to be used without the need to untangle them.
- (48) only the columns representing measurements containing the mean and standard deviation are kept in the X dataframe
  - this step is in correspondence to step 2 in the assignment

- (52) a dataframe called neatData is created containing the Subject IDs, Activity Names, and associated mean and std measurements
  - this is the tidy data requested in steps 1 - 4.
  - 1 the training and test data are merged, while ensuring order is kept
  - 2 only the measurements with means and standard deviations are kept
  - 3 descriptive activity names (in the 2nd column) instead of activity numbers (1-6) are used
  - 4 the data has appropriate labels obtained from the features.txt file

- (54 - 57) creating 4 empty vectors to be used for the final step 5 in creating a second, independent tidy data set with the average of each variable for each activity and each subject.
  - the vector names are: Subject, Activity, Measurement, and Average
  - I chose the long form for this set rather than the wide form as I think that long form looks tidier, and easier to read in a raw format than wide form. However, as explained by David Hood in the discussion forum, both wide and long forms are acceptable for this part, and both count as tidy data, the choice here is based on personal preference.

- (60) create a count variable used to index the above 4 vectors

- (62) loop through subjects 1-30
- (64) for every subject loop through every activity (1-6)
- (66) create a temporary dataframe (tmpframe) using the filter() function from the dplyr library
  - this frame contains all the mean and std measurements (66 in total) of only one single subject doing one single activity
- (68) loop through each of the 66 measrements
- (69) write the subject ID in the Subject() vector using the count as an index
- (70) write the activity name in the Activity() vector using the count as an index
- (71) write the measurement name in the Measurement() vector using the count as an index
- (72) calculate the average of the measurement, and place in the Average() vector using the count as an index
- (73) add 1 to the count to use as the next index

- (79) create the final data frame containing the tidy data in four columns
- (82) using write.table() with row.names=FALSE and separated by tabs to write the final tidy data set to the file ./tidydata.txt
  - to read the ./tidydata.txt file use the command: 
  - tidydata <- read.tables("./tidydata.txt", header=TRUE, sep="\t")
  - this will create a dataframe in variable tidydata with the column names: Subject, Activity, Measurement, and Average

