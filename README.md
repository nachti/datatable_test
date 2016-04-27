datatable_test
==============

Tests for the [data.table](https://github.com/Rdatatable/datatable) package by Gerhard Nachtmann.

To run `test.data.table()` and write the output to `tdt310_195.out` use
``` bash
nohup ./testdatatable.R > tdt310_195.out &
```
Filename: `tdt<R-version>_<data.table-version>.out`
tdt stands for testdatatable

To store code snippets to find possibly bugs or other unexpected behaviour to be reported use `datatable_reports.R`

## 20160427

Added R-Script `latin1quotedat.R` to test `fread` with headers
with special characters (latin1) and unusual nested quotes:
`latin1quotedat.csv` is a test file.
That's not my data, I just have to work with them ...
