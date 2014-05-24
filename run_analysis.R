##pre-processing
train.x <- data.table(read.table('./UCI HAR Dataset/train/X_train.txt',comment.char = "", colClasses="numeric"))
train.act.labels <- data.table(read.table('./UCI HAR Dataset/train/Y_train.txt',comment.char = "", colClasses="numeric"))
train.sub <- data.table(read.table('./UCI HAR Dataset/train/subject_train.txt',comment.char = "", colClasses="numeric"))
test.x <- data.table(read.table('./UCI HAR Dataset/test/X_test.txt',comment.char = "", colClasses="numeric"))
test.act.labels <- data.table(read.table('./UCI HAR Dataset/test/Y_test.txt',comment.char = "", colClasses="numeric"))
test.sub <- data.table(read.table('./UCI HAR Dataset/test/subject_test.txt',comment.char = "", colClasses="numeric"))
features <- setnames(data.table(read.table('./UCI HAR Dataset/features.txt',comment.char = "")),c('id','Features'))
#Merges the training and the test sets to create one data set.
new.df <- rbind(test.x,train.x)
act.all <- setnames(rbind(test.act.labels,train.act.labels),'Code')
subj.all <- setnames(rbind(test.sub,train.sub),'Subject')
setnames(new.df,as.character(features[,Features]))
#Extracts only the measurements on the mean and standard deviation for each measurement. 
means.id <- grep('mean()',names(new.df),fixed=T)
std.id <- grep('std()',names(new.df),fixed=T)
sel.df <- new.df[,c(means.id,std.id),with=F]
#Uses descriptive activity names to name the activities in the data set
activities <- setkey(setnames(data.table(read.table('./UCI HAR Dataset/activity_labels.txt',comment.char = "")),c('Code','Activity')),'Code')

###Match activity to the referenced activity data.frame
act.labeled <- activities[act.all]

###joining data of variables, subjects, and activities
act.dt <-cbind(sel.df,subj.all,act.labeled[,list(Activity)])
###Calculate mean of all variables for each subject and ean activity
mean.per.sub.act <- act.dt[,lapply(.SD,mean),by=list(Subject,Activity)]

tidy.df <- as.data.frame(mean.per.sub.act)
write.csv(tidy.df,file='tidy.df.csv')
