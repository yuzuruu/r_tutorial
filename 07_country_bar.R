# Week 7: Country bar chart
# Naming rule: use descriptive snake_case object names.

library(magrittr)

country_gdp_data <- WDI::WDI(
  country = c("JP", "KR", "TH", "VN"),
  indicator = c(
    gdp_pc = "NY.GDP.PCAP.CD"
  ),
  start = 2023,
  end = 2023
)

country_gdp_bar_plot <- ggplot2::ggplot(
  country_gdp_data,
  ggplot2::aes(
    x = country,
    y = gdp_pc
  )
) +
  ggplot2::geom_col() +
  ggplot2::scale_y_continuous(
    labels = scales::dollar
  ) +
  ggplot2::labs(
    x = NULL,
    y = "GDP per capita (current US$)"
  ) +
  ggplot2::theme_classic(base_size = 12)

country_gdp_bar_plot
