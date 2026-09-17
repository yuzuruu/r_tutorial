# Week 4: Single-country line graph
# Naming rule: use descriptive snake_case object names.

library(magrittr)

japan_life_exp_data <- WDI::WDI(
  country = "JP",
  indicator = c(
    life_exp = "SP.DYN.LE00.IN"
  ),
  start = 2000,
  end = 2024
)

# Basic graph
ggplot2::ggplot(
  japan_life_exp_data,
  ggplot2::aes(
    x = year,
    y = life_exp
  )
) +
  ggplot2::geom_line()

# Publication-style graph
japan_life_exp_plot <- ggplot2::ggplot(
  japan_life_exp_data,
  ggplot2::aes(
    x = year,
    y = life_exp
  )
) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::labs(
    x = "Year",
    y = "Life expectancy at birth (years)"
  ) +
  ggplot2::theme_classic(base_size = 12)

japan_life_exp_plot

ggplot2::ggsave(
  "fig01_japan_life_expectancy.png",
  plot = japan_life_exp_plot,
  width = 7,
  height = 5,
  dpi = 300
)
