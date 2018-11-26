---
title: "Nov. 19 class notes Part 2"
author: "Lucy Zhang"
date: "November 19, 2018"
output: 
  html_document:
    keep_md: yes
---



#Deteriministic vs. Stochastic
##Deterministic

* The outcome is pre-determined based on model structure and starting conditions

**A simple deterministic model**

In a single haploid model there are two alleles *A* and *a*:

* *a* is fixed by selection

* Frequency of *A* at time *t* is *p(t)*

* Fitness of *A* is $$W_A$$ and for *a* is $$w_a$$

The equation of the fitness is

```r
P_t1 <- function(P_t0, W_A, w_a) {
  w_bar <- (P_t0 * W_A) + ((1 - P_t0) * w_a)
  p_t1 <- (W_A * P_t0) / w_bar
  return(p_t1)
}

P_t1(W_A = 1.1, w_a = 1.0, P_t0 = 0.5)
```

```
## [1] 0.5238095
```

**Simulate for 200 generations**

```r
P_tnow <- integer(200)
t1 <- 0.5
for (n in 1:length(P_tnow)) {
  A <- 1.1
  a <- 1.0
  t1 <- P_t1(A, a, t1)
  P_tnow[n] <- t1
}
head(P_tnow)
```

```
## [1] 1.047619 1.105263 1.111702 1.112426 1.112507 1.112517
```

```r
tail(P_tnow)
```

```
## [1] 1.112518 1.112518 1.112518 1.112518 1.112518 1.112518
```
Keep track of the freq of current generation to predict the freq of the next generation

##Stochastic

* There are elemends to random chance that are introduced at various points of the model which leads to the inability of perfectly predicting the outcome

* Can only determined the probability of the outcome

* Is the more realistic probability model
