# Week 8: Horizontal ranking
# Naming rule: use descriptive snake_case object names.

library(magrittr)

gdp_pc_data <- WDI::WDI(
  country = "all",
  indicator = c(
    gdp_pc = "NY.GDP.PCAP.CD"
  ),
  start = 2023,
  end = 2023,
  extra = TRUE
)

east_asia_ranking <- gdp_pc_data %>%
  dplyr::filter(
    region == "East Asia & Pacific",
    !is.na(gdp_pc)
  ) %>%
  dplyr::arrange(
    dplyr::desc(gdp_pc)
  ) %>%
  dplyr::slice_head(n = 15)

east_asia_ranking_plot <- ggplot2::ggplot(
  east_asia_ranking,
  ggplot2::aes(
    x = stats::reorder(country, gdp_pc),
    y = gdp_pc
  )
) +
  ggplot2::geom_col() +
  ggplot2::coord_flip() +
  ggplot2::scale_y_continuous(
    labels = scales::dollar
  ) +
  ggplot2::labs(
    x = NULL,
    y = "GDP per capita (current US$)"
  ) +
  ggplot2::theme_classic(base_size = 11)

east_asia_ranking_plot
