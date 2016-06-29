##### R-Script to test variants of locf
##### Gerhard Nachtmann 20160629

require(data.table)
require(microbenchmark)
require(zoo) # for na.locf

dat <- data.table(id = gl(3, 5),
                  year = c(2000:2004, 2000:2002, 2004:2005,
                           2003:2007),
                  gcd = c("10315", NA, "31644", NA, NA,
                          "60661", NA, "40618", NA, NA,
                          NA, "30718", NA, NA, NA))
## year 2003 is missing for id 2
## first year (2003) is missing for id 3

dat1 <- copy(dat)
dat2 <- copy(dat)

### zoo
dat1[, gcd1 := na.locf(gcd, na.rm = FALSE), by = id]

### rolling join
dat2[!is.na(gcd), ]
setkey(dat2, id, year)
dat2[!is.na(gcd), ][dat2[, .(id, year)], roll = TRUE] # show
dat2[dat2[!is.na(gcd), ][dat2[, .(id, year)], roll = TRUE],
     gcd1 := i.gcd] # assign

dat1[, gcd1 := NULL]
dat2[, gcd1 := NULL]

microbenchmark(zoo = dat1[, gcd1 := na.locf(gcd, na.rm = FALSE),
                          by = id], # faster
               dt = dat2[dat2[!is.na(gcd), ][dat2[, .(id, year)],
                         roll = TRUE], gcd1 := i.gcd]
               )
dat1
dat2
all.equal(dat1, dat2)

### ok use zoo
### impute the missing first year in id 3
dat1[, gcd1 := na.locf(gcd1, fromLast = TRUE), by = id]
dat1
