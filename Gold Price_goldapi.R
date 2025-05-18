# Step 1: Install and load necessary libraries
install.packages("httr")
install.packages("jsonlite")
install.packages("ggplot2")
install.packages("knitr")

library(httr)
library(jsonlite)
library(ggplot2)
library(knitr)

# Step 2: Set API credentials and endpoint
api_endpoint <- "https://www.goldapi.io/api/XAU/USD"
access_token <- "goldapi-2gvmslwsyvhq6-io"

# Step 3: Make the GET request to the API
response <- GET(
  url = api_endpoint,
  add_headers(
    "x-access-token" = access_token
  )
)

# Step 4: Check the response status and process the data
if (status_code(response) == 200) {
  # Parse the JSON content
  content <- content(response, as = "text", encoding = "UTF-8")
  data <- fromJSON(content)
  
  # Print the entire data to understand its structure
  print(data)
  
  # Extract the gold price and relevant fields
  if ("price" %in% names(data)) {
    gold_price <- data$price
    timestamp <- data$timestamp
    currency <- data$currency
    
    # Print the extracted information
    print(paste("The current gold price is:", gold_price, "USD"))
    print(paste("Timestamp:", timestamp))
  } else {
    print("Gold price information not found in the response.")
  }
} else {
  # Print an error message
  print(paste("Error: ", status_code(response), content(response, "text")))
}

# Step 5: Create a dataframe with the extracted data and display it as a table
if (exists("gold_price")) {
  gold_data <- data.frame(
    Price = gold_price,
    Timestamp = timestamp,
    Currency = currency
  )
  
  # Display the dataframe as a table
  print(kable(gold_data, caption = "Gold Price Data"))
}

# Step 6: Visualize the data
# Since we only have one data point, let's assume you have historical data for visualization
# For demonstration, let's create a sample historical dataset
set.seed(123)
historical_data <- data.frame(
  Timestamp = seq(as.POSIXct("2023-05-01"), by = "day", length.out = 30),
  Price = cumsum(runif(30, min = -10, max = 10)) + 1800  # Simulating price changes
)

# Plot the historical gold prices
ggplot(historical_data, aes(x = Timestamp, y = Price)) +
  geom_line(color = "gold", size = 1) +
  geom_point(color = "red", size = 2) +
  labs(title = "Historical Gold Prices",
       x = "Date",
       y = "Price (USD)") +
  theme_minimal()
