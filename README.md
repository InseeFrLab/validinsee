
<!-- README.md is generated from README.Rmd. Please edit that file -->

# validinsee

<!-- badges: start -->

![GitHub top
language](https://img.shields.io/github/languages/top/InseeFrLab/validinsee)
[![R-CMD-check](https://github.com/InseeFrLab/validinsee/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/InseeFrLab/validinsee/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/validinsee)](https://cran.r-project.org/package=validinsee)
<!-- badges: end -->

Le package R **validinsee** permet de valider certaines données
produites par l’Insee, en particulier la conformité de numéros Siren ou
Siret.

## Installation

``` r
# install.packages("remotes")
devtools::install_github("InseeFrLab/validinsee")
```

## Chargement

``` r
library(validinsee)
```

## Validité de numéros SIREN ou SIRET

Utiliser la fonction `validation_sirene` pour vérifier si les éléments
du vecteur sont des **SIRET** valides (identifiant de l’établissement
formé de 14 caractères) :

``` r
validation_sirene(c("20003452800014", "20003452800041", NA))
#> [1]  TRUE FALSE    NA
```

Pour vérifier que les éléments sont des **SIREN** valides (identifiant
de l’entreprise formé de 9 caractères), préciser l’argument
`type = "siren"` :

``` r
validation_sirene(c("200034528", "200034582", NA), type = "siren")
#> [1]  TRUE FALSE    NA
```
