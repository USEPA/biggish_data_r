library(data.table)
library(arrow)
library(readr)
library(tictoc)
n <- 100000000
set.seed(42)
num2 <- rnorm(n)
df <- data.frame(category = sample(letters, n, replace = TRUE), 
                 num1 = rnorm(n),
                 num2, 
                 num3 = jitter(num2, 3))

tic.clearlog()
tic("write_csv")
write_csv(df, "data/biggish.csv")
toc(log=TRUE)
fs::file_delete("data/biggish.csv")
tic("write.csv")
write.csv(df, "data/biggish.csv")
toc(log=TRUE)
fs::file_delete("data/biggish.csv")
tic("fwrite")
fwrite(df, "data/biggish.csv")
toc(log=TRUE)
fs::file_delete("data/biggish.csv")
tic("write_csv_arrow")
write_csv_arrow(df, file = "data/biggish.csv")
toc(log=TRUE)

sink("timings.txt", append = FALSE)
writeLines(c("functions: time_elapsed"))
writeLines(unlist(tic.log()))
sink()

tic.clearlog()
tic("write_feather")
write_feather(df, "data/biggish.feather", compression = "zstd")
toc(log = TRUE)
tic("write_parquest")
write_parquet(df, "data/biggish.parquet", compression = "zstd")
toc(log = TRUE)
tic("write_dataset")
write_dataset(df,
              path = "data/biggish",
              max_rows_per_file = 1500000)
toc(log = TRUE)

sink("timings.txt", append = TRUE)
writeLines(unlist(tic.log()))
sink()
