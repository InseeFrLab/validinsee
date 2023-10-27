test_that("somme_luhn", {

  expect_equal(
    somme_luhn(matrix(1:2, ncol = 2)),
    4
  )

  expect_equal(
    somme_luhn(matrix(c(9L, 7L), ncol = 2)),
    16
  )

  expect_equal(
    somme_luhn(matrix(c(1L, 2L, 9L, 7L), ncol = 2, byrow = TRUE)),
    c(4, 16)
  )

  expect_equal(
    somme_luhn(matrix(c(9L, 7L, 3L), ncol = 3, byrow = TRUE)),
    17
  )

  expect_equal(
    somme_luhn(
      matrix(
        c(9L, 7L, 2L, 4L, 8L, 7L, 0L, 8L, 6L,
          9L, 2L, 7L, 4L, 8L, 7L, 0L, 8L, 6L), # inversion pos 2 et 3
        ncol = 9, byrow = TRUE
      )
    ),
    c(50, 54)
  )

})

test_that("validation_sirene (type siren)", {

  expect_warning(
    validation_sirene(c("1", NA), type = "siren"),
    "(essayer `type = \"siret\"` ?)"
  )

  expect_equal(
    validation_sirene(c("100000000", NA), type = "siren"),
    c(FALSE, NA)
  )

  expect_equal(
    validation_sirene(c("100000000", "43", "a"), type = "siren"),
    c(FALSE, FALSE, FALSE)
  )

  expect_equal(
    validation_sirene(c(NA, NA), type = "siren"),
    c(NA, NA)
  )

  expect_equal(
    validation_sirene(c("100000009", "100000000", NA), type = "siren"),
    c(TRUE, FALSE, NA)
  )

  expect_equal(
    validation_sirene(c("000000083", "000000080", NA), type = "siren"),
    c(TRUE, FALSE, NA)
  )

})

test_that("validation_sirene (type siret)", {

  expect_warning(
    validation_sirene(c("1", NA), type = "siret"),
    "(essayer `type = \"siren\"` ?)"
  )

  expect_equal(
    validation_sirene(c("77984790400034", "42", NA), type = "siret"),
    c(FALSE, FALSE, NA)
  )

  expect_equal(
    validation_sirene(c("77984790400033", "77984790400034", NA), type = "siret"),
    c(TRUE, FALSE, NA)
  )

  # La Poste
  expect_equal(
    validation_sirene("35600000000048", type = "siret"), # règle générale
    TRUE
  )
  expect_equal(
    validation_sirene("35600000027250", type = "siret"), # règle spécifique La Poste
    TRUE
  )
  expect_equal(
    validation_sirene("35600000000049", type = "siret"), # aucune des deux règles
    FALSE
  )

})

test_that("alias", {

  expect_equal(
    validation_siren(c("100000009", "100000000", "42", NA)),
    c(TRUE, FALSE, FALSE, NA)
  )

  expect_equal(
    validation_siret(c("77984790400033", "77984790400034", "42", NA)),
    c(TRUE, FALSE, FALSE, NA)
  )

})
