
##Loading Data....
sub_test <- read.table("./test/subject_test.txt", quote="\"")
test_x <- read.table("./test/X_test.txt", quote="\"")
test_y <- read.table("./test/y_test.txt", quote="\"")
sub_train <- read.table("./train/subject_train.txt", quote="\"")
train_x <- read.table("./train/X_train.txt", quote="\"")
train_y <- read.table("./train/y_train.txt", quote="\"")

features <- read.table("./features.txt", quote="\"")
activity_labels <- read.table("./activity_labels.txt", quote="\"")

#Merging DataSets
sub_data <- rbind(sub_test, sub_train)
colnames(sub_data) <- "SubjectNumber"

label_data <- rbind(test_y, train_y)
colnames(label_data) <- "Label"
label_dataActual <- merge(label_data, activity_labels, by=1)
label_dataActual <- label_dataActual[,-1]

data_set <- rbind(test_x, train_x)
colnames(data_set) <- features[,2]


#Creating One big dataset
data_total <- cbind(sub_data, label_dataActual, data_set)


#Extracting only measurements on the mean and standard deviation
toMatch <- c("mean\\(\\)", "std\\(\\)") #Matching mean and std
matches <- grep(paste(toMatch,collapse="|"), features[,2], value=FALSE)
matches <- matches+2 #To compensate for the 2 new extra rows in the beginning

#Createing new dataset including description labels, subject and mean & std
data_mean <- data_total[,c(1,2,matches)]

#Printing the data table to a file
write.table(data_mean, "./data_mean.txt" , sep = ";")


#Creating independent tidy dataset..
library(reshape2)

# Creating a dataset on the basis of subject and activity
melt_data = melt(data_total, id.var = c("SubjectNumber", "label_dataActual"))

avLabelActual = dcast(melt_data, SubjectNumber + label_dataActual ~ variable,mean)

#Write the table to the folder
write.table(avLabelActual, "./avLabelActual.txt" , sep = ";")