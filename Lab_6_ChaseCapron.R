# Lab 6 - Support Vector Machine

# Install Libraries
install.packages("e1071")
library(e1071)

# Load the data
data(iris)

# Create a subset with only versicolor and virginica species
iris1 <- subset(iris, Species != "setosa")

# Check the levels of Species in Iris2
levels(iris$Species)
# [1] "setosa"     "versicolor" "virginica" 

# Remove the unused "Setosa" level and keep only versicolor and verginica
iris1$Species <- factor(iris1$Species, levels = c("versicolor", "virginica"))

# Set seed to ensure reproducdible results
set.seed(650)

# Calculate 70% * rows
sample_size <- floor(0.7 * nrow(iris1))

# Get the data frame indices of our random sample
training_index <- sample(nrow(iris1), size = sample_size)

# Get the rows by the index from sample
train <- iris1[training_index,]

# Get the rows not in the index
test <- iris1[-training_index,]

# Build model
svm_model <-svm(Species ~., data=train, method="C-classification", kernel="linear")

# Show details of the SVM
summary(svm_model)
# Call:
# svm(formula = Species ~ ., data = train, method = "C-classification", 
#     kernel = "linear")
# Parameters:
#   SVM-Type:  C-classification 
# SVM-Kernel:  linear 
# cost:  1 
# Number of Support Vectors:  12
# ( 6 6 )
# Number of Classes:  2 
# Levels: 
#   versicolor virginica

# Evaluate the model
iris.pred <-predict(svm_model, test)

# Results
results <- data.frame(actual = test[,'Species'], predicted = iris.pred)
table(results)
# predicted
# actual       versicolor virginica
# versicolor         16         2
# virginica           0        12

# Calculate overall accuracy
results$Correct <- ifelse(results$actual == results$predicted, 1, 0)
sum(results$correct)/nrow(results)
# [1] 0.9333333

# Visualize the SVM results
iris2 = iris1[,c(3,4,5)]
train2 <- iris2[training_index,]
svm_model2 <-svm(Species ~., data=train2, method="C-classification", kernel="linear")
plot(svm_model2, train2, col = c("steelblue","white"))