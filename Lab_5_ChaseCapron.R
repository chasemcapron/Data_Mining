# Lab 5 - Naive Bayes Classifier
# Install Packages
install.packages("e1071")
library(e1071)

# Load in CSV file
setwd("C:/Users/chase/OneDrive/Documents/Desktop Materials/Classes/Spring '26/Bus Data Mining/R Files")
mushroom <- read.csv('Mushroom.csv', stringsAsFactors = T, na.strings=NA)

summary(mushroom)

# Check completion
nrow(mushroom[!complete.cases(mushroom),])
# [1] 2480

# Retail observations that are not null
mushroom = mushroom[complete.cases(mushroom),]

# 70% Training, 30% Test
sample_size <- floor(0.7 * nrow(mushroom))

# Randomly select index of observations for training
training_index <- sample(nrow(mushroom), size = sample_size, replace = FALSE)
train <- mushroom[training_index,]
test <- mushroom[-training_index,]

# Fitting & Model Performance
mushroom.model <- naiveBayes(classes ~ . , data = train)
mushroom.model

# Predictions
mushroom.predict <- predict(mushroom.model, test, type = 'class')

# Results
results <- data.frame(actual=test[,'classes'], predicted=mushroom.predict)

# Matrix Creation
table(results)

# Calculate overall accuracy
results$correct <- ifelse(results$actual==results$predicted,1,0)
sum(results$correct)/nrow(results)
# [1] 0.9397519