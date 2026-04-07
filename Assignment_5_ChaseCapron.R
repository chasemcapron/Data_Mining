# Chase Capron - Assignment 5

getwd()
setwd("C:/Users/chase/OneDrive/Documents/Desktop Materials/Classes/Spring '26/Bus Data Mining/R Files")

install.packages("ggplot2")

# Load packages
library(ggplot2)

# Read the data
iris_data <- read.csv("iris.csv")

# Take attributes Petal.Length and Petal.Width as the two dimensions
iris_sub <- iris_data[, c("Petal.Length", "Petal.Width")]

# Initial scatter plot of the unclustered data
plot(iris_sub, pch = 16, main = "Original Iris Data (Petal Length vs Width)")

# Normalized Function (matching the lab structure)
normalize <- function(feature){
  normalized <- ((feature - min(feature)) / (max(feature) - min(feature)))
  return (normalized)
}

# Apply normalization
nor_iris <- apply(iris_sub[,c(1,2)], 2, FUN = normalize)
nor_iris <- as.data.frame(nor_iris)

# Create a function that returns the value of totwithinss
totwithinss <- function(dataset, number_of_centers){
  # Added nstart=20 to ensure we get the best random starting centroids
  km <- kmeans(dataset, number_of_centers, nstart = 20) 
  km$tot.withinss
}

# vec is a vector that contains totwithinss values associated with k from 1 to maxk
distortion.k <- function(dataset, maxk){
  vec <- as.vector(1:maxk)
  vec[1:maxk] <- sapply(1:maxk, totwithinss, dataset = dataset)
  return(vec)
}

# max k = 10
maxk <- 10
dis_vct <- distortion.k(nor_iris, maxk)

# Elbow Curve Plot
plot(1:maxk, # horizontal axis
     dis_vct, # vertical axis
     type = 'b', # curve
     col = 'blue',
     xlab = "Number of clusters",
     ylab = "Total WithinSS",
     main = "Elbow Curve Plot"
)

# Number of clusters based on the elbow curve
# The "elbow" or bend in the curve happens clearly at k = 3
num_cluster <- 3

# Run k-means with the optimal k
result <- kmeans(nor_iris, num_cluster, nstart = 20)

# Extract centers
centers <- as.data.frame(result$centers)

# Add cluster assignments to our normalized dataset for plotting
nor_iris$cluster <- as.factor(result$cluster)

# Question 3: Generate a scatterplot using ggplot()
# Base layer
plot.iris <- ggplot(data = nor_iris, aes(x = Petal.Length, y = Petal.Width, color = cluster))

# Plotting the points and cluster centers
plot.iris + geom_point(alpha = 0.5, size = 5) +
  # Cluster centers, colored black
  geom_point(data = centers, aes(x = Petal.Length, y = Petal.Width), size = 6,
             color = 'black', shape = 4, stroke = 2) +
  # Add a title, align to the center
  theme(plot.title = element_text(hjust = 0.5)) +
  ggtitle("K-means Clusters: Petal Length vs Petal Width")

