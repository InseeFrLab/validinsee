# https://fr.wikipedia.org/wiki/Formule_de_Luhn
# @param id_int matrice des id (chaque cellule est un chiffre unique)

somme_luhn <- function(id_int) {

  stopifnot(
    is.matrix(id_int) &&
    is.integer(id_int) &&
    all(id_int >= 0) &&
    all(id_int <= 9)
  )

  # inverse l'ordre des colonnes
  m <- id_int[ , ncol(id_int):1, drop = FALSE]

  # multiplie les éléments des colonnes paires par 2
  col_paires <- which(seq(ncol(m)) %% 2 == 0)
  m[ , col_paires] <- m[ , col_paires] * 2
  # fait la somme des chiffres si supérieur à 9
  m[m > 9] <- m[m > 9] - 9

  rowSums(m)

}

#' Validité de SIRET ou SIREN
#'
#' Vérifie la validité d'un vecteur de SIRET ou de SIREN.
#'
#' La vérification se base sur la
#' [formule de Luhn](https://fr.wikipedia.org/wiki/Formule_de_Luhn).
#'
#' - un SIREN est valide si sa somme de Luhn est un multipe de 10 ;
#'
#' - un SIRET est valide si sa somme de Luhn est un multipe de 10 et si la somme
#'   de Luhn de son SIREN (9 premiers chiffres) est un multiple de 10 ;
#'
#' - un SIRET de _La Poste_ (SIREN 356000000) ne respectant pas la règle
#'   ci-dessus fait l'objet d'un traitement différencié : il est valide si la
#'   somme des chiffres le composant est un multiple de 5.
#'
#' Les fonctions `validation_siren` et `validation_siret` permettent d'appeler
#' `validation_sirene` sans avoir à préciser le type de numéro.
#'
#' @param id un vecteur caractère de SIRET, ou de SIREN si `type = "siren"`.
#' @param type par défaut `"siret"` (chaîne de caractères de 14 chiffres).
#'   Autre valeur possible `"siren"` (9 chiffres).
#' @param warn `FALSE` pour désactiver d'éventuels warnings.
#'
#' @return Un vecteur booléen de même longueur que `id`. Une valeur manquante
#'   produira une valeur manquante en retour.
#' @export
#'
#' @examples
#' validation_sirene(c("20003452800014", "20003452800041", "a", NA)) # SIRET (14 chiffres)
#' validation_sirene(c("200034528", "200034582", "a", NA), type = "siren")
#'
#' # utiliser les alias pour ne pas renseigner `type`
#' validation_siret(c("20003452800014", "20003452800041", "a", NA))
#' validation_siren(c("200034528", "200034582", "a", NA))

validation_sirene <- function(id, type = c("siret", "siren"), warn = TRUE) {

  if (all(is.na(id))) return(as.logical(id))

  type <- match.arg(type)

  res <- rep(NA, length(id))

  if (type == "siret")
    looks_ok <- grepl("^\\d{14}$", id)
  else
    looks_ok <- grepl("^\\d{9}$", id)

  if (warn && !any(looks_ok))
    warning(
      "aucun id ne comporte le bon nombre de chiffres ",
      sprintf("(essayer `type = \"%s\"` ?)", chartr("nt", "tn", type))
    )

  res[!looks_ok & !is.na(id)] <- FALSE
  if (all(!looks_ok)) return(res)

  id <- id[looks_ok]

  # transformation en matrice numérique pour somme_luhn()
  mat_id_num <-
    matrix(
      as.integer(unlist(strsplit(id, ""))),
      nrow = length(id),
      byrow = TRUE
    )

  luhn_ok <- somme_luhn(mat_id_num) %% 10 == 0

  if (type == "siret") {

    # le SIREN a sa propre clé de contrôle

    sommes_luhn_siren <- somme_luhn(mat_id_num[ , 1:9, drop = FALSE])
    luhn_ok_siren <- sommes_luhn_siren %% 10 == 0
    luhn_ok <- luhn_ok & luhn_ok_siren

    # Critère différent pour établissements La Poste (somme simple multiple de 5)
    # https://groupes.renater.fr/sympa/arc/pstage-utilisateurs/2014-02/msg00035.html

    poste_invalides <- substr(id, 1, 9) == "356000000" & !luhn_ok
    if (any(poste_invalides)) {
      luhn_ok[poste_invalides] <- rowSums(mat_id_num[poste_invalides, , drop = FALSE]) %% 5 == 0
    }

  }

  res[looks_ok] <- luhn_ok

  res

}

#' @rdname validation_sirene
#' @export

validation_siren <- function(id)
  validation_sirene(id, type = "siren", warn = FALSE)

#' @rdname validation_sirene
#' @export

validation_siret <- function(id)
  validation_sirene(id, type = "siret", warn = FALSE)
