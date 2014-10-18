# Here are the data for the project:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following. 
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 
# 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.


## BEG 1. Merges the training and the test sets to create one data set.
rm(list=ls())
# setwd("whatever")
#dir("test")

#?read.table
#read in the four data files
x1 <- read.table("train/x_train.txt", sep="", encoding="utf-8", numerals="no.loss")   #7352
y1 <- read.table("train/y_train.txt", sep="", encoding="utf-8", numerals="no.loss")   #2947
x2 <- read.table("test/X_test.txt", sep="", encoding="utf-8", numerals="no.loss")     #7352
y2 <- read.table("test/y_test.txt", sep="", encoding="utf-8", numerals="no.loss")     #2947


#it may look like reading in the data truncated the digits, but it's the printing 
#that's actually doing it.  Check this out:
x2[1,3]
print(x2[1,3], digits=10)
#the print statement shows the value from the file


#count.fields("test/X_test.txt", sep = "")

#get the variable names into a vector
varnames <- read.table("features.txt")
varnames.v <- varnames$V2

#sanity check
length(varnames.v)

# 3. Uses descriptive activity names to name the activities in the data set
#not super elegant but eh.
colnames(x1) <- varnames.v
colnames(x2) <- varnames.v
colnames(y1) <- "activity"
colnames(y2) <- "activity"

a <- read.table("activity_labels.txt")
colnames(a) <- c("numz", "labelz")
a
y3 <- rbind(y1, y2)
x3 <- rbind(x1, x2)

# 4. Appropriately labels the data set with descriptive variable names. 
#apply labels
y3$activity <- factor(y3$activity, levels = a$numz, labels = a$labelz) 


#sanity check
str(x3)
str(y3)

#subject numbers
xsub <- scan("train/subject_train.txt")
ysub <- scan("test/subject_test.txt")
subject <- c(xsub, ysub)

# z is the name of the fully merged dataset.
z <- cbind(subject, y3, x3)
str(z)

#nice.
table(z$activity, z$subject)
## END 1. Merges the training and the test sets to create one data set.

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
new_z <- z[,c(1,2, grep("mean", colnames(z)), grep("std", colnames(z)))]

#sanity check
colnames(new_z)

# 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

library(dplyr)

average_by_activity_and_subject <- group_by(new_z, subject, activity)
final_df <- summarise_each(average_by_activity_and_subject, funs(mean))

final_df

colnames(final_df) <- paste(colnames(final_df), "_MEAN", sep="")
colnames(final_df)[1] <- "subject"
colnames(final_df)[2] <- "activity"
write.csv(final_df, "project_tidy_data.txt", row.names=FALSE)



# sanity checks
# tBodyAcc-mean()-Z subject 1 WALKING: -0.1111481
# mean(new_z[new_z$subject == 1 & new_z$activity == "WALKING", "tBodyAcc-mean()-Z"])

# tBodyAcc-mean()-X subject 2 WALKING_UPSTAIRS: 0.2471648
# mean(new_z[new_z$subject == 2 & new_z$activity == "WALKING_UPSTAIRS", "tBodyAcc-mean()-X"])

# this function creates lines 3-81 of the codebook:
#for(i in 3:81){
#  cat(paste(colnames(final_df)[i], " - ", "mean of the variable ", colnames(final_df)[i], " summarized by subject and activity (units are as they were in original file) \n"))
#}
