
The objective of the analysis is to create a tidy data set of the average of each of the selected 88 variables for each activity (6 activities) and each subject (30 subjects).

The above objective is created by writing an R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Below is a list of the variables used for the analysys.

"activity" Six possible activities: 1 WALKING, 
2 WALKING_UPSTAIRS, 
3 WALKING_DOWNSTAIRS, 
4 SITTING, 
5 STANDING, 
6 LAYING

"subject": integer values 1 to 30 representing each of the volunteers that took part in the experiment

All the variables below represent means by foreach activity and each subject of normalised units, therefore they are unitless
"time.body.acceleration.meanX"
"time.body.acceleration.meanY"
"time.body.acceleration.meanZ"
"time.gravity.acceleration.meanX"
"time.gravity.acceleration.meanY"
"time.gravity.acceleration.meanZ"
"time.body.acceleration.JerkmeanX"
"time.body.acceleration.JerkmeanY"
"time.body.acceleration.JerkmeanZ"
"time.body.GyromeanX"
"time.body.GyromeanY"
"time.body.GyromeanZ"
"time.body.GyroJerkmeanX"
"time.body.GyroJerkmeanY"
"time.body.GyroJerkmeanZ"
"time.body.acceleration.Magmean"
"time.gravity.acceleration.Magmean"
"time.body.accelerationJerkMagmean"
"time.body.GyroMagmean"
"time.body.GyroJerkMagmean"
"frequency.body.acceleration.meanX"
"frequency.body.acceleration.meanY"
"frequency.body.acceleration.meanZ"
"frequency.body.acceleration.meanFreqX"
"frequency.body.acceleration.meanFreqY"
"frequency.body.acceleration.meanFreqZ"
"frequency.body.acceleration.JerkmeanX"
"frequency.body.acceleration.JerkmeanY"
"frequency.body.acceleration.JerkmeanZ"
"frequency.body.acceleration.JerkmeanFreqX"
"frequency.body.acceleration.JerkmeanFreqY"
"frequency.body.acceleration.JerkmeanFreqZ"
"frequency.body.GyromeanX"
"frequency.body.GyromeanY"
"frequency.body.GyromeanZ"
"frequency.body.GyromeanFreqX"
"frequency.body.GyromeanFreqY"
"frequency.body.GyromeanFreqZ"
"frequency.body.acceleration.Magmean"
"frequency.body.acceleration.MagmeanFreq"
"frequency.body.body.acceleration.JerkMagmean"
"frequency.body.body.acceleration.JerkMagmeanFreq"
"frequency.body.bodyGyroMagmean"
"frequency.body.bodyGyroMagmeanFreq"
"frequency.body.bodyGyroJerkMagmean"
"frequency.body.bodyGyroJerkMagmeanFreq"
"angle.time.body.acceleration.Mean.gravity"
"angle.time.body.acceleration.JerkMean.gravityMean"
"angle.time.body.GyroMean.gravityMean"
"angle.time.body.GyroJerkMean.gravityMean"
"angleX.gravityMean"
"angleY.gravityMean"
"angleZ.gravityMean"
"time.body.acceleration.elerationstdX"
"time.body.acceleration.elerationstdY"
"time.body.acceleration.elerationstdZ"
"time.gravity.acceleration.stdX"
"time.gravity.acceleration.stdY"
"time.gravity.acceleration.stdZ"
"time.body.acceleration.JerkstdX"
"time.body.acceleration.JerkstdY"
"time.body.acceleration.JerkstdZ"
"time.body.GyrostdX"
"time.body.GyrostdY"
"time.body.GyrostdZ"
"time.body.GyroJerkstdX"
"time.body.GyroJerkstdY"
"time.body.GyroJerkstdZ"
"time.body.acceleration.Magstd"
"time.gravity.acceleration.Magstd"
"time.body.acceleration.elerationJerkMagstd"
"time.body.GyroMagstd"
"time.body.GyroJerkMagstd"
"frequency.body.acceleration.stdX"
"frequency.body.acceleration.stdY"
"frequency.body.acceleration.stdZ"
"frequency.body.acceleration.JerkstdX"
"frequency.body.acceleration.JerkstdY"
"frequency.body.acceleration.JerkstdZ"
"frequency.body.GyrostdX"
"frequency.body.GyrostdY"
"frequency.body.GyrostdZ"
"frequency.body.acceleration.Magstd"
"frequency.body.body.acceleration.JerkMagstd"
"frequency.body.body.GyroMagstd"
"frequency.body.body.GyroJerkMagstd"

Below is the r script used to create the tidy dataset fromthe raw data.

 #to read all the data  and labels files into r       
        testdat <- read.table("testdata.csv", header = FALSE)
        traindat <- read.table("traindata.txt", header = FALSE)
        testsub <- read.table("testsubject.txt", header = FALSE)
        trainsub <- read.table("trainsubject.txt", header = FALSE)
        testlab <- read.table("testlabels.txt", header = FALSE)
        trainlab <- read.table("trainlabels.txt", header = FALSE)
        features <- read.table("features.txt", header = FALSE)
        git
 #to addthe labels to the data
        datlabels <-as.character(features[,2])
        make.names(datlabels, unique=TRUE)
        sublabels <- c("subject")
        actlabels <- c("activity")
        colnames(testdat)<-datlabels
        colnames(traindat)<-datlabels
        colnames(trainsub)<-sublabels
        colnames(testsub)<-sublabels
        colnames(testlab)<-actlabels
        colnames(trainlab)<-actlabels
        
#To merge the data tables
        test <-cbind(testlab, testsub, testdat)
        train <-cbind(trainlab, trainsub, traindat)
        all <-rbind(test, train)
        
library (dplyr)
        all1 <-tbl_df(all)
        
#To remove duplicated column names        
        duplicated <- which(duplicated(datlabels))
        all2 <- all1[, -duplicated]
        
# to extract the columns containing means and standard deviations
        all3 <- select (all2, activity, subject, contains("mean", ignore.case = TRUE),
                        contains("std", ignore.case = TRUE))

# To export the column names to a text editor in order to relabel
        write.table(colnames(all3), file="CodeBook1.md", row.names=FALSE)
        
#To import edited labels 
        tidyfeatures <- read.table("CodeBook.md", header = FALSE)
        colnames(all3)<-tidyfeatures[ ,1]
        
# to group and summarise data 
        all4 <-group_by(all3, subject, activity)
        all5 <- summarise_each(all4, funs(mean))
        
# to write the tidy data set
        write.table(all5, file="tidy.data.set.md", row.names=FALSE)
