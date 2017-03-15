# Intergrowth Growth Standards App

[Intergrowth App](http://skhan8.github.io/intergrowthApp/) wraps the [hbgd package](http://hafen.github.io/docs-hbgd/index.html) into a Shiny application. 

## Citation

The HBGD package is licensed under an MIT license.

### The Application

This application is meant to serve as a tool for analysis of proper growth centiles. Currently, the INTERGROWTH newborn size standard from gestational age in days from 232-300 is accommodated in this application.

## Launching an Intergrowth App Local Session

To open this app on your own computer, you'll need to follow these next steps:

1. Install [the latest R version](https://www.r-project.org/).
2. Install [RStudio](https://www.rstudio.com/).
3. Run the following R code within an open session of RStudio

```r
options(repos = c( CRAN = "http://cran.rstudio.com/",
tessera = "http://packages.tessera.io"))
install.packages(c("shiny","hbgd")) 

shiny::runGitHub("intergrowthApp","skhan8")
```

