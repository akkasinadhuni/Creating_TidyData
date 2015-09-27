# This code was written as part of Assignment-2 of Coursera's Getting and Cleaning Data course.

library(plyr)
        activity <- read.table('activity_labels.txt', stringsAsFactors = F)
        features <- read.table('features.txt', stringsAsFactors = F)

# Selecting the mean and std deviation data from all features for extraction
        reqdfeatures <- grep('.*mean.*|.*std.*',features[,2])
        featurenames <- features[reqdfeatures,2]

# Replacing the mean() and std() in the feature names with Mean and Std.
        featurenames <- gsub('-mean','Mean',featurenames)
        featurenames <- gsub('-std','Std',featurenames)
        featurenames <- gsub('[-()]','',featurenames)

# Reading/extracting only the mean() and std() data from the training dataset.
        data_train <- read.table('train/X_train.txt')[reqdfeatures]
        activity_train <- read.table('train/y_train.txt')
        activity_subjects <- read.table('train/subject_train.txt')
        trainingdata <- cbind(activity_subjects,activity_train,data_train)

# Reading the mean() and std() data from the testing dataset. 
        data_test <- read.table('test/X_test.txt')[reqdfeatures]
        activity_test <- read.table('test/y_test.txt')
        subjects_test <- read.table('test/subject_test.txt')
        testdata <- cbind(subjects_test,activity_test,data_test)

# Merging the training and testing datasets and replacing column names.
        fulldata <- rbind(trainingdata,testdata)
        colnames(fulldata) <- c('Subject','Activity',featurenames)
        fulldata$Subject <- as.factor(fulldata$Subject)
        fulldata$Activity <- factor(fulldata$Activity, levels = activity[,1], labels = activity[,2])

# Averaging the variables data based on activity and subject.(hence leaving columns 1 and 2.)
        data <- ddply(fulldata, .(Subject,Activity), function(x){colMeans(x[,3:81])})

# Writing the tidy data to text file.
        write.table(data, file = "tidydata.txt", sep=" ", row.names=F)
