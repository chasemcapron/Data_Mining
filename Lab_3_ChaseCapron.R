# Lab 3 - Implementing Decision Trees in R
# Tennis Data Set
install.packages("C50")
library(C50)

playtennis <- read.csv('play_tennis.csv', stringsAsFactors = TRUE)

playtennis
str(playtennis)

predictors <- c('outlook', 'temp', 'humidity', 'wind')

model <- C5.0(x = playtennis[,predictors], y = playtennis$play)

summary(model)
plot(model)

# Titanic Data Set
survive <- read.table('titanic.data', stringsAsFactors = TRUE)
head(survive)
str(survive)

colnames(survive) <- c('class', 'age', 'sex', 'survive')

sample(seq_len(5), 3)

sample_size <- floor(0.8 * nrow(survive))
training_index <- sample(seq_len(nrow(survive)), size = sample_size)
train <- survive[training_index, ]
test <- survive[-training_index, ]

predictors <- c('class', 'age', 'sex')
model <- C5.0(x = train[,predictors], y = train$survive)
summary(model)
plot(model)

pred <- predict(model, newdata = test)
head(pred)

evaluation <- cbind(test, pred)
evaluation

evaluation$correct <- ifelse(evaluation$survive == evaluation$pred, 1, 0)
sum(evaluation$correct) / nrow(evaluation)