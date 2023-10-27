
<!-- README.md is generated from README.Rmd. Please edit that file -->

# validinsee

<!-- badges: start -->

![GitHub top
language](https://img.shields.io/github/languages/top/InseeFrLab/validinsee)
[![R-CMD-check](https://github.com/InseeFrLab/validinsee/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/InseeFrLab/validinsee/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/InseeFrLab/validinsee/branch/main/graph/badge.svg)](https://codecov.io/gh/InseeFrLab/validinsee)
[![CRAN
status](https://www.r-pkg.org/badges/version/validinsee)](https://cran.r-project.org/package=validinsee)
<!-- badges: end -->

Le package R **validinsee** permet de valider certaines données
produites par l’Insee, en particulier la conformité de numéros Siren ou
Siret.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("InseeFrLab/validinsee")
```

## Chargement

``` r
library(validinsee)
```

## Validité de numéros SIREN ou SIRET

La fonction `validation_siren` vérifie si les éléments d’un vecteur sont
des **SIREN** valides (identifiant de l’entreprise formé de 9
caractères) :

``` r
validation_siren(c("200034528", "200034582", NA))
#> [1]  TRUE FALSE    NA
```

La fonction `validation_siret` vérifie si les éléments d’un vecteur sont
des **SIRET** valides (identifiant de l’établissement formé de 14
caractères) :

``` r
validation_siret(c("20003452800014", "20003452800041", NA))
#> [1]  TRUE FALSE    NA
```
