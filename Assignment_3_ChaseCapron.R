# Assignment 3 - Chase Capron
# Question 1: Load the file in a data frame called carseats. Use columns Advertising, Price,
# ShelveLoc, Age to build a decision tree to predict Sales. Please show your tree in a plot. What
# are the two most important variables to predict car seat sales?
# Note: Use 85%-15% as the training/test data ratio.

install.packages("C50")
library(C50)
setwd("C:/Users/chase/OneDrive/Documents/Desktop Materials/Classes/Spring '26/Bus Data Mining/R Files")

carseats <- read.csv('carseats.csv', stringsAsFactors = TRUE)

carseats
str(carseats)

sample_size <- floor(0.85 * nrow(carseats))
training_index <- sample(seq_len(nrow(carseats)), size = sample_size)
train <- carseats[training_index, ]
test <- carseats[-training_index, ]

predictors <- c('Advertising', 'Price', 'ShelveLoc', 'Age')
model <- C5.0(x = train[,predictors], y = train$Sales)
summary(model)
plot(model)

# The two most important variables to predict car seat sales are Advertising and ShelveLoc.

# Question 2: Please calculate the overall prediction accuracy of your decision tree, and copy to
# your Word file.

pred <- predict(model, newdata = test)
head(pred)

evaluation <- cbind(test, pred)
evaluation

evaluation$correct <- ifelse(evaluation$Sales == evaluation$pred, 1, 0)
sum(evaluation$correct) / nrow(evaluation)

