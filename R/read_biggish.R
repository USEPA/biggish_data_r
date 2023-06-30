library(data.table)
library(arrow)
library(readr)
library(tictoc)

tic.clearlog()
tic("read_csv")
df <- read_csv("data/biggish.csv")
toc(log=TRUE)

tic("read.csv: NA")
#df <- read.csv("data/biggish.csv")
toc(log=TRUE)

tic("fread")
df <- fread("data/biggish.csv")
toc(log=TRUE)

tic("read_csv_arrow")
df <- read_csv_arrow("data/biggish.csv")
toc(log=TRUE)

tic("read_feather")
df <- read_feather("data/biggish.feather")
toc(log = TRUE)

tic("read_parquet")
df <- read_parquet("data/biggish.parquet")
toc(log = TRUE)

tic("open_dataset")
df_ds <- open_dataset("data/biggish")
toc(log = TRUE)

sink("timings.txt", append = TRUE)
writeLines(unlist(tic.log()))
sink()
