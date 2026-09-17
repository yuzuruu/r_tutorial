# Week 1: Introduction to R and WDI
# Naming rule: use descriptive snake_case object names.

# %>% is provided by magrittr.
library(tidyverse)
library(WDI)

# Search for a WDI indicator
WDI::WDIsearch("GDP per capita")

# Download GDP per capita for Japan
japan_gdp_data <- 
  WDI::WDI(
    country = "JP",
    indicator = "NY.GDP.PCAP.CD",
    start = 2000,
    end = 2024
    )

# Inspect the data
utils::head(japan_gdp_data)
utils::View(japan_gdp_data)
base::names(japan_gdp_data)
base::nrow(japan_gdp_data)

# First graph

japan_gdp_plot <- 
  japan_gdp_data %>% 
  ggplot2::ggplot(
    aes(
      x = year,
      y = NY.GDP.PCAP.CD
      )
    ) +
  geom_line()
