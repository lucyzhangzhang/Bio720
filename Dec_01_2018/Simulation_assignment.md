---
title: "Simulation Assignment"
author: "Lucy Zhang"
date: "December 01, 2018"
output: 
  html_document:
    keep_md: yes
---


1. Complete Datacamp: Introduction to Bioconductor
![Completed course screenshot](./screen.png)

2. Function for deterministic simulations


```r
det_sim <- function(p = 0.6, A = 1.0, a = 1.1, Aa = 1.0, iter = 100) {
  q_val <- c((1 - p), rep(0, iter - 1))
  p_val <- c(p, rep(0, iter - 1))
  for (i in 1:(iter - 1)) {
    w_bar <- (p ^ 2 * A) + ((1 - p) ^ 2 * a) + 2 * p * (1 - p) * Aa
    p <- (A  / w_bar * (p ^ 2)) + (p * (1 - p)) * Aa / w_bar
    q_val[i + 1] <- (1 - p)
    p_val[i + 1] <- p
  }
  if (as.numeric(A) > as.numeric(a)) {
    adv <- p_val[length(p_val)]
    plot(p_val, type = "l", col = "blue", 
         xlab = "Generations", ylab = "Allele frequency")
  } else {
    adv <- q_val[length(q_val)]
    plot(q_val, type = "l", col = "blue", 
         xlab = "Generations", ylab = "Allele frequency")
  }
  if (adv == 1) {
    cat("Allele is fixed, at:", adv)
  } else {
    cat("Allele is not fixed, at:", adv)
  }
}
det_sim()
```

![](Simulation_assignment_files/figure-html/unnamed-chunk-1-1.png)<!-- -->

```
## Allele is not fixed, at: 0.9994784
```

3. Genetic drift simulation


```r
set.seed(12)
library(ggplot2)
library(reshape2)
gen_drifto <- function(p = 0.5, pop = 1000, iter = 1000) {
  p_val <- c((p), rep(0, iter - 1))
  q_val <- c((1 - p), rep(0, iter - 1))
  for (i in 2:iter) {
    sample_data <- sample(c("A", "a"), size = 2 * pop, rep = T, prob = c(p, 1 - p))
    p <- length(sample_data[sample_data == "A"]) / (2 * pop)
    p_val[i] <- p
    q_val[i] <- 1 - p
  }
  data <- rbind(p_val, q_val)
  data <- t(data)
  colnames(data) <- c("p", "q")
  data_m <- melt(data)
  ggplot(data_m, aes(x = Var1, y = value, col = factor(Var2))) +
    geom_line() + labs(x = "Generations", y = "Allele frequency") +
    theme(legend.title = element_blank())
}
gen_drifto()
```

![](Simulation_assignment_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

4. Calculating the likelihood of an allele being lost


```r
gen_drifto2 <- function(p0 = 0.5, pop = 200, iter = 100, sims = 1000) {
  p_val <- rep(0, sims)
  q_val <- rep(0, sims)
  for (x in 1:sims) {
    p <- p0
    for (i in 1:(iter)) {
      sample_data <- sample(c("A", "a"), size = 2 * pop, rep = T, prob = c(p, 1 - p))
      p <- length(sample_data[sample_data == "A"]) / (2 * pop)
    }
    p_val[x] <- p
    q_val[x] <- 1 - p
  }
  return(length(p_val[p_val ==0])/length(p_val))
}
gen_drifto2(p0 = 0.5)
```

```
## [1] 0.005
```

```r
gen_drifto2(p0 = 0.25)
```

```
## [1] 0.108
```

```r
gen_drifto2(p0 = 1.0)
```

```
## [1] 0
```

5. Keeping track of allele frequencies.


```r
gen_drifto3 <- function(p = 0.5, pop = 1000, iter = 100) {
  p_val <- c((p), rep(0, iter - 1))
  q_val <- c((1 - p), rep(0, iter - 1))
  for (i in 2:(iter)) {
    sample_data <- sample(c("A", "a"), size = 2 * pop, rep = T, prob = c(p, 1 - p))
    p <- length(sample_data[sample_data == "A"]) / (2 * pop)
    p_val[i] <- p
    q_val[i] <- 1 - p
  }
  return(p_val)
}
draw_sims <- function(iter = 100) {
  dat <- list()
  for (i in 1:iter) {
    samples <- unlist(gen_drifto3( pop = 200,iter = iter))
    dat <- rbind(unlist(dat), samples)
  }
  colnames(dat) <- c(1:iter)
  dat <- as.data.frame(dat)
  dat <- melt(t(dat))
  ggplot(dat, aes(x = Var1, y = value, color = factor(Var2))) + geom_line() +
    labs(x = "Generations", y = "Allele frequency") +
    theme(legend.position="none")
}
draw_sims()
```

![](Simulation_assignment_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

6. Analyse the statstical power of the simulation algorithms
* Generating p-values

```r
p_val <- function(int, slope, size, rse) {
  x <- seq(from = 1, to = 10, length.out = size)
  y_det <- int + slope * x
  sim <- rnorm(length(x), mean = y_det, sd = rse)
  mod_sim <- lm(sim ~ x)
  p_val_slope <- summary(mod_sim)$coef[2,4]
  return(p_val_slope)
}
p_val(0.5, 0.1, 20, 2)
```

```
## [1] 0.1280489
```

* Repeating function run and graphing the p-values


```r
my_p_vals <- rep(0, 1000)
for (i in 1:length(my_p_vals)) {
  my_p_vals[i] <- p_val(0.5, 0.1, 20, 2)
}
my_p_vals2 <- as.data.frame(unlist(my_p_vals))
colnames(my_p_vals2) <- "pval"
ggplot(my_p_vals2, aes(x=pval)) + 
  geom_histogram(bins = 100) +
  labs(x = "p-value") 
```

![](Simulation_assignment_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

* Check what proportion of times that the p-values are less than 0.05


```r
length(my_p_vals[my_p_vals<0.05])/length(my_p_vals)
```

```
## [1] 0.065
```

* Changing the slope to 0, and checking the proportion of p-values less than 0.05
* A slope of 0 results in an evenly distributed set of values from 0 to 1 because there is no correlation in the linear model. If the slope is set to a value closet to 1, then more points will be in the > 0.05 bin


```r
my_p_vals3 <- rep(0, 1000)
for (i in 1:length(my_p_vals3)) {
  my_p_vals3[i] <- p_val(0.5, 0, 20, 2)
}
my_p_vals4 <- as.data.frame(unlist(my_p_vals3))
colnames(my_p_vals4) <- "pval"
ggplot(my_p_vals4, aes(x=pval)) + 
  geom_histogram(bins = 100) + 
  labs(x = "p-value") +
  theme(legend.position="none")
```

![](Simulation_assignment_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

```r
length(my_p_vals3[my_p_vals3<0.05])/length(my_p_vals3)
```

```
## [1] 0.061
```

* Repeat for multiple sample sizes


```r
sizes <- seq(10,100, 5)
#sim_matrix <- NULL
lessfreq <- rep(0, length(sizes))
for (i in 1:length(sizes)) {
  p_vals_mat <- rep(0, 100)
  for (x in 1:100) {
    p_vals_mat[x] <- p_val(0.5, 0.1, sizes[i], 1.5)
  }
  lessfreq[i] <- length(p_vals_mat[p_vals_mat < 0.05])/length(p_vals_mat)
}
```

* Plotting the data


```r
data_freq <- as.data.frame(lessfreq)
rownames(data_freq) <- sizes
ggplot(data_freq, aes(x = sizes, y = lessfreq)) + geom_bar(stat="identity") +
  labs(x = "Sample size", y = "p-val < 0.05 frequency")
```

![](Simulation_assignment_files/figure-html/unnamed-chunk-10-1.png)<!-- -->
