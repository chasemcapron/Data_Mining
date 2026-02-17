# Lab 2 - Chase Capron

# Install packages containing data sets
install.packages("VIM")
library(VIM)

install.packages("mice")
library(mice)

# Load sleep data set from VIM package
data(sleep, package="VIM")
head(sleep)

# Check for missing values
nrow(sleep)

# Remove rows with missing values
sleep[complete.cases(sleep),]
na.omit(sleep)

# Count rows without missing values
nrow(sleep[complete.cases(sleep),])

# Reverse condition logic
sleep[!complete.cases(sleep),]
nrow(sleep[!complete.cases(sleep),])

# Check how many obs containing missing value in "Dream"
sum(is.na(sleep$Dream))

# Show mean of obs (19%)
mean(is.na(sleep$Dream))

# Show mean of obs with any missing value (32%)
mean(!complete.cases(sleep))

# Call function md.pattern from mice package
md.pattern(sleep)

# Call funcrion aggr (), prop = FALSE concert % value into counts
aggr(sleep, prop = FALSE, numbers = TRUE)

# Call FN marginplot
marginplot(sleep[c("Gest","Dream")], pch=c(20), col = c("darkgray", "red", "blue"))

# Transform data into 1 and 0

disofNa <- as.data.frame(abs(is.na(sleep)))
corrNa <- disofNa[c("NonD", "Dream","Sleep","Span", "Gest")]
cor(corrNa)

# load dataset mtcars into R and show relationship between mpg and # of
boxplot(mpg ~ cyl, # mpg is the target variable, cyl is the explanatory variable
        data = mtcars, # explicitly telling R which dataset to look into
        col = "#500000", # you can make it in red, green or any other you like
        main = "Mileage Data", # title of the returned visualization
        ylab = "MPG", # name of vertical axis
        xlab = "Number of Cylinders" ) # name of horizontal axis

# show histogram for mgp column in mtcars data frame
# parameter ‘breaks’ set the breakpoints of the bins (columns)
hist(mtcars$mpg,
     breaks=seq(from = 10, to = 35, by = 2.5),
     main="Histogram of Millage per Gallon", # title of the histogram
     xlab="Vehicle MPG", # label of x axis
     ylab="Number of Vehicles") # label of y axis

# Visualize mpg and weight in a scatter plot
plot(mpg ~ wt, data = mtcars,
     col = "blue",
     main="Scatter Plot of Vehicle Weight VS MPG",
     xlab="Vehicle Weight",
     ylab="MPG",
     pch=20)

# Tranform numeric MPG to categorical
mtcars$mpg.group <- 'Medium' # assign every car to MPG group med first
mtcars[mtcars$mpg > 24, "mpg.group"] <- 'High' # if MPG>24, assign the car
# to high group
mtcars[mtcars$mpg < 18, "mpg.group"] <- 'Low' # if MPG<18, assign the car
# to low group
mtcars$mpg.group <- as.factor(mtcars$mpg.group) # Convert group to factor

counts <- table(mtcars$mpg.group)

barplot(counts,
        col=c("lightblue", "blue", "navy"),
        main="Bar Chart for MPG Categories",
        xlab="MPG Category",
        ylab="Number of Vehicles")



