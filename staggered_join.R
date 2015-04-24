##### Staggered join
### Example from http://stackoverflow.com/questions/29825394/staggered-join-new-grouping-join-in-r-with-data-tables-xy-syntax
require(data.table)

samples <- data.table(name = letters[1:3], 
                      primary = c(17, 0, 18), 
                      secondary = c(55, 42, 42))
resources <- data.table(primary = 17:19, 
                        secondary = c(42, NA, 43), 
                        info = LETTERS[9:11])

samples
resources
# first join:
setkey(samples, primary)
setkey(resources, primary)
### First step
samples[resources[samples, nomatch = 0], info := info]
samples
## or
# samples[resources, nomatch = 0, info := info, by = .EACHI]

### Second step
setkey(samples, secondary)
setkey(resources, secondary)
samples[resources[samples[is.na(info)], nomatch = 0], .SD]

samples[resources[samples[is.na(info)],
                  list(info1 = unique(info)), by = .EACHI],
        info1 := info1]

samples[is.na(info), info := info1]
samples[, info1 := NULL]
setkey(samples, name)
samples

rm(list = ls())

##### solution by eddi (updated by nachti)
samples <- data.table(name = letters[1:3], 
                      primary = c(17, 0, 18), 
                      secondary = c(55, 42, 42))
resources <- data.table(primary = 17:19, 
                        secondary = c(42, NA, 43), 
                        info = LETTERS[9:11])
samples
resources

### First step
setkey(samples, primary)
setkey(resources, primary)
samples[resources, info := i.info]
samples

### Second step (with performance test)
setkey(samples, secondary)
setkey(resources, secondary)
samples
s <- copy(samples)
require(microbenchmark)
microbenchmark(EACHI = samples[resources, info := ifelse(is.na(info), i.info, info),
        by = .EACHI],
               cart = s[resources, info := ifelse(is.na(info), i.info, info),
        allow.cartesian = TRUE] # faster
               )
samples
s
all.equal(samples, s)
