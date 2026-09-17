# Week 6: Indexed line graph
# Naming rule: use descriptive snake_case object names.

library(magrittr)

gdp_pc_data <- WDI::WDI(
  country = c("JP", "KR", "TH", "VN"),
  indicator = c(
    gdp_pc = "NY.GDP.PCAP.CD"
  ),
  start = 2000,
  end = 2024
)

indexed_gdp_data <- gdp_pc_data %>%
  dplyr::filter(
    !is.na(gdp_pc)
  ) %>%
  dplyr::group_by(country) %>%
  dplyr::arrange(
    year,
    .by_group = TRUE
  ) %>%
  dplyr::mutate(
    gdp_pc_index = gdp_pc / gdp_pc[year == 2000][1] * 100
  ) %>%
  dplyr::ungroup()

okabe_ito_colors <- c(
  "#0072B2",
  "#E69F00",
  "#009E73",
  "#CC79A7"
)

indexed_gdp_plot <- ggplot2::ggplot(
  indexed_gdp_data,
  ggplot2::aes(
    x = year,
    y = gdp_pc_index,
    colour = country
  )
) +
  ggplot2::geom_hline(
    yintercept = 100,
    linetype = "dashed"
  ) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::scale_colour_manual(
    values = okabe_ito_colors
  ) +
  ggplot2::labs(
    x = "Year",
    y = "GDP per capita index (2000 = 100)",
    colour = NULL
  ) +
  ggplot2::theme_classic(base_size = 12) +
  ggplot2::theme(
    legend.position = "bottom"
  )

indexed_gdp_plot
