##### R-Script to speedup leading / lagging
##### Gerhard Nachtmann 20150723
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
### see also shift() in dt1.9.5

##### data.table 1.9.4
### lag
data[, lag.value := c(NA, value[-.N]), by = groups]
data

### lead
data[, lead.value := c(value[-1], NA), by = groups]
data

### clean
data[, c("lead.value", "lag.value") := NULL]

##### dplyr
d1r <- d1 %>% group_by(groups) %>%
       mutate(lead.value = lead(value, 1))
d1r
rm(d1r)


microbenchmark(dt = data[, lead.value := c(value[-1], NA), by = groups],
               ldf = d1r <- d1 %>% group_by(groups) %>%
                            mutate(lead.value = lead(value, 1)),
               ldt = d2r <- d2 %>% group_by(groups) %>%
                            mutate(lead.value = lead(value, 1)),
               dt1 = d3[, lead.value := c(value[-1], NA), by = groups]
               )
### dt = fastest; interesting: ldt is much slower than ldf
data
d1r
d2r
d3
all.equal(as.data.frame(data), as.data.frame(d1r))
all.equal(as.data.frame(data), as.data.frame(d2r))
all.equal(as.data.frame(data), as.data.frame(d3))
