# Assignment 1 - Chase Capron

getwd()
setwd("C:/Users/chase/OneDrive/Documents/Desktop Materials/Classes/Spring '26/Bus Data Mining/R Files")

# Q1: Suppose you keep track of your mileage each time you fill up your car. At your last eight fill
# ups the mileage was: 24317, 24781, 25008, 25239, 25442, 25801, 26089

# Q1A: Find number of miles between fill ups. (Hint: function diff() returns differences between
# consecutive values in a vector.)

a <- c(24317, 24781, 25008, 25239, 25442, 25801, 26089)
b <- diff(a)

# Q1B: What is the maximum and average number of miles between fill ups? (Hint: functions
# max() and mean().)

max(b)
mean(b)

# Q2: Suppose you track you commute time for 10 days and you find the following times in minutes
# 32, 46, 41, 52, 36, 28, 37, 41, 38, 37

# Q2: How many times was your commute 40 minutes or more? What percent of your
# commute are less than 35 minutes?

a <- c(32, 46, 41, 52, 36, 28, 37, 41, 38, 37)

b <- sum(a >= 40)
b

c <- sum(a < 35)

d <- (c / length(a)) * 100
d

# Q3: Assume that we have the following three observations of temperature: 38 ℃, 16 ℃ and
# 23 ℃. The conversion from Celsius to Fahrenheit temperature is given below:

# Q3: Use a vector to save all the Celsius temperatures, then convert them to Fahrenheit.

a <- c(38, 16, 23)
b <- (a * 9/5) + 32
b

# Q4: Assume that you are interested in cone-shaped structures and have measured the height and
# radius of six cones.
# R = (1.54, 2.18, 3.82, 2.44, 2.73, 1.64)
# H = (5.37, 8.25, 9.36, 7.70, 6.72, 5.59)
# The volume V of a cone with radius R and Height H is given by the formula below:
#   𝑉 = 1
# 3 𝜋𝑅2𝐻
# where 𝜋 = 3.14

# Q4A: What are the volumes of the six cones? Use a vector to save all the volumes.

r <- c(1.54, 2.18, 3.82, 2.44, 2.73, 1.64)
h <- c(5.37, 8.25, 9.36, 7.70, 6.72, 5.59)
volumes <- (1/3) * 3.14 * (r^2) * h
volumes

# Q4B: Use functions mean(), median(), and sd() to compute the mean, median and standard
# deviation of the cone volumes, respectively.

mean(volumes)
median(volumes)
sd(volumes)

# Q4C: Compute the mean of volume for the cones with a height less than 7.5. (Hint: use function
# subset())

mean(subset(volumes, h < 7.5))

# Q5: There is a file Sample.txt on Canvas website under Lab 1 that contains the names and ages
# of US presidents who have died since 1900. The file is Tab separated. Read the file using the
# command below and print the data.

mydata <- read.table("Sample.txt", header=TRUE)

# Q5A: Create a histogram of the ages of presidents (graph of frequencies) and save the image.
# (Hint: the function for generating histogram is hist())

hist(mydata$Age, main="Ages of US Presidents", xlab="Age", ylab="Frequency", col="lightblue")

# Q5B: Show the names and ages of the 10 youngest presidents, starting from the youngest. (Hint:
# think about sorting the data with a particular order.)

sorted_data <- mydata[order(mydata$Age), ]
youngest_10 <- head(sorted_data, 10)
youngest_10

# Q6: There are two comma separated value (CSV) files on Canvas website under Lab 1:
# Demographics.csv and QuestionAnswers.csv. There is a common column called
# WorkerId (case-sensitive) shared by both files.

# Q6: Read these two CSV files and merge them into a single data frame. Save the data
# frame into a separate CSV file. Name the file yourself. You only need to provide your source
# code. The merged new file is not required for submission.

demographics <- read.csv("Demographics.csv", header=TRUE)
question_answers <- read.csv("QuestionAnswers.csv", header=TRUE)
merged_data <- merge(demographics, question_answers, by="WorkerId")
write.csv(merged_data, "MergedData.csv", row.names=FALSE)

