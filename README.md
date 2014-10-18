GettingCleaningData
===================

R code to munge data from the UC Irvine Human Activity Recognition Using Smartphones Data Set 

This file starts by removing all variables in your R workspace!! 
I do this to make absolutely sure the script will run when I take it to another environment.

Also, NB:  This script works if you haven't messed with the folder structure of the original zip file.
So you should set your working directory to the root, which has the following contents:

activity_labels.txt
features_info.txt
features.txt
README.txt
/train
/test

where /train and /test are folders.

The next step reads in the four main files, two training and two test.

Then I do a little checking to show some values.

I read in the variable names from activity_labels and store the names as a character vector
in the vector varnames.v.

I apply the column names from varnames.v to the meaty parts of the data set, and simply call the puny one
"activity" because that's the numeric representation of the activity.

Then I read in the names of the activities to "a" and assign them as factors so they're descriptive.

Next, I read the subject numbers into xsub and ysub, and c() them to create a single vector, subject.

The data.frame "z" cbind()'s the subject information, the activity information, and the 561-variable
data.frame together.

Next, I create a data.frame named new_z that only has the first two columns (subject and activity) and
the columns with "std" or "mean" in their titles.

To do the fancy grouping, it's dplyr to the rescue!  The group_by() function creates a great set of
data to work with for this purpose, and from there, final_df is created with the summarise_each() function.

Not sure why that's red in the previou line... probably a github thing, I wouldn't undertand ;)

So then I write out final_df with write.csv, without row names as in the instructions.

I hope you enjoyed reading this as much as I enjoyed writing it, but probably not :)
