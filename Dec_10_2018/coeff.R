coeff <- function(x) {
  if (any(is.na(x))) {
    warning("NA values removed from data")
    x <- x[!is.na(x)]
  } else if (length(x) == 1) {
    stop("Data of length 1")
  } else if (any(is.character(x))) {
    stop("Non-numeric values in data")
  }
  coeff_var = sd(x)/mean(x)
  return(coeff_var)
}

