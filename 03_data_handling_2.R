# Week 3: Data handling 2/2
# Naming rule: use descriptive snake_case object names.

library(magrittr)

indicator_codes <- c(
  gdp_pc = "NY.GDP.PCAP.CD",
  life_exp = "SP.DYN.LE00.IN",
  population = "SP.POP.TOTL"
)

wdi_data <- WDI::WDI(
  country = "all",
  indicator = indicator_codes,
  start = 2000,
  end = 2024,
  extra = TRUE
) %>%
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

# Create new variables
wdi_data <- wdi_data %>%
  dplyr::mutate(
    population_million = population / 1e6,
    gdp_pc_thousand = gdp_pc / 1000
  )

# Check missing values
missing_summary <- wdi_data %>%
  dplyr::summarise(
    missing_gdp = sum(is.na(gdp_pc)),
    missing_life_exp = sum(is.na(life_exp))
  )

missing_summary

# Remove missing values
complete_wdi_data <- wdi_data %>%
  tidyr::drop_na(
    gdp_pc,
    life_exp
  )

# Calculate regional means
regional_life_exp_summary <- wdi_data %>%
  dplyr::filter(year == 2023) %>%
  dplyr::group_by(region) %>%
  dplyr::summarise(
    mean_life_exp = mean(life_exp, na.rm = TRUE),
    .groups = "drop"
  )

regional_life_exp_summary

# Convert wide data to long data
wdi_long <- wdi_data %>%
  dplyr::select(
    country,
    year,
    gdp_pc,
    life_exp
  ) %>%
  tidyr::pivot_longer(
    cols = c(gdp_pc, life_exp),
    names_to = "indicator",
    values_to = "value"
  )

wdi_long
