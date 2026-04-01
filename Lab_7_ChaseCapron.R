# Chase Capron - Lab 7
# Install package ggplot2 and animation
install.packages("ggplot2")
install.packages("animation")

# Load packages
library(ggplot2)
library(animation)

crime0 <- read.csv("crime_data.csv")
crime <- crime0[, c('Murder', 'Assault')]

plot(crime, pch=16)

# Normalized Function
normalize <- function(feature){
  normalized <- ((feature - min(feature)) / (max(feature) - min(feature)))
  return (normalized)}

nor_crime <- apply(crime[,c(1,2)], 2, FUN = normIt)
nor_crime <- as.data.frame(nor_crime)

c1 <- kmeans(nor_crime,5)
class(c1)

str(c1)

# Create a function that returns the value of totwithinss, and takes input
# dataset and number of clusters
totwithinss <- function(dataset, number_of_centers){
  km <- kmeans(dataset, number_of_centers)
  km$tot.withinss}

# Test k = 3, k = 5. It can be seen that as the value of k increases, distortion
# decrease
totwithinss(nor_crime, 3)
## [1] 1.363057
totwithinss(nor_crime, 5)
## [1] 1.002086

# vec is a vector that contains totwithinss values associated with k from 1 to
# maxk
distortion.k <- function(dataset, maxk){
  vec <- as.vector(1:maxk)
  vec[1:maxk] <- sapply(1:maxk, totwithinss, dataset = dataset)
  return(vec)}

# max k = 10
maxk <- 10
dis_vct <- distortion.k(nor_crime, maxk)
# Elbow Curve
plot(1:maxk, # horizontal axis
     dis_vct, # vertical axis
     type = 'b', # curve
     col = 'blue',
     xlab = "Number of cluster",
     ylab = "Total WithinSS",
     main = "Elbow Curve Plot",
)

# Number of clusters, k = 4
num_cluster = 4
result <- kmeans.ani(nor_crime, num_cluster)

centers <- as.data.frame(result$centers)
counts <- aggregate(nor_crime, by = list(result$cluster), FUN = length)[, 2]

crime$cluster <- result$cluster

# Base layer
plot.crime <- ggplot(data = nor_crime, aes(x = Murder, y = Assault, color =
                                             result$cluster))

# Alpha: semi-transparent points
plot.crime + geom_point(alpha = .25, size = 5) +
  # Cluster centers, colored black:
  geom_point(data = centers, aes(x = Murder, y = Assault), size = 5,
             color = 'black') +
  # Cool colors for each cluster:
  scale_color_gradientn(colours = rainbow(num_cluster)) +
  # Add a title, align to the center
  theme(plot.title = element_text(hjust = 0.5)) +
  ggtitle("K-means clusters")