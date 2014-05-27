##### R-Script to find out, what is not working as expected for
##### questions in SO or dt-help
##### Gerhard Nachtmann 20140428, 0509,22
require(data.table)

##### Merge test:

# o   'which' now accepts NA. This means return the row numbers in i that don't match, #1384iii.
#         Thanks to Santosh Srinivas for the suggestion.
# X[Y,which=TRUE]   # row numbers of X that do match, as before
# X[!Y,which=TRUE]  # row numbers of X that don't match
# X[Y,which=NA]     # row numbers of Y that don't match
# X[!Y,which=NA]    # row numbers of Y that do match (for
#         completeness)

##### Reported 20140428:
##### http://stackoverflow.com/questions/23338726/data-table-merge-xy-key-got-lost-in-v-1-9-3

set.seed(1)
dtp <- data.table(pid = gl(3, 3, labels = c("du", "i", "nouana")),
                  year = gl(3, 1, 9, labels = c("2007", "2010", "2012")),
                  val = rnorm(9), key = c("pid", "year"))
dtab <- data.table(pid = factor(c("i", "nouana")),
                  year = factor(c("2010", "2000")),
                  abn = sample(1:5, 2, replace = TRUE), key =
                   c("pid", "year"))
dtp
dtab
dtp[dtab]
key(dtp[dtab]) # key got lost
res1 <- setkeyv(dtp[dtab], key(dtp))
res1
key(res1) # repaired it
merge(dtp, dtab, all.y = TRUE)
key(merge(dtp, dtab, all.y = TRUE)) # everything ok

dtab[dtp] # *wrong* column order
##### Further merging (subset of columns) #####
## ### merge subset of columns (col) from small to big and assign
## ### it
## big[small[big], col := col]
### merge dtab$abn to dtp and
## dtp <- dtab[dtp] # (all cols from dtab)
### cols are in the correct order:
# dtp[dtab[dtp, abn]] # just show it
dtp[dtab[dtp, abn, by = .EACHI]] # since v.1.9.3
## dtp <- dtp[dtab[dtp, abn, by = .EACHI]] # the version below is better:
dtp[dtab[dtp], abn := abn] # assign it
dtp
key(dtp) # ok
###############################################

###############################################
e <- data.frame(x = 1:10)
### something strange is happening
foo <- function(u) {
  u <- data.table(u)
  warning(deparse(substitute(u)), " is not a data.table")
  u
}
foo(e)

### ok
foo1 <- function(u) {
  nu <- deparse(substitute(u))
  u <- data.table(u)
  warning(nu, " is not a data.table")
  u
}
foo1(e)

##### Reported 20140509
##### http://stackoverflow.com/questions/23563510/deparsesubstitute-within-function-using-data-table-as-argument
###############################################

###############################################
### quick example
set.seed(1)
dt <- data.table(x = 1:10, y = factor(sample(2, 10, replace = TRUE)))
dt[, z := as.numeric(levels(y))[y]]
dt
setkey(dt, z)
dt[J(1)] # doesn't work
dt[y == 1, ] # works fine
str(dt)

#####
### more sophisticated example
set.seed(1)
dt <- data.table(x = rnorm(10))
dt[, y := cut(x, breaks = c(-Inf, 0, Inf), labels = 1:2)]

as.Numeric <- function(f){
  as.numeric(levels(f))[f]
}

dt[, z := as.Numeric(y)] # as.numeric(as.character(y))
                                    # is working ...
dt
setkey(dt, z)
dt
dt[J(1)] # doesn't work
dt[y == 1, ] # works fine
str(dt)

##### Reported 20140522
##### http://stackoverflow.com/questions/23805911/binary-search-doesnt-work-in-v-1-9-3-using-numeric-key-derived-from-factor
###############################################
