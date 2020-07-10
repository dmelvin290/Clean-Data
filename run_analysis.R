library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/
              getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "Dataset.zip")
unzip("Dataset.zip")
train <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/train/X_train.txt")
test <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/test/X_test.txt")
df <- rbind(train, test)
rm(test, train)


variables <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/features.txt")
index <- grep("mean|std", variables$V2)
df2 <- df[,index]
rm(df)
nms <- variables[index, "V2"]
colnames(df2) <- nms

subtrain <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/train/subject_train.txt")
subtest <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/test/subject_test.txt")
subjects <- rbind(subtrain, subtest)
rm(subtrain, subtest)
colnames(subjects) <- "subjects"

acttrain <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/train/y_train.txt")
acttest <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/test/y_test.txt")
activity <- rbind(acttrain, acttest)
rm(acttrain, acttest)
colnames(activity) <- "activity"

temp <- cbind(subjects, activity)
df2 <- cbind(temp, df2)
rm(temp)

act_labels <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/activity_labels.txt")
act_labels$V2 <- tolower(act_labels$V2)
for (i in 1:length(df2$subjects)){
  df2$activity[i] <- act_labels$V2[as.numeric(df2$activity[i])]
}

df2 <- group_by(df2, subjects, activity)
means <- summarise_at(df2, vars(colnames(df2[,3:81])), list(name = mean))
write.table(means, "Subject_Activity_means.txt", row.names = FALSE)
