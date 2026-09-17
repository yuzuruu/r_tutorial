# Week 10: Scatter plot
# Naming rule: use descriptive snake_case object names.

library(magrittr)

development_data <- WDI::WDI(
  country = "all",
  indicator = c(
    gdp_pc = "NY.GDP.PCAP.CD",
    life_exp = "SP.DYN.LE00.IN",
    population = "SP.POP.TOTL"
  ),
  start = 2023,
  end = 2023,
  extra = TRUE
)

scatter_data <- development_data %>%
  dplyr::filter(
    region != "Aggregates"
  ) %>%
  tidyr::drop_na(
    gdp_pc,
    life_exp,
    population
  )

# Basic scatter plot
gdp_life_exp_scatter_plot <- ggplot2::ggplot(
  scatter_data,
  ggplot2::aes(
    x = gdp_pc,
    y = life_exp
  )
) +
  ggplot2::geom_point(alpha = 0.6) +
  ggplot2::scale_x_log10(
    labels = scales::dollar
  ) +
  ggplot2::labs(
    x = "GDP per capita (current US$, log scale)",
    y = "Life expectancy at birth (years)"
  ) +
  ggplot2::theme_classic(base_size = 12)

gdp_life_exp_scatter_plot

# Add population as point size
population_scatter_plot <- ggplot2::ggplot(
  scatter_data,
  ggplot2::aes(
    x = gdp_pc,
    y = life_exp,
    size = population
  )
) +
  ggplot2::geom_point(alpha = 0.5) +
  ggplot2::scale_x_log10(
    labels = scales::dollar
  ) +
  ggplot2::scale_size_continuous(
    labels = scales::label_number(
      scale = 1e-6
    ),
    name = "Population\n(millions)"
  ) +
  ggplot2::labs(
    x = "GDP per capita (current US$, log scale)",
    y = "Life expectancy at birth (years)"
  ) +
  ggplot2::theme_classic(base_size = 12)

population_scatter_plot
