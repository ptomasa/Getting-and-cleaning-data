# set the working directory (containing .txt files)
setwd("/Users/MariaRamos/Documents/Coursera/Getting and cleaning data/project") 

# FIRST STEP ################################################################
##### Merges the training and the test sets to create one data set. #########
#############################################################################

# read data
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

# add column names
## add column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

## add column names for measurement files
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

## add column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

# merge files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
rundata <- rbind(train, test)

# SECOND STEP ###############################################################
##### Extracts only the measurements on the mean and standard deviation #####
##### for each measurement. #################################################
#############################################################################

# determine the columns containing "mean()" & "std()"
meanstdcols <- grepl("mean\\(\\)", names(rundata)) |
  grepl("std\\(\\)", names(rundata))

# keep the subjectID and activity columns
meanstdcols[1:2] <- TRUE

# remove unnecessary columns
rundata <- rundata[, meanstdcols]


# THIRD AND FOURTH STEPS ###############################################################
##### Uses descriptive activity names to name the activities in the data set, and ######
##### appropriately labels the data set with descriptive ###############################

# describe and label activities

rundata$activity <- factor(rundata$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


## STEP 5: Creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.

library(reshape2)

# melt the data frame
id_vars = c("activity", "subjectID")
measure_vars = setdiff(colnames(rundata), id_vars)
melted_data <- melt(rundata, id=id_vars, measure.vars=measure_vars)

# recast the data frame
dcast(melted_data, activity + subjectID ~ variable, mean)    



# FIFTH STEP ###########################################################################
##### From the data set in step 4, creates a second, independent tidy data set with  ###
##### the average of each variable for each activity and each subject.##################

tidy <- dcast(melted_data, activity + subjectID ~ variable, mean)    
write.csv(tidy, "tidy.csv", row.names=FALSE)
