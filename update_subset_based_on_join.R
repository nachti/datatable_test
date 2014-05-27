##### Update subset of data.table based on join
### Example from http://stackoverflow.com/questions/14720923/update-subset-of-data-table-based-on-join
require(data.table)
set.seed(1)
DT1<-data.table(id1=rep(1:3,2),id2=sample(letters,6), v1=rnorm(6), key="id2")
DT1
DT2<-data.table(id2=c("n","u"), v1=0, key="id2")
DT2
set.seed(2)
DT1b<-DT1[,v2:=rnorm(6)] # Copy DT1 and add a new column
setkey(DT1b,id2)
DT1b
DT2b<-rbindlist(list(DT2,data.table(id2="e",v1=0))) # Copy DT2 and add a new row
DT2b[,v2:=-1] # Add a new column to DT2b
setkey(DT2b,id2)
DT2b

DT1b[id1 %in% c(1,2)] # show DT1b, where id1 is 1 or 2
DT2b[DT1b[id1 %in% c(1,2)],nomatch=0] # merge the subset from above with DT2b
                                      # just for matching rows.
DT1b[DT2b[DT1b[id1 %in% c(1,2)],nomatch=0],] # match the new subset to DT1B
### dt 1.9.3
DT1b[DT2b[DT1b[id1 %in% c(1,2)],nomatch=0], i.v1] # the *wrong* one
DT1b[DT2b[DT1b[id1 %in% c(1,2)],nomatch=0], i.v1, by = .EACHI]


## ##### Not working in data.table 1.9.3 any more ...
## ### Overwrite existing v1 and v2 for those subsets in DT1b
## DT1b[DT2b[DT1b[id1 %in% c(1,2)],nomatch=0],c("v1","v2"):=list(i.v1,i.v2)]
## DT1b

### For data.table 1.9.3; not working with 1.8.10 any more ...
### http://stackoverflow.com/questions/23289646/update-subset-of-data-table-based-on-join-using-data-table-1-9-3-does-not-work-a
DT1b[DT2b[DT1b[id1 %in%
               c(1,2)],nomatch=0],c("v1","v2"):=list(i.v1,i.v2),
     by=.EACHI]
DT1b
