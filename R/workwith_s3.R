library(arrow)
library(dplyr)
library(tictoc)

tic.clearlog()
bucket <- s3_bucket("voltrondata-labs-datasets", anonymous = TRUE, region = 'us-east-2') #bucket region
nyc_taxi <- open_dataset(bucket$path("nyc-taxi"))

tic("nyc taxi on S3 from dmap: nrow")
nrow(nyc_taxi)
toc(log = TRUE)

tic("nyc taxi on S3 from dmap: n per year")
years <- nyc_taxi |>
  group_by(year) |>
  summarize(n = n()) |>
  collect()
years
toc(log = TRUE)

sink("dmap_timings.txt", append = TRUE)
writeLines(unlist(tic.log()))
sink()



