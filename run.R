temp <- tempfile()
install.packages("plyr")
library(plyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
x_test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
subject_test <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
x_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
subject_train <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
unlink(temp)
#step 1
# create 'x' data set
x_data<-rbind(x_train,x_test)
# create 'y' data set
y_data<-rbind(y_train,y_test)
# create 'subject' data set
subject_data<-rbind(subject_train,subject_test)
# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
features<-read.table(unz(temp, "UCI HAR Dataset/features.txt"))
# get only columns with mean() or std() in their names
mean_and_std_features<-grep("-(mean|std)\\(\\)",features[,2])
# subset the desired columns
x_data<-x_data[,mean_and_std_features]
# correct the column names
names(x_data)<-features[mean_and_std_features,2]
# Step 3 and 4
# Use descriptive activity names to name the activities in the data set
activities<-read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))
# update values with correct activity names
y_data[,1]<-activities[y_data[,1],2]
names(y_data)<-"activity"
# correct column name
names(subject_data)<-"subject"
# bind all the data in a single data set
all_data<-cbind(x_data,y_data,subject_data)
# Step 5
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "C:/Users/12150/Desktop/averages_data.txt", row.name=FALSE)