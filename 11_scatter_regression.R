# Week 11: Scatter plot + regression line
# Naming rule: use descriptive snake_case object names.

library(magrittr)

development_data <- WDI::WDI(
  country = "all",
  indicator = c(
    gdp_pc = "NY.GDP.PCAP.CD",
    life_exp = "SP.DYN.LE00.IN"
  ),
  start = 2023,
  end = 2023,
  extra = TRUE
)

regression_data <- development_data %>%
  dplyr::filter(
    region != "Aggregates"
  ) %>%
  tidyr::drop_na(
    gdp_pc,
    life_exp
  )

regression_plot <- ggplot2::ggplot(
  regression_data,
  ggplot2::aes(
    x = gdp_pc,
    y = life_exp
  )
) +
  ggplot2::geom_point(alpha = 0.5) +
  ggplot2::geom_smooth(
    method = "lm",
    se = TRUE
  ) +
  ggplot2::scale_x_log10(
    labels = scales::dollar
  ) +
  ggplot2::labs(
    x = "GDP per capita (current US$, log scale)",
    y = "Life expectancy at birth (years)"
  ) +
  ggplot2::theme_classic(base_size = 12)

regression_plot

# Optional: inspect the regression model
life_exp_model <- stats::lm(
  life_exp ~ log(gdp_pc),
  data = regression_data
)

base::summary(life_exp_model)
