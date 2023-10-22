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
#' Pour les SIREN et SIRET, la vérification est faite sur la base de
#' la [formule de Luhn](https://fr.wikipedia.org/wiki/Formule_de_Luhn).
#'
#' Un SIREN est valide si sa somme de Luhn est un multipe de 10.
#'
#' Un SIRET est valide si sa somme de Luhn est un multipe de 10 et si la somme
#' de Luhn de son SIREN (9 premiers chiffres) est un multiple de 10.
#'
#' Les SIRET de *La Poste* (SIREN 356000000) ne respectant pas cette règle font
#' l'objet d'un traitement différencié. Il seront considérés comme valides si
#' la somme des chiffres les composant est un multiple de 5.
#'
#' @param id un vecteur caractère de SIRET, ou de SIREN si `type = "siren"`.
#' @param type par défaut `"siret"` (chaîne de caractères de 14 chiffres).
#'   Autre valeur possible `"siren"` (9 chiffres).
#'
#' @return Un vecteur booléen de même longueur que `id`. Une valeur manquante
#'   produira une valeur manquante en retour.
#' @export
#'
#' @examples
#' validation_sirene(c("20003452800014", "20003452800041", "a", NA)) # SIRET (14 chiffres)
#' validation_sirene(c("200034528", "200034582", "a", NA), type = "siren")

validation_sirene <- function(id, type = c("siret", "siren")) {

  type <- match.arg(type)

  res <- rep(NA, length(id))

  if (type == "siret")
    looks_ok <- grepl("^\\d{14}$", id)
  else
    looks_ok <- grepl("^\\d{9}$", id)

  res[!looks_ok & !is.na(id)] <- FALSE
  if (all(!looks_ok)) return(res)

  id <- id[looks_ok]

  # matrice numérique
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
