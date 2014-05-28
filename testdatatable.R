#! /usr/bin/Rscript
##### R-Script to run data.table tests
##### Gerhard Nachtmann 20140527,28
require(data.table)
sessionInfo()
writeLines(paste("Endianess:", .Platform$endian))
test.data.table()
