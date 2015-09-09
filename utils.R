#Dependent libs
library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)

#Utility functions for handling particularly common tasks
download_set <- function(dataset){
  con <- url(paste0("http://datasets.wikimedia.org/aggregate-datasets/wdqs/", dataset,
                    "?ts=", gsub(x = Sys.time(), pattern = "(-| )", replacement = "")))
  return(readr::read_delim(con, delim = "\t"))
}

# This function takes a number and returns a compressed string (e.g. 1624 => 1.6K or 2K, depending on round.by)
compress <- function(x, round.by = 2) {
  # by StackOverflow user 'BondedDust' : http://stackoverflow.com/a/28160474
  div <- findInterval(as.numeric(gsub("\\,", "", x)), c(1, 1e3, 1e6, 1e9, 1e12) )
  paste(round( as.numeric(gsub("\\,","",x))/10^(3*(div-1)), round.by), c("","K","M","B","T")[div], sep = "" )
}
