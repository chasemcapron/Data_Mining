# Assignment 7 - Chase Capron
# Install packages
install.packages("C50")
install.packages("pROC")

library(C50)
library(pROC)

# Read in csv file affairs.csv.
affairs <- read.csv("affairs.csv", na.strings = "NA", stringsAsFactors = TRUE)

# Set if_affair as factor (per assignment instructions)
affairs$if_affair <- as.factor(affairs$if_affair)

# Set seed so the random 80/20 split is reproducible
set.seed(123)

################################################################
# Decision Tree
################################################################

# Partition dataset for training (80%) and testing (20%)
size <- floor(0.8 * nrow(affairs))
### Randomly decide which ones for training
training_index <- sample(nrow(affairs), size = size, replace = FALSE)
train <- affairs[training_index,]
test <- affairs[-training_index,]

# Names of variables that used for prediction (exclude target, column 5)
var_names <- names(affairs)[-5]

# Fit the model
dt <- C5.0(x = train[, var_names], y = train$if_affair)
# See the summary of model
summary(dt)
### Now, validate test
## predict() method returns a vector of result
dt_pred <- predict(dt, newdata = test)
### Merge dt_prediction value to test dataset
dt_evaluation <- cbind(test, dt_pred)

### Compare dt_prediction result to actual value
dt_evaluation$correct <- ifelse(dt_evaluation$if_affair ==
                                  dt_evaluation$dt_pred, 1, 0)
### Accuracy rate
sum(dt_evaluation$correct) / nrow(dt_evaluation)

### Confusion matrix
table(dt_evaluation$if_affair, dt_evaluation$dt_pred)

### TPR = count of true positive divided by total positive
TPR <- sum(dt_evaluation$dt_pred == 'yes' & dt_evaluation$if_affair ==
             'yes') / sum(dt_evaluation$if_affair == 'yes')

### TNR = count of true negative divided by total negative
TNR <- sum(dt_evaluation$dt_pred == 'no' & dt_evaluation$if_affair == 'no') / sum(dt_evaluation$if_affair == 'no')

### FPR = count of false positive divided by total negative
### = sum(dt_evaluation$dt_pred == 'yes'& dt_evaluation$if_affair == 'no' ) / sum(dt_evaluation$if_affair == 'no') 
FPR <- 1 - TNR

### FNR = FN / P = count of false negative divided by total positive
### = sum(dt_evaluation$dt_pred == 'no'& dt_evaluation$if_affair == 'yes' )/ sum(dt_evaluation$if_affair == 'yes') 
FNR <- 1 - TPR

### Precision = number of true positive / total predicted positive
dt_precision <- sum(dt_evaluation$if_affair == 'yes' &
                      dt_evaluation$dt_pred == 'yes') / sum(dt_evaluation$dt_pred == 'yes')
dt_precision

### Recall = number of true positive / total actual positive
dt_recall <- sum(dt_evaluation$if_affair == 'yes' &
                   dt_evaluation$dt_pred == 'yes') / sum(dt_evaluation$if_affair == 'yes')
dt_recall

### F score
F <- 2 * dt_precision * dt_recall / (dt_precision + dt_recall)
F

################################################################
# Logistic Regression
################################################################

### Partition dataset for training (80%) and testing (20%)
size <- floor(0.8 * nrow(affairs))
### Randomly decide which ones for training
training_index <- sample(nrow(affairs), size = size, replace = FALSE)
train <- affairs[training_index,]
test <- affairs[-training_index,]

### Fitting regression model
reg <- glm(if_affair ~ . , data = train, family = binomial() )
### Model detail
summary(reg)

### Validate test dataset
evaluation <- test
evaluation$prob <- predict(reg, newdata = evaluation, type = "response")

### Baseline of positive result (if_affair == "yes")
count_affair <- nrow(subset(affairs, affairs$if_affair == "yes") )
baseline <- count_affair / nrow(affairs)
baseline

### Feed Sensitivity & Specificity to roc()
g <- roc(evaluation$if_affair ~ evaluation$prob, data = evaluation)
# ROC curve
plot(g)

g
# Area under the curve will print