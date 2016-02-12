##### R-Script to speedup leading / lagging
##### Gerhard Nachtmann 20150723, 20160203
##### 20160211-12
library(dplyr)
library(data.table)
library(microbenchmark)

### from http://stackoverflow.com/questions/26291988/r-how-to-create-a-lag-variable-for-each-by-group
set.seed(1)
data <- data.table(time =c(1:3, 1:4),
                   groups = c(rep(c("b", "a"), c(3, 4))),
                   value = rnorm(7))
data
d1 <- tbl_df(data)
d2 <- tbl_dt(data)
d3 <- copy(d2)
### see also shift() in dt1.9.6

##### data.table 1.9.4
### lag
data[, lag.value := c(NA, value[-.N]), by = groups]
data

### lead
data[, lead.value := c(value[-1], NA), by = groups]
data

### clean
data[, c("lead.value", "lag.value") := NULL]

##### data.table 1.9.6
### lag
data[, lag.value := shift(value, n = 1, type = "lag"),
     by = groups]
data

### lead
data[, lead.value := shift(value, n = 1, type = "lead"),
     by = groups]
data

### clean
data[, c("lead.value", "lag.value") := NULL]

##### dplyr
d1r <- d1 %>% group_by(groups) %>%
       mutate(lead.value = lead(value, 1))
d1r
rm(d1r)


microbenchmark(ldf = d1r <- d1 %>% group_by(groups) %>%
                            mutate(lead.value = lead(value, 1)),
               ldt = d2r <- d2 %>% group_by(groups) %>%
                            mutate(lead.value = lead(value, 1)),
               dt194 = data[, lead.value := c(value[-1], NA),
                          by = groups],
               dt196 = d3[, lead.value := shift(value, n = 1,
                                           type = "lead"),
                          by = groups]
               )
### dt196 = fastest; interesting: ldt is much slower than ldf
data
d1r
d2r
d3
all.equal(as.data.frame(data), as.data.frame(d1r))
all.equal(as.data.frame(data), as.data.frame(d2r))
all.equal(as.data.frame(data), as.data.frame(d3))

### hmmm -- dt196 is much slower in real life
set.seed(1)
mg <- data.table(expand.grid(year = 2012:2016, id = 1:1000),
                 value = rnorm(5000))
mg
mg1 <- copy(mg)

microbenchmark(dt194 = mg[, l1 := c(value[-1], NA), by = .(id)],
               dt196 = mg1[, l1 := shift(value, n = 1,
                                         type = "lead"),
                                         by = .(id)])
## Unit: milliseconds
##   expr       min        lq      mean    median        uq        max neval
##  dt194  5.175392  5.287038  5.682602  5.705389  5.831791   9.602637   100
##  dt196 86.449099 87.808011 91.951204 90.939241 91.468435 270.715783   100

all.equal(mg, mg1)

### suggestion by MichaelChirico
### http://stackoverflow.com/users/3576984/michaelchirico
### to avoid `:=` did not help.

microbenchmark(dt194 = mg[, c(value[-1], NA), by = id],
               dt196 = mg[, shift(value, n = 1,
                                   type = "lead"), by = id])

## Unit: milliseconds
##   expr       min        lq     mean    median        uq       max neval
##  dt194  5.161973  5.429927  5.78047  5.698263  5.798132  10.42217   100
##  dt196 79.526981 87.914502 92.18144 91.240949 91.896799 266.04031   100
