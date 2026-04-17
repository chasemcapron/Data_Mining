# Lab 9 - Chase Capron
# Install packages
install.packages("C50")
install.packages("pROC")

library(C50)
library(pROC)

# Read in csv file adult.csv.
adult <- read.csv("adult.csv", na.strings = "NA", stringsAsFactors = TRUE)

# Partition dataset for training (80%) and testing (20%)
size <- floor(0.8 * nrow(adult))
### Randomly decide which ones for training
training_index <- sample(nrow(adult), size = size, replace = FALSE)
train <- adult[training_index,]
test <- adult[-training_index,]

# Names of variables that used for prediction
var_names <- names(adult)[-15]

# Fit the model
dt <- C5.0(x = train[, var_names], y = train$if_above_50K)
# See the summary of model
summary(dt)
### Now, validate test
## predict() method returns a vector of result
dt_pred <- predict(dt, newdata = test)
### Merger dt_prediction value to test dataset
dt_evaluation <- cbind(test, dt_pred)

### Compare dt_prediction result to actual value
dt_evaluation$correct <- ifelse(dt_evaluation$if_above_50K ==
                                  dt_evaluation$dt_pred, 1, 0)
### Accuracy rate
sum(dt_evaluation$correct) / nrow(dt_evaluation)
# [1] 0.8702595
### Confusion matrix
table(dt_evaluation$if_above_50K, dt_evaluation$dt_pred)
## no yes
## no 4670 270
## yes 610 963

### TPR = count of true positive divided by total positive
TPR <- sum(dt_evaluation$dt_pred == 'yes' & dt_evaluation$if_above_50K ==
             'yes') / sum(dt_evaluation$if_above_50K == 'yes')

### TNR = count of true negative divided by total negative
TNR <- sum(dt_evaluation$dt_pred == 'no' & dt_evaluation$if_above_50K == 'no') / sum(dt_evaluation$if_above_50K == 'no')

### FPR = count of false positive divided by total negative
### = sum(dt_evaluation$dt_pred == 'yes'& dt_evaluation$if_above_50K == 'no' ) / sum(dt_evaluation$if_above_50K == 'no') 
FPR <- 1 - TNR

### FNR = FN / P = count of false negative divided by total positive
### = sum(dt_evaluation$dt_pred == 'no'& dt_evaluation$if_above_50K == 'yes' )/ sum(dt_evaluation$if_above_50K == 'yes') 
FNR <- 1 - TPR

### precision = number of true positive / total positive
dt_precision <- sum(dt_evaluation$if_above_50K == 'yes' &
                      dt_evaluation$dt_pred == 'yes') / sum(dt_evaluation$dt_pred == 'yes')

### F score
F <- 2 * dt_precision * dt_recall / (dt_precision + dt_recall)

titanic <- read.csv("titanic.csv", stringsAsFactors=TRUE)
### Partition dataset for training (80%) and testing (20%)
size <- floor(0.8 * nrow(titanic))
### Randomly decide which ones for training
training_index <- sample(nrow(titanic), size = size, replace = FALSE)
train <- titanic[training_index,]
test <- titanic[-training_index,]

### Fitting regression model
reg <- glm(survive ~ . , data = train, family = binomial() )
### Model detail
summary(reg)

### Validate test dataset
evaluation <- test
evaluation$prob <- predict(reg, newdata = evaluation, type = "response")

count_survive <- nrow(subset(titanic, titanic$survive == "yes") )
baseline <- count_survive / nrow(titanic)
baseline
# [1] 0.323035

### Feed Sensitivity & Specificity to roc()
g <- roc(evaluation$survive ~ evaluation$prob, data = evaluation)
# ROC curve
plot(g)

g
# Area under the curve: 0.7221

