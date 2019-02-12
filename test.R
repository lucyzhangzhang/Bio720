counter <- function(x) {
  a = 0
  t = 0 
  c = 0
  g = 0
  for (item in 1:lengths(x)) {
    if (x[[item]] == "A") {
      a = a + 1
    } else if (x[[item]] == "T") {
      t = t + 1
    } else if (x[[item]] == "C") {
      c = c + 1
    } else if (x[[item]] == "G") {
      g = g + 1
    } else {
      print("Invalid character")
    }
  }
  return(c(a, t, c, g))
}
counter(read_1_split)