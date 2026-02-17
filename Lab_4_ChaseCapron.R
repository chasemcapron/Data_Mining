# Lab 4 - Neural Networks
# College Data Set
install.packages("ISLR")
install.packages("neuralnet")

library(ISLR)

str(College)

# Preprocessing
# Create Vector of Column Max / Min Values
maxs <- apply(College[,2:18], 2, max)
mins <- apply(College[,2:18], 2, min)

# Use scale() and convert the resulting matrix to a data frame
scaled.data <- as.data.frame(scale(College[,2:18], center = mins, scale = maxs - mins))

# Check out results
head(scaled.data)

# Convert Private column from Y/N to 1/0
Private <- as.numeric(College$Private) - 1
data <- cbind(Private, scaled.data)

# Step 1: calculate 70% * rows and round to nearest integer
sample_size <- floor(0.7 * nrow(data))

# Step 2: Get the data frame indices of our random sample
training_index <- sample(nrow(data), size = sample_size)

# Step 3a: Get the rows by the index from our sample
train <- data[training_index,]
test <- data[-training_index,]

# Step 3b: Get the rows not in the index

# NEURAL NETWORK FUNCTION
features <- names(scaled.data)

# CONCATENATE STRINGS
f <- paste(features, collapse='+')
f<- paste('Private ~', f)

# Convert to formula
f <- as.formula(f)
f

library(neuralnet)
nn <- neuralnet(f, data = train, hidden = c(5,3), linear.output = FALSE)

# PREDICTIONS AND EVALUATIONS
# Compute Predictions off Test Set
predicted <- compute(nn, test[2:18])

# Check out net result
head(predicted$net.result)

predicted$net.result <- sapply(predicted$net.result, round, digits = 0)

evaluation <- data.frame(test$Private, predicted$net.result)
colnames(evaluation) <- c("actual", "predict")
table(evaluation)

evaluation$correct <- ifelse(evaluation$actual == evaluation$predict, 1, 0)
sum(evaluation$correct)/nrow(evaluation)

plot(nn, intercept = FALSE)
