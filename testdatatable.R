#! /usr/bin/Rscript
##### R-Script to run data.table tests
##### Gerhard Nachtmann 20140527,28, 1013

### install the newest version of data.table from GitHub
## library(devtools)
## install_github("Rdatatable/data.table")

### if GenomicRanges is not installed uncomment the following
### lines
## source("http://bioconductor.org/biocLite.R")
## biocLite("GenomicRanges")
###
library(data.table)
library(reshape)
sessionInfo()
writeLines(paste("Endianess:", .Platform$endian))
test.data.table()
