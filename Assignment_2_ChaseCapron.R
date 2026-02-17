# Assignemnt 2 - Chase Capron

library(datasets)
data(iris)

# Question 1. Utilize R to generate a box plot, histogram and scatter plot to explore the
# characteristics of the iris dataset. For each sub-question, include a screenshot of the generated
# plot in your Word file.

# a) Create a box plot to visualize the distribution of variables in the iris dataset. Choose
# two variables (columns) from the dataset that are suitable for creating a meaningful box
# plot. Describe the patterns you observe from the box plot.

boxplot(iris$Sepal.Length ~ iris$Species,
        main="Box Plot of Sepal Length by Species",
        xlab="Species",
        ylab="Sepal Length (cm)",
        col=c("lightblue", "lightgreen", "lightpink"))

# b) Create a histogram to visualize the distribution of Sepal Width in the iris dataset. Decide
# on an appropriate number of bins to effectively represent the data distribution. Pay
# attention to the shape of the histogram, interpret the patterns shown by the histogram.

hist(iris$Sepal.Width,
     main="Histogram of Sepal Width",
     xlab="Sepal Width (cm)",
     ylab="Frequency",
     col="lightgray",
     breaks=10)

# c) Create a scatter plot to visualize a relationship in the iris dataset. Choose two
# variables from the dataset that you believe will provide valuable insights when
# visualized using scatterplots. You can experiment with different pairs of variables to
# identify patterns. Describe the patterns, relationships, or trends that you observe from
# the scatterplots.

plot(iris$Petal.Length, iris$Petal.Width,
     main="Scatter Plot of Petal Length vs Petal Width",
     xlab="Petal Length (cm)",
     ylab="Petal Width (cm)",
     col=iris$Species,
     pch=19)

# Question 2. Calculate the correlation coefficient matrix for the first four variables in the dataset.

correlation_matrix <- cor(iris[, 1:4])
correlation_matrix

# Based on the correlation coefficient matrix, we can observe the following relationships:
# 1. Sepal.Length and Sepal.Width have a weak negative correlation, indicating that
#    as Sepal.Length increases, Sepal.Width tends to decrease slightly.
# 2. Sepal.Length and Petal.Length have a strong positive correlation, suggesting that
#    longer sepals are associated with longer petals.
# 3. Sepal.Length and Petal.Width also show a strong positive correlation, indicating
#    that longer sepals are associated with wider petals.
# 4. Sepal.Width and Petal.Length have a weak negative correlation, suggesting that
#    wider sepals are associated with shorter petals.
# 5. Sepal.Width and Petal.Width have a weak negative correlation, indicating that
#    wider sepals are associated with narrower petals.
# 6. Petal.Length and Petal.Width have a very strong positive correlation, suggesting
#    that longer petals are associated with wider petals.