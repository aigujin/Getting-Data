##NOTE: The UCI HAR dataset files have to be in the working directory
##The script is base on the data.table package available from CRAN. This package is very fast and memory efficient when dealing with huge data.frames. 

1. Read UCI data and convert it into data.tables.
	* train.x and test.x are the DTs with the measearment variables (561 measerments);
	* "train.act.labels" and "test.act.labels" are the activity labels;
	* "train.sub" and "test.sub" are the data.tables  of subjects
	* "features" is the data.table with the features
	* "activity" is the data.table of activity names

2. Join test.x and train.x datasets together and assign new data.table 
	* "new.dt" - a joined data.table with test and train data;
	* "act.all" - a data.table with joined activity labels and keyed by column "Code". 
A key is the column in data.table by which we can join  another data.table
	* "subj.all" is joined subjects from test and train datasets
	
3. setnames() sets names to a data.table and "new.dt" gets column names from "features"

4. Selecting columns conditional on "mean()"  and "std():
	* "means.id" - columns that have "mean()" in their names;
	* "std.id" - columns that have "std()" in the names;
	* "sel.df" - a new data.table subset on "mean.id" and std.id"

5. Match activity to the referenced activity data.table:
	* "act.labeled" - labeled activities for all subjects;
	
6. Join data of variables, subjects, and activities

7. Calculate mean of all variables for each subject and ean activity

8. Convert data.table to data.frame
tidy.df <- as.data.frame(mean.per.sub.act)

9. Write as .csv
write.csv(tidy.df,file='tidy.df.csv')