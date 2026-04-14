# ==============================================================================
# ISTM 650 Assignment 6 – Association Rule Mining
# Name: Chase Capron
# ==============================================================================

# Install required packages if you haven't already
# install.packages("arules")
# install.packages("arulesViz")
# install.packages("visNetwork")
# install.packages("igraph")
# install.packages("dplyr")

# Load the necessary libraries
library(arules)
library(arulesViz)
library(visNetwork)
library(igraph)
library(dplyr) # Included for the pipe operator (%>%)

# ------------------------------------------------------------------------------
# Data Loading and Preparation
# ------------------------------------------------------------------------------
# Load the data and treat '?' as missing values (NA) per instructions
data <- read.csv("voting.csv", stringsAsFactors = TRUE, na.strings = "?")

# Convert the data frame to transaction type
data_trans <- as(data, "transactions")

# ------------------------------------------------------------------------------
# Question 1: Top 5 frequent association rules sorted by Support
# ------------------------------------------------------------------------------
# Generate association rules
all_rules <- apriori(data_trans, parameter = list(supp = 0.1, conf = 0.8))

# Sort by Support and get the top 5
rules_q1_sorted <- sort(all_rules, by = "support", decreasing = TRUE)
top5_rules <- head(rules_q1_sorted, 5)

print("--- Top 5 Rules by Support (Question 1) ---")
inspect(top5_rules)

# Illustrate the discovered rules using a two-key plot (mimicking Lab 8)
# Plotting only the top 5 rules to prevent overcrowding
plot(top5_rules, shading="lift", control=list(main = "Two-key plot of Discovered Rules"))


# ------------------------------------------------------------------------------
# Question 2: Two most frequent rules sorted by Confidence for each party
# ------------------------------------------------------------------------------
# Republican Rules: Set RHS to Party = Republican
rep_rules <- apriori(data_trans, 
                     parameter = list(supp = 0.1, conf = 0.8),
                     appearance = list(default = "lhs", rhs = "party=republican"))

# Sort Republican rules by confidence and take top 2
rep_rules_sorted <- sort(rep_rules, by = "confidence", decreasing = TRUE)
top2_rep <- head(rep_rules_sorted, 2)

# Democrat Rules: Set RHS to Party = Democrat
dem_rules <- apriori(data_trans, 
                     parameter = list(supp = 0.1, conf = 0.8),
                     appearance = list(default = "lhs", rhs = "party=democrat"))

# Sort Democrat rules by confidence and take top 2
dem_rules_sorted <- sort(dem_rules, by = "confidence", decreasing = TRUE)
top2_dem <- head(dem_rules_sorted, 2)

print("--- Top 2 Rules for Republican by Confidence ---")
inspect(top2_rep)
print("--- Top 2 Rules for Democrat by Confidence ---")
inspect(top2_dem)

# Combine rules for subsequent plots
q2_rules <- c(top2_rep, top2_dem)


# ------------------------------------------------------------------------------
# Question 3: Parallel Coordinates Plot for Question 2 Result
# ------------------------------------------------------------------------------
# Generate parallel coordinates plot (mimicking Lab 8)
plot(q2_rules, method = "paracoord", shading = "confidence")


# ------------------------------------------------------------------------------
# Question 4: Association Rules Network for Question 2 Result (visNetwork)
# ------------------------------------------------------------------------------
# Create a basic graph structure using igraph engine (Mimicking Lab 8)
ig <- plot(q2_rules, method = "graph", engine = "igraph")

# Explicitly use igraph::as_data_frame to avoid conflict with dplyr
ig_df <- igraph::as_data_frame(ig, what = "both")

# Generate nodes
nodes <- data.frame(id = ig_df$vertices$name,
                    # The size of nodes: using support here
                    value = ig_df$vertices$support,
                    title = ifelse(ig_df$vertices$label=="", ig_df$vertices$name,
                                   ig_df$vertices$label), ig_df$vertices)

# Generate edges
edges <- ig_df$edges

# Generate network with add-on features matching Lab 8 precisely
network <- visNetwork(nodes, edges) %>%
  visNodes(size = 10) %>%
  visLegend() %>%
  visEdges(smooth = FALSE) %>%
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
  visInteraction(navigationButtons = TRUE)

# View the network map
network
