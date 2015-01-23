 #to read all the data  and labels files into r       
        testdat <- read.table("testdata.csv", header = FALSE)
        traindat <- read.table("traindata.txt", header = FALSE)
        testsub <- read.table("testsubject.txt", header = FALSE)
        trainsub <- read.table("trainsubject.txt", header = FALSE)
        testlab <- read.table("testlabels.txt", header = FALSE)
        trainlab <- read.table("trainlabels.txt", header = FALSE)
        features <- read.table("features.txt", header = FALSE)
        
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