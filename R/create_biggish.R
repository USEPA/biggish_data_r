library(data.table)
library(arrow)
library(dplyr)
library(readr)
library(tictoc)
#n <- 100000000
#set.seed(42)
#num2 <- rnorm(n)
#df <- data.frame(category = sample(letters, n, replace = TRUE), 
#                 num1 = rnorm(n),
#                 num2, 
#                 num3 = jitter(num2, 3))

nla17 <- read_csv("https://www.epa.gov/sites/default/files/2021-04/nla_2017_water_chemistry_chla-data.csv")
nla_big <- bind_cols(nla17, nla17)nla_big <- bind_rows(nla_big, nla_big)
for(i in 1:9){
nla_big <- bind_rows(nla_big, nla_big)
}


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

sink("dmap_timings.txt", append = FALSE)
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

sink("dmap_timings.txt", append = TRUE)
writeLines(unlist(tic.log()))
sink()
