# Week 13: Heatmap
# Naming rule: use descriptive snake_case object names.

library(magrittr)

internet_data <- WDI::WDI(
  country = c(
    "JP",
    "KR",
    "CN",
    "TH",
    "VN",
    "MY",
    "ID",
    "PH"
  ),
  indicator = c(
    internet_use = "IT.NET.USER.ZS"
  ),
  start = 2000,
  end = 2024
)

heatmap_data <- internet_data %>%
  tidyr::drop_na(
    internet_use
  )

internet_heatmap <- ggplot2::ggplot(
  heatmap_data,
  ggplot2::aes(
    x = year,
    y = country,
    fill = internet_use
  )
) +
  ggplot2::geom_tile() +
  ggplot2::scale_fill_viridis_c(
    name = "Internet users\n(% of population)"
  ) +
  ggplot2::labs(
    x = "Year",
    y = NULL
  ) +
  ggplot2::theme_classic(base_size = 11)

internet_heatmap
