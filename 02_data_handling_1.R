# Week 2: Data handling 1/2
# Naming rule: use descriptive snake_case object names.

library(tidyverse)
library(WDI)

indicator_codes <- c(
  gdp_pc = "NY.GDP.PCAP.CD",
  life_exp = "SP.DYN.LE00.IN",
  population = "SP.POP.TOTL"
)

wdi_raw <- WDI::WDI(
  country = "all",
  indicator = indicator_codes,
  start = 2000,
  end = 2024,
  extra = TRUE
)

wdi_data <- wdi_raw %>%
  dplyr::select(
    country,
    iso3c,
    year,
    gdp_pc,
    life_exp,
    population,
    region,
    income
  )

# Select one country
wdi_data %>%
  dplyr::filter(country == "Japan")

# Select several countries
wdi_data %>%
  dplyr::filter(
    country %in% c(
      "Japan",
      "Korea, Rep.",
      "Thailand",
      "Vietnam"
    )
  )

# Select years
wdi_data %>%
  dplyr::filter(year >= 2010)

# Sort observations
wdi_data %>%
  dplyr::filter(year == 2023) %>%
  dplyr::arrange(dplyr::desc(gdp_pc))
