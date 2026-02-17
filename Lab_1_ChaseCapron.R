# Getting / Changing Working Directory
getwd()
setwd("C:\Users\chase\OneDrive\Documents\Desktop Materials\Classes\Spring '26\Bus Data Mining\R Files")

save.image(file = 'myFile.Rdata')

# Vector & Data-Frame

# Create Vectors
a <- c(1:5)
b <- c("coffee","milk","monster","juice","coke")
c <- c(8.3,5.5,2.8,7.7,3)
d <- c(10,12,53,74,68)

class(a)
class(b)
class(c)
class(d)

# Create Data-Frame
sales <- data.frame(a,b,c,d)

# Edit Data-Frame
colnames(sales) <- c("ProdID","ProdNM","Price","QTYSold")

# Structure of Data-Frame
str(sales$ProdNM)

# Converting to Characters

sales[,"ProdNM"] <- sapply(sales[,"ProdNM"], as.character)
str(sales$ProdNM)

# Creating new column
sales$Revenue <-sales$Price * sales$QTYSold

# Creating uniform distributed vector
ProdID <- floor(runif(1000, min = 1, max = 6))
ProdID <- runif(1000, min = 1, max = 6)

score <- sample(1:10, 100, replace = T)
review <- data.frame(ProdID, score)

# Count how many rows were generated
nrow(review)

# Check unique ProdIDs
unique(review$ProdID)

# Use Func Summary
summary(review)

# Round mean value to 1 digit
options(digits=2)

# Generate a new attribute
aggReview <- aggregate(review, by = list(ProdID), mean)

# Each product is treated as a group
aggReview

# Rename columns
colnames(aggReview) <- c("ProdGroup","ProdID","AVGRating")

myData <- merge(x = sales, y = aggReview, by = "ProdID", all.x = TRUE)

profitableProd <- subset(myData, Revenue > 100)

profitableProd[order(-profitableProd$Revenue), names(profitableProd)]

saveData <- profitableProd[,c("ProdID", "ProdNM", "Revenue", "AVGRating")]

# Saving & Reading Data
write.csv(saveData,"saveData.csv",row.names = FALSE)

reopenData <- read.csv("saveData.csv")
reopenData
