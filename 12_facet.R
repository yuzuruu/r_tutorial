# Week 12: Facet
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

faceted_life_exp_plot <- ggplot2::ggplot(
  life_exp_data,
  ggplot2::aes(
    x = year,
    y = life_exp
  )
) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::facet_wrap(
    ~ country
  ) +
  ggplot2::labs(
    x = "Year",
    y = "Life expectancy at birth (years)"
  ) +
  ggplot2::theme_classic(base_size = 11)

faceted_life_exp_plot
