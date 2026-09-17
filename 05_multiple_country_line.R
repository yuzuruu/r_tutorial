# Week 5: Multiple-country line graph
# Naming rule: use descriptive snake_case object names.

library(magrittr)

life_exp_data <- WDI::WDI(
  country = c("JP", "KR", "TH", "VN"),
  indicator = c(
    life_exp = "SP.DYN.LE00.IN"
  ),
  start = 2000,
  end = 2024
)

okabe_ito_colors <- c(
  "#0072B2",
  "#E69F00",
  "#009E73",
  "#CC79A7"
)

multi_country_life_exp_plot <- ggplot2::ggplot(
  life_exp_data,
  ggplot2::aes(
    x = year,
    y = life_exp,
    colour = country
  )
) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::scale_colour_manual(
    values = okabe_ito_colors
  ) +
  ggplot2::labs(
    x = "Year",
    y = "Life expectancy at birth (years)",
    colour = NULL
  ) +
  ggplot2::theme_classic(base_size = 12) +
  ggplot2::theme(
    legend.position = "bottom"
  )

multi_country_life_exp_plot
