# Lab 8 - Chase Capron

# Install packages
install.packages("arules")
install.packages("arulesViz", dependencies = TRUE)
install.packages("igraph")
install.packages("visNetwork")
install.packages("plyr")

# Load Packages
library(arules)
library(arulesViz)
library(igraph)
library(visNetwork)
library(plyr)

# Read in csv file groceries.csv.
groceries <- read.csv("groceries.csv")

# Correct data type
groceries$Member_number <- as.character(groceries$Member_number)
groceries$Date <- as.Date(groceries$Date, '%m/%d/%Y')
groceries$itemDescription <- as.character(groceries$itemDescription)

# ddply() is used to get grouping statistics of data.frame
basket <- ddply(groceries, c("Member_number", "Date"),
                function(input) paste(input$itemDescription, collapse = ",") )

# Only keeping itemset variable to get transaction list
txnList <- basket[,c(3)]

# Write into csv file
write.csv(txnList,"itemset.csv", row.names = FALSE)

# Display frequent items
itemSet <- read.transactions("itemset_all.csv", sep = ",")
# 9835 transactions (rows) and
# 169 items (columns)
# Plot the frequent itemsets in term of support
itemFrequencyPlot(itemSet, support = 0.1)
# Find top 20 frequent itemsets
itemFrequencyPlot(itemSet, topN = 20)

# Generate association rules
rules <- apriori(itemSet, parameter = list(sup=0.005, conf=0.5,
                                           target="rules"))

# Find top 10 rules with highest confidence, it also can be support or lift.
rules <- sort(rules, decreasing = TRUE, by = "confidence")
inspect(rules[1:10])
# Sorting grocery rules by lift, show the top five rule
inspect(sort(rules, by = "lift")[1:5])

#{curd,tropical fruit} => {yogurt} 0.0052872 0.5148515 3.690645
#{onions,root vegetables} => {other vegetables} 0.00569395 0.6021505 3.11201

# What are customers likely to buy before purchase whole milk
milkRule_1 <- apriori(itemSet, parameter = list(sup = 0.005, conf = 0.2,
                                                target="rules"), appearance = list(default = 'lhs', rhs = "whole milk"))
milkRule_1 <- sort(milkRule_1, decreasing = TRUE, by = "confidence")
inspect(milkRule_1[1:5])
# What are customers likely to buy if they purchase whole milk
milkRule_2 <- apriori(itemSet, parameter = list(sup = 0.005, conf = 0.2,
                                                target = "rules"), appearance = list(default = 'rhs', lhs = "whole milk"))
milkRule_2 <- sort(milkRule_2, decreasing = TRUE, by = "confidence")
inspect(milkRule_2)

# Use a two-key plot to visualize strong rules’ support, conf. and lift
plot(rules, shading="lift", control=list(main = "Two-key plot"))

# Select top 10 rules in term of confidence
top_rules <- sort(rules, decreasing = TRUE, by = "confidence")[1:10]
plot(top_rules, method = "paracoord", shading = "confidence")

# Create a basic graph structure using igraph engine
ig <- plot(top_rules, method = "graph", engine = "igraph")
ig_df <- as_data_frame(ig, what = "both")

# Generate nodes
nodes <- data.frame(id = ig_df$vertices$name,
                    # The size of nodes: can be lift or confidence
                    value = ig_df$vertices$support,
                    title = ifelse(ig_df$vertices$label=="", ig_df$vertices$name,
                                   ig_df$vertices$label), ig_df$vertices )
# Generate edges
edges <- ig_df$edges
# Generate network with add-on features
network <- visNetwork(nodes, edges) %>%
  # Features to manipulate network
  visOptions(manipulation = TRUE) %>%
  # Directed network
  visEdges(arrows = 'to', scaling = list(min = 2, max = 2)) %>%
  # Navigation buttons
  visInteraction(navigationButtons = TRUE)
network

