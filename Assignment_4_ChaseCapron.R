# Assignment 4 - Chase Capron

setwd("C:/Users/chase/OneDrive/Documents/Desktop Materials/Classes/Spring '26/Bus Data Mining/R Files")

# Question 1. Please build a Naïve Bayes classifier following the in-class instruction of Lab 4. The
# dataset is Balance_Scale.csv. The class label (also called outcome or dependent variable) is
# called classes. Please determine whether there is any missing value once loaded the data.
# Delete all the records whose class label is “balanced” (classes=="B"). Then train your Naïve
# Bayes model. What is the overall prediction accuracy of your model using test data? Your answer
# should include the source code, returned confusion matrix, and calculated accuracy.
# (Hint: to delete records that classes=="B" easily, please consider using slicing function of the loaded
  # data frame. For example, if the data frame is defined as data, you should set data$classes=="B"
  # as a condition in the slicing function data[...].)

# Install Packages
install.packages("e1071")
library(e1071)

# Load in CSV Files
balance <- read.csv('Balance_Scale.csv', stringsAsFactors = T, na.strings=NA)

# Check Completion
nrow(balance[!complete.cases(balance),])
# [0]

# Delete Records with classes == "B"
balance <- balance[balance$classes != "B",]

# 70% Training, 30% Test
sample_size <- floor(0.7 * nrow(balance))

# Randomly select index of observations for training
training_index <- sample(nrow(balance), size = sample_size, replace = FALSE)
train <- balance[training_index,]
test <- balance[-training_index,]

# Fitting & Model Performance
balance.model <- naiveBayes(classes ~ . , data = train)
balance.model

# Predictions
balance.predict <- predict(balance.model, test, type = 'class')

# Results
results <- data.frame(actual=test[,'classes'], predicted=balance.predict)

# Matrix Creation
table(results)

# Calculate overall accuracy
results$correct <- ifelse(results$actual==results$predicted,1,0)
sum(results$correct)/nrow(results)
# [1] 0.9714286 

# Question 2. Please build a Naïve Bayes classifier following the in-class instruction of Lab 5. The
# dataset is abalone.csv. The class variable is called Sex. Same as the first question, please
# determine whether there is any missing value before building the classifier. What is the overall
# prediction accuracy of your model using test data? Look at the data again, what might be an
# explanation about the accuracy you observe? Your answer should include the source code,
# returned confusion matrix, and calculated accuracy.

# Load in CSV Files
abalone <- read.csv('abalone.csv', stringsAsFactors = T, na.strings = NA)

# Check Completion
nrow(abalone[!complete.cases(abalone),])
# [0]

# 70% Training, 30% Test
sample_size <- floor(0.7 * nrow(abalone))

# Randomly select index of observations for training
training_index <- sample(nrow(abalone), size = sample_size, replace = FALSE)
train <- abalone[training_index,]
test <- abalone[-training_index,]

# Fitting & Model Performance
abalone.model <- naiveBayes(Sex ~ . , data = train)
abalone.model

# Predictions
abalone.predict <- predict(abalone.model, test, type = 'class')

# Results
results2 <- data.frame(actual=test[ 'Sex'], predicted=abalone.predict)

# Matrix Creation
table(results2)

# Calculate overall accuracy
results2$correct <- ifelse(results2$Sex == results2$predicted, 1, 0)
sum(results2$correct) / nrow(results2)
# 0.5088132