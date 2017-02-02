library(magrittr)

read_wdqs <- function() {
  data <- polloi::read_dataset("discovery/wdqs/basic_usage.tsv", col_types = "Dclli") %>%
    dplyr::arrange(date)
  wdqs_visits <<- data %>%
    dplyr::filter(path == "/" & http_success) %>%
    dplyr::select(c(date, is_automata, requests = events))
  sparql_usage <<- data %>%
    dplyr::filter(path == "/bigdata/namespace/wdq/sparql" & http_success) %>%
    dplyr::select(c(date, is_automata, requests = events))
  ldf_usage <<- data %>%
    dplyr::filter(path == "/bigdata/ldf" & http_success) %>%
    dplyr::select(c(date, is_automata, requests = events))
  return(invisible())
}

spider_subset <- function(data, val) {
  if (!val) {
    data <- data[!data$is_automata,]
  }
  return(dplyr::summarize(dplyr::group_by(data, date), requests = sum(requests)))
}

conditional_transform <- function(x, cond, .f, ...) {
  if (cond) {
    return(data_transform(x, .f, ...))
  } else {
    return(x)
  }
}

data_transform <- function(x, .f = identity, ...) {
  col_names <- setdiff(colnames(x), "date")
  x[, col_names] <- .f(x[, col_names], ...)
  return(x)
}

pow <- function(base, exponent) {
  return(base^exponent)
}

exp10 <- function(x) {
  return(pow(10, x))
}
