# Week 15: Review
# Naming rule: use descriptive snake_case object names.

library(magrittr)

# 1. Download data
development_data <- WDI::WDI(
  country = c("JP", "KR", "TH", "VN"),
  indicator = c(
    gdp_pc = "NY.GDP.PCAP.CD",
    life_exp = "SP.DYN.LE00.IN"
  ),
  start = 2000,
  end = 2023
)

# 2. Handle data
plot_data <- development_data %>%
  tidyr::drop_na(
    gdp_pc,
    life_exp
  )

# 3. Plot
gdp_life_exp_plot <- ggplot2::ggplot(
  plot_data,
  ggplot2::aes(
    x = gdp_pc,
    y = life_exp,
    colour = country
  )
) +
  ggplot2::geom_point(alpha = 0.7) +
  ggplot2::scale_x_log10(
    labels = scales::dollar
  ) +
  ggplot2::labs(
    x = "GDP per capita (current US$, log scale)",
    y = "Life expectancy at birth (years)",
    colour = NULL
  ) +
  ggplot2::theme_classic(base_size = 12) +
  ggplot2::theme(
    legend.position = "bottom"
  )

gdp_life_exp_plot

# 4. Save
ggplot2::ggsave(
  "final_figure.png",
  plot = gdp_life_exp_plot,
  width = 7,
  height = 5,
  dpi = 300
)
