# README

This is a run through of the script that produces the tidy dataset "Subject_Activity_means.txt."

```{r}
library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")
unzip("Dataset.zip")
```

The dplr library is imported
The data is downloaded from the internet to the working directory as a zip file "Dataset.zip" and unzipped to the folder UCI HAR dataset.

```{r}
train <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/train/X_train.txt")
test <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/test/X_test.txt")
df <- rbind(train, test)
rm(test, train)
```

The data from the train and test datasets are read into data frames. These are then merged into one data frame and the train and test dataframes are removed.

```{r}
variables <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/features.txt")
index <- grep("mean|std", variables$V2)
df2 <- df[,index]
rm(df)
nms <- variables[index, "V2"]
colnames(df2) <- nms
```

The variable names are read from "features.txt." An index is created based on the presence of "mean" or "std" in the variable names. The columns corresponding to this index are selected and used to create a new dataframe df2 and the original dataframe is removed. The columns are then named according to the variable names in "features.txt."

```{r}
subtrain <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/train/subject_train.txt")
subtest <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/test/subject_test.txt")
subjects <- rbind(subtrain, subtest)
rm(subtrain, subtest)
colnames(subjects) <- "subjects"
```

The subject data is read from the files "subject_train.txt" and "subject_test.txt." These are merged into one data frame and the column is named "subjects."

```{r}
acttrain <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/train/y_train.txt")
acttest <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/test/y_test.txt")
activity <- rbind(acttrain, acttest)
rm(acttrain, acttest)
colnames(activity) <- "activity"
```

The activity data is read from "y_train.txt" and "y-test.txt." These are merged into one dataframe and the column is named "activity."

```{r}
temp <- cbind(subjects, activity)
df2 <- cbind(temp, df2)
rm(temp)
```

The subjects and activity dataframes are merged in a temp dataframe. This is then merged with the main dataset in df2 and temp is removed.

```{r}
act_labels <- read.table("~/Desktop/Clean Data/UCI HAR Dataset/activity_labels.txt")
act_labels$V2 <- tolower(act_labels$V2)
for (i in 1:length(df2$subjects)){
  df2$activity[i] <- act_labels$V2[as.numeric(df2$activity[i])]
}
```

The activities are read from "activity_labels.txt." These labels are made all lower case. The code in the main dataframe is looped over and the activity codes are replaced with activity names from the act_labels dataframe.

```{r}
df2 <- group_by(df2, subjects, activity)
means <- summarise_at(df2, vars(colnames(df2[,3:81])), list(name = mean))
write.table(means, "Subject_Activity_means.txt", row.names = FALSE)
```

The dataframe is grouped by subject and activity. The means are then calculated for each subject and activity and saved to a new data table. This is then written to a file "Subject_Activity_means.txt."