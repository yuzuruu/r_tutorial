# Week 9: Grouped bar chart
# Naming rule: use descriptive snake_case object names.

library(magrittr)

life_exp_data <- WDI::WDI(
  country = "all",
  indicator = c(
    life_exp = "SP.DYN.LE00.IN"
  ),
  start = 2000,
  end = 2023,
  extra = TRUE
)

income_life_exp_summary <- life_exp_data %>%
  dplyr::filter(
    region != "Aggregates",
    year %in% c(2000, 2023),
    !is.na(life_exp),
    !is.na(income),
    income != ""
  ) %>%
  dplyr::group_by(
    income,
    year
  ) %>%
  dplyr::summarise(
    mean_life_exp = mean(life_exp),
    .groups = "drop"
  )

income_life_exp_plot <- ggplot2::ggplot(
  income_life_exp_summary,
  ggplot2::aes(
    x = income,
    y = mean_life_exp,
    fill = factor(year)
  )
) +
  ggplot2::geom_col(
    position = "dodge"
  ) +
  ggplot2::labs(
    x = NULL,
    y = "Mean life expectancy (years)",
    fill = "Year"
  ) +
  ggplot2::theme_classic(base_size = 11) +
  ggplot2::theme(
    axis.text.x = ggplot2::element_text(
      angle = 30,
      hjust = 1
    )
  )

income_life_exp_plot
