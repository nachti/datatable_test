##### R-Script to test fread with headers with special characters
##### and unusual nested quotes
##### Gerhard Nachtmann 20160427

library(data.table)
dat <- fread("latin1quotedat.csv", encoding = "Latin-1")
dat # wrong header, wrong quotes

dat1 <- read.csv2("latin1quotedat.csv", encoding = "latin1")
dat1 # ok
