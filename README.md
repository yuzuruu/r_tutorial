# Rコード解説

この授業では、World Bank の **World Development Indicators (WDI)** を R から取得し、データを整形して、学術論文に使用できるグラフを作成します。

授業では、できるだけ少ない関数を繰り返し使います。すべてのコードを暗記する必要はありません。重要なのは、

> **データ取得 → データ整形 → 作図 → 保存**

という流れを理解することです。

---

## 1. 使用するパッケージ

この授業では、主に次のパッケージを使用します。

```r
install.packages(
  c(
    "WDI",
    "magrittr",
    "dplyr",
    "tidyr",
    "ggplot2",
    "scales"
  )
)
```

パッケージの役割は以下のとおりです。

| Package | Purpose |
|---|---|
| `WDI` | World Bank WDI からデータを取得する |
| `magrittr` | `%>%` を使用する |
| `dplyr` | データを選択・抽出・並べ替え・集計する |
| `tidyr` | 欠損値処理やデータ形式変換を行う |
| `ggplot2` | グラフを作成する |
| `scales` | 軸ラベルの表示形式を整える |

この授業では、パイプ `%>%` を使うために次を実行します。

```r
library(magrittr)
```

それ以外の関数については、原則として名前空間を明示します。

```r
WDI::WDI()
dplyr::filter()
tidyr::drop_na()
ggplot2::ggplot()
scales::dollar
```

この書き方にすると、どのパッケージの関数を使っているかが明確になります。

---

## 2. オブジェクト名の規則

この授業では、オブジェクト名に **snake_case** を使用します。

```r
wdi_data
life_exp_data
income_summary
gdp_life_exp_plot
```

避けたい例：

```r
df
dat
tmp
x
p
```

オブジェクト名から中身が分かるようにします。

### 推奨する接尾辞

| Suffix | Meaning |
|---|---|
| `_data` | データ |
| `_summary` | 集計結果 |
| `_plot` | ggplot オブジェクト |
| `_model` | 統計モデル |
| `_colors` | 色指定 |

例：

```r
development_data
regional_summary
life_exp_plot
life_exp_model
okabe_ito_colors
```

---

## 3. `%>%` の読み方

この授業では、処理を上から順番に読むために `%>%` を使用します。

```r
wdi_data %>%
  dplyr::filter(year >= 2010) %>%
  dplyr::select(country, year, life_exp)
```

これは、

> `wdi_data` を使って、  
> 2010年以降を抽出し、  
> 必要な列だけを残す

という意味です。

複雑なコードを一行で書くより、処理を一段ずつ書く方が読みやすくなります。

---

# 4. WDIからデータを取得する

## 4.1 指標を検索する

WDI 指標名が分からない場合は、`WDI::WDIsearch()` を使います。

```r
WDI::WDIsearch("GDP per capita")
```

```r
WDI::WDIsearch("life expectancy")
```

---

## 4.2 一つの国のデータを取得する

例：日本の一人当たりGDP

```r
japan_gdp_data <- WDI::WDI(
  country = "JP",
  indicator = c(
    gdp_pc = "NY.GDP.PCAP.CD"
  ),
  start = 2000,
  end = 2022
)
```

ここでは、

```r
gdp_pc = "NY.GDP.PCAP.CD"
```

と書くことで、長い WDI 指標コードに `gdp_pc` という短い変数名を与えています。

---

## 4.3 複数国を取得する

```r
life_exp_data <- WDI::WDI(
  country = c(
    "JP",
    "KR",
    "TH",
    "VN"
  ),
  indicator = c(
    life_exp = "SP.DYN.LE00.IN"
  ),
  start = 2000,
  end = 2022
)
```

代表的な国コード：

| Country | Code |
|---|---|
| Japan | `JP` |
| Korea, Rep. | `KR` |
| China | `CN` |
| Thailand | `TH` |
| Vietnam | `VN` |
| Malaysia | `MY` |
| Indonesia | `ID` |
| Philippines | `PH` |

---

## 4.4 全世界の国を取得する

```r
wdi_data <- WDI::WDI(
  country = "all",
  indicator = c(
    life_exp = "SP.DYN.LE00.IN"
  ),
  start = 2022,
  end = 2022,
  extra = TRUE
)
```

`extra = TRUE` を指定すると、次のような追加情報を利用できます。

```r
region
income
```

これらは地域別・所得グループ別の分析に便利です。

---

# 5. データを確認する

取得後は、すぐに作図せず、まずデータを確認します。

```r
utils::head(wdi_data)
```

```r
utils::View(wdi_data)
```

```r
base::names(wdi_data)
```

```r
base::nrow(wdi_data)
```

確認するポイント：

- 国は正しいか
- 年は正しいか
- 指標は正しいか
- 欠損値はないか
- 集計行が含まれていないか

---

# 6. 列を選ぶ：`select()`

必要な変数だけを残します。

```r
wdi_data <- wdi_raw %>%
  dplyr::select(
    country,
    year,
    gdp_pc,
    life_exp
  )
```

`select()` は、

> **どの変数を使うか**

を指定する関数です。

---

# 7. 行を抽出する：`filter()`

## 7.1 年を抽出する

```r
wdi_data %>%
  dplyr::filter(
    year >= 2010
  )
```

## 7.2 一つの国を抽出する

```r
wdi_data %>%
  dplyr::filter(
    country == "Japan"
  )
```

## 7.3 複数国を抽出する

```r
wdi_data %>%
  dplyr::filter(
    country %in% c(
      "Japan",
      "Korea, Rep.",
      "Thailand",
      "Vietnam"
    )
  )
```

`filter()` は、

> **どの観測値を使うか**

を指定します。

---

# 8. 並べ替える：`arrange()`

昇順：

```r
wdi_data %>%
  dplyr::arrange(gdp_pc)
```

降順：

```r
wdi_data %>%
  dplyr::arrange(
    dplyr::desc(gdp_pc)
  )
```

`arrange()` は値そのものを変更しません。  
表示順序だけを変更します。

---

# 9. 新しい変数を作る：`mutate()`

人口を「人」から「百万人」に変換する例：

```r
population_data <- population_data %>%
  dplyr::mutate(
    population_million = population / 1e6
  )
```

一人当たりGDPを千ドル単位にする例：

```r
gdp_data <- gdp_data %>%
  dplyr::mutate(
    gdp_pc_thousand = gdp_pc / 1000
  )
```

`mutate()` は、

> **既存の変数から新しい変数を作る**

ために使用します。

---

# 10. 欠損値を扱う：`drop_na()`

```r
complete_data <- wdi_data %>%
  tidyr::drop_na(
    gdp_pc,
    life_exp
  )
```

ここでは、`gdp_pc` または `life_exp` が欠損している行を除外します。

注意：

> 欠損値はゼロではありません。

欠損値を除外する場合は、その理由を理解した上で行います。

---

# 11. グループ別に集計する

## 11.1 `group_by()`

```r
wdi_data %>%
  dplyr::group_by(region)
```

## 11.2 `summarise()`

地域別平均寿命：

```r
regional_summary <- wdi_data %>%
  dplyr::group_by(region) %>%
  dplyr::summarise(
    mean_life_exp = mean(
      life_exp,
      na.rm = TRUE
    ),
    .groups = "drop"
  )
```

基本形は、

```r
data %>%
  dplyr::group_by(group_variable) %>%
  dplyr::summarise(
    new_variable = summary_function(variable)
  )
```

です。

---

# 12. Wide形式からLong形式へ変換する

```r
wdi_long <- wdi_data %>%
  tidyr::pivot_longer(
    cols = c(
      gdp_pc,
      life_exp
    ),
    names_to = "indicator",
    values_to = "value"
  )
```

Long形式は、複数の指標を同じ構造で扱いたい場合に便利です。

ただし、必要がない場合に無理に変換する必要はありません。

---

# 13. `ggplot2` の基本構造

もっとも基本的な形は次です。

```r
ggplot2::ggplot(
  data,
  ggplot2::aes(
    x = x_variable,
    y = y_variable
  )
) +
  ggplot2::geom_...() +
  ggplot2::labs(...) +
  ggplot2::theme_classic()
```

役割：

1. `ggplot()`：使用するデータ
2. `aes()`：変数と視覚表現との対応
3. `geom_*()`：グラフの種類
4. `labs()`：軸・凡例ラベル
5. `theme_*()`：見た目

---

# 14. 単一国折れ線グラフ

```r
ggplot2::ggplot(
  japan_life_exp_data,
  ggplot2::aes(
    x = year,
    y = life_exp
  )
) +
  ggplot2::geom_line(
    linewidth = 0.8
  ) +
  ggplot2::labs(
    x = "Year",
    y = "Life expectancy at birth (years)"
  ) +
  ggplot2::theme_classic(
    base_size = 12
  )
```

折れ線グラフは、時間変化を表現するのに適しています。

---

# 15. 複数国折れ線グラフ

```r
ggplot2::ggplot(
  life_exp_data,
  ggplot2::aes(
    x = year,
    y = life_exp,
    colour = country,
    linetype = country
  )
) +
  ggplot2::geom_line(
    linewidth = 0.9
  ) +
  ggplot2::labs(
    x = "Year",
    y = "Life expectancy at birth (years)",
    colour = NULL,
    linetype = NULL
  ) +
  ggplot2::theme_classic(
    base_size = 12
  )
```

この授業では、色だけに依存しないように、

```r
colour = country
linetype = country
```

を併用することがあります。

---

# 16. Okabe–Ito型の色指定

授業では、色覚多様性を考慮した配色例として次の色を使用します。

```r
okabe_ito_colors <- c(
  "#0072B2",
  "#E69F00",
  "#009E73",
  "#CC79A7"
)
```

使用例：

```r
ggplot2::scale_colour_manual(
  values = okabe_ito_colors
)
```

重要なのは、

> 色だけを唯一の識別手段にしない

ことです。

---

# 17. 指数化した折れ線グラフ

国ごとに基準年を100とします。

```r
indexed_gdp_data <- gdp_pc_data %>%
  dplyr::group_by(country) %>%
  dplyr::mutate(
    gdp_pc_index =
      gdp_pc / gdp_pc[year == 2000][1] * 100
  ) %>%
  dplyr::ungroup()
```

考え方：

\[
Index_{it}
=
\frac{x_{it}}{x_{i,base}}
\times 100
\]

基準年は100になります。

作図：

```r
ggplot2::ggplot(
  indexed_gdp_data,
  ggplot2::aes(
    x = year,
    y = gdp_pc_index,
    linetype = country
  )
) +
  ggplot2::geom_hline(
    yintercept = 100,
    linetype = "dashed"
  ) +
  ggplot2::geom_line()
```

指数化すると、国ごとの水準差ではなく、**相対的な変化**を比較できます。

---

# 18. 棒グラフ

```r
ggplot2::ggplot(
  country_gdp_data,
  ggplot2::aes(
    x = country,
    y = gdp_pc
  )
) +
  ggplot2::geom_col()
```

WDIのように、すでに値がデータとして存在する場合は、

```r
ggplot2::geom_col()
```

を使用します。

---

# 19. 横棒ランキング

```r
ggplot2::ggplot(
  ranking_data,
  ggplot2::aes(
    x = stats::reorder(
      country,
      gdp_pc
    ),
    y = gdp_pc
  )
) +
  ggplot2::geom_col() +
  ggplot2::coord_flip()
```

ここでは、

```r
stats::reorder()
```

で表示順を変更し、

```r
ggplot2::coord_flip()
```

で横棒グラフにしています。

---

# 20. グループ別棒グラフ

```r
ggplot2::ggplot(
  income_summary,
  ggplot2::aes(
    x = income,
    y = mean_life_exp,
    fill = factor(year)
  )
) +
  ggplot2::geom_col(
    position = "dodge"
  )
```

```r
position = "dodge"
```

を使うと、複数年の棒を横に並べて比較できます。

---

# 21. 散布図

```r
ggplot2::ggplot(
  scatter_data,
  ggplot2::aes(
    x = gdp_pc,
    y = life_exp
  )
) +
  ggplot2::geom_point(
    alpha = 0.6
  )
```

散布図は、二つの数値変数の関係を見るために使用します。

---

# 22. 対数軸

一人当たりGDPのように値の範囲が非常に広い場合には、対数軸が有効です。

```r
ggplot2::scale_x_log10()
```

例：

```r
ggplot2::scale_x_log10(
  labels = scales::dollar
)
```

対数軸を使用しても、元のデータ自体が書き換えられるわけではありません。

---

# 23. 点の大きさに第三の変数を使う

```r
ggplot2::aes(
  x = gdp_pc,
  y = life_exp,
  size = population
)
```

これにより、

- x軸：一人当たりGDP
- y軸：平均寿命
- 点の大きさ：人口

という3変数を一つのグラフで表現できます。

ただし、情報を増やしすぎると読みにくくなるため、必要な場合だけ使用します。

---

# 24. 散布図に回帰直線を加える

```r
ggplot2::geom_smooth(
  method = "lm",
  se = TRUE
)
```

完全な例：

```r
ggplot2::ggplot(
  regression_data,
  ggplot2::aes(
    x = gdp_pc,
    y = life_exp
  )
) +
  ggplot2::geom_point(
    alpha = 0.5
  ) +
  ggplot2::geom_smooth(
    method = "lm",
    se = TRUE
  )
```

重要：

> 回帰直線は因果関係を証明しません。

ここでは変数間の関連を視覚的に示しています。

---

# 25. Facet

```r
ggplot2::facet_wrap(
  ~ country
)
```

例：

```r
ggplot2::ggplot(
  life_exp_data,
  ggplot2::aes(
    x = year,
    y = life_exp
  )
) +
  ggplot2::geom_line() +
  ggplot2::facet_wrap(
    ~ country
  )
```

Facetを使うと、国ごとに別パネルを作成できます。

複数の線を同じグラフに入れると読みにくい場合に便利です。

---

# 26. ヒートマップ

```r
ggplot2::ggplot(
  heatmap_data,
  ggplot2::aes(
    x = year,
    y = country,
    fill = internet_use
  )
) +
  ggplot2::geom_tile()
```

連続値の色には、

```r
ggplot2::scale_fill_viridis_c()
```

を使用します。

```r
ggplot2::scale_fill_viridis_c(
  name = "Internet users\n(% of population)"
)
```

---

# 27. 軸ラベル

悪い例：

```r
ggplot2::labs(
  y = "GDP"
)
```

よりよい例：

```r
ggplot2::labs(
  y = "GDP per capita (current US$)"
)
```

ラベルには可能な限り、

- 変数名
- 単位

を含めます。

---

# 28. 軸の表示形式

ドル表示：

```r
ggplot2::scale_y_continuous(
  labels = scales::dollar
)
```

人口を百万人単位で表示：

```r
ggplot2::scale_size_continuous(
  labels = scales::label_number(
    scale = 1e-6
  )
)
```

---

# 29. グラフを保存する

```r
ggplot2::ggsave(
  "figure.png",
  plot = life_exp_plot,
  width = 7,
  height = 5,
  dpi = 300
)
```

この授業では、

```r
dpi = 300
```

を基本とします。

グラフは画面キャプチャではなく、Rコードから保存します。

---

# 30. 再現可能性

提出コードは、Rを新しく起動した状態から、

```r
source("your_script.R")
```

または RStudio の **Source** を実行して、最初から最後まで動くことを目標とします。

つまり、コードだけで、

1. データ取得
2. データ整形
3. 作図
4. 保存

を再現できる必要があります。

手作業でExcel等を修正した場合、その処理はRコードから再現できません。

---

# 31. この授業でよく使う関数

## WDI

```r
WDI::WDI()
WDI::WDIsearch()
```

## dplyr

```r
dplyr::select()
dplyr::filter()
dplyr::arrange()
dplyr::mutate()
dplyr::group_by()
dplyr::summarise()
dplyr::ungroup()
dplyr::slice_head()
```

## tidyr

```r
tidyr::drop_na()
tidyr::pivot_longer()
```

## ggplot2

```r
ggplot2::ggplot()
ggplot2::aes()
ggplot2::geom_line()
ggplot2::geom_col()
ggplot2::geom_point()
ggplot2::geom_smooth()
ggplot2::geom_tile()
ggplot2::facet_wrap()
ggplot2::labs()
ggplot2::theme_classic()
ggplot2::ggsave()
```

---

# 32. Graph type selection

| Question | Suitable graph |
|---|---|
| 時間変化を見たい | Line graph |
| 複数国の時間変化を比較したい | Multiple-country line graph |
| 相対的な変化を比較したい | Indexed line graph |
| 一時点で国を比較したい | Bar chart |
| 順位を示したい | Horizontal ranking |
| グループと年を比較したい | Grouped bar chart |
| 二つの数値変数の関係を見たい | Scatter plot |
| 散布図に傾向線を加えたい | Scatter plot + regression line |
| 国ごとに分けて見たい | Facet |
| 国×年の値を色で見たい | Heatmap |

---

# 33. 最後に

この授業で最も重要なのは、長いコードを書くことではありません。

重要なのは、

```text
Question
  ↓
WDI indicator
  ↓
Download
  ↓
Data handling
  ↓
Graph
  ↓
Save
```

という一連の手順を、自分で再現できることです。

良いグラフは、単に見栄えがよいグラフではありません。

- 情報が正しい
- 読みやすい
- 単位が明確である
- 色に配慮している
- Rコードから再現できる

という条件を満たす必要があります。
