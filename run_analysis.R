##pre-processing
###David Hood from Discussion Board file check:
if (!file.exists("UCI HAR Dataset")) {
    if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
        stop("was expecting HAR Dataset folder or zip file")
        } else {
        unzip("getdata_projectfiles_UCI HAR Dataset.zip")
        }
    }
library(data.table)
### 1. read data ----
train.x <- data.table(read.table('./UCI HAR Dataset/train/X_train.txt',comment.char = "", colClasses="numeric"))
train.act.labels <- data.table(read.table('./UCI HAR Dataset/train/Y_train.txt',comment.char = "", colClasses="numeric"))
train.sub <- data.table(read.table('./UCI HAR Dataset/train/subject_train.txt',comment.char = "", colClasses="numeric"))
test.x <- data.table(read.table('./UCI HAR Dataset/test/X_test.txt',comment.char = "", colClasses="numeric"))
test.act.labels <- data.table(read.table('./UCI HAR Dataset/test/Y_test.txt',comment.char = "", colClasses="numeric"))
test.sub <- data.table(read.table('./UCI HAR Dataset/test/subject_test.txt',comment.char = "", colClasses="numeric"))
features <- setnames(data.table(read.table('./UCI HAR Dataset/features.txt',comment.char = "")),c('id','Features'))
activities <- setkey(setnames(data.table(read.table('./UCI HAR Dataset/activity_labels.txt',comment.char = "")),c('Code','Activity')),'Code')
#2. Merge the training and the test sets ----
new.dt <- rbind(test.x,train.x)
act.all <- setnames(rbind(test.act.labels,train.act.labels),'Code')
subj.all <- setnames(rbind(test.sub,train.sub),'Subject')
#3. Set column names for new data.table---- 
setnames(new.dt,as.character(features[,Features]))
#4. Extracts only the measurements on the mean and standard deviation for each measurement.---- 
means.id <- grep('mean()',names(new.dt),fixed=T)
std.id <- grep('std()',names(new.dt),fixed=T)
sel.df <- new.dt[,c(means.id,std.id),with=F]
#5. Match activity to the referenced activity data.table----
act.labeled <- activities[act.all]
#6. Join data of variables, subjects, and activities
act.dt <-cbind(sel.df,subj.all,act.labeled[,list(Activity)])
#7. Calculate mean of all variables for each subject and ean activity----
mean.per.sub.act <- setkey(act.dt[,lapply(.SD,mean),by=list(Subject,Activity)],Subject)
#8. Convert new data.table to data.frame----
tidy.df <- as.data.frame(mean.per.sub.act)
#9. Write as .csv----
write.csv(tidy.df,file='tidy.df.csv')
