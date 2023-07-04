library(data.table)
library(arrow)
library(dplyr)
library(readr)
library(tictoc)

tic.clearlog()
df <- read_csv("data/biggish.csv")
tic("in memory df - read_csv")
df_f_sum <- df |>
  group_by(category) |>
  summarize(avg_num1 = mean(num1),
            avg_num2 = mean(num2),
            avg_num3 = mean(num3),
            group_n = n()) |>
  ungroup()
toc(log = TRUE)

df <- fread("data/biggish.csv")
tic("in memory df - data.table")
df_f_sum <- df |>
  group_by(category) |>
  summarize(avg_num1 = mean(num1),
            avg_num2 = mean(num2),
            avg_num3 = mean(num3),
            group_n = n()) |>
  ungroup()
toc(log = TRUE)

df_f <- read_feather("data/biggish.feather", as_data_frame = FALSE)
tic("arrow - feather")
df_f_sum <- df |>
  group_by(category) |>
  summarize(avg_num1 = mean(num1),
            avg_num2 = mean(num2),
            avg_num3 = mean(num3),
            group_n = n()) |>
  ungroup()|>
  collect()
toc(log = TRUE)

#df_csv_ds <- open_csv_dataset("data/biggish.csv")
tic("arrow - csv")
df_f_sum <- df_csv_ds |>
  group_by(category) |>
  summarize(avg_num1 = mean(num1),
            avg_num2 = mean(num2),
            avg_num3 = mean(num3),
            group_n = n()) |>
  ungroup()|>
  collect()
toc(log = TRUE)

#df_p_ds <- open_dataset("data/biggish")
tic("arrow parquet partitioned dataset connection")
df_f_sum <- df_p_ds |>
  group_by(category) |>
  summarize(avg_num1 = mean(num1),
            avg_num2 = mean(num2),
            avg_num3 = mean(num3),
            group_n = n()) |>
  ungroup()|>
  collect()
toc(log = TRUE)

#df_p_ds1 <- open_dataset("data/biggish.parquet")
tic("arrow parquet single dataset connection")
df_f_sum <- df_p_ds1 |>
  group_by(category) |>
  summarize(avg_num1 = mean(num1),
            avg_num2 = mean(num2),
            avg_num3 = mean(num3),
            group_n = n()) |>
  ungroup() |>
  collect()
toc(log = TRUE)

sink("timings.txt", append = TRUE)
writeLines(unlist(tic.log()))
sink()