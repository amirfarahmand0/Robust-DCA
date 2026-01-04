compute_nb <- function(components, z) {
  prev <- components["prevalence"]
  sens <- components["sensitivity"]
  spec <- components["specificity"]
  nb <- sens * prev - (1 - spec) * (1 - prev) * (z / (1 - z))
  return(nb)
}

compute_true_nb <- function(model, large_data, target_t = 1, pt) {
  if (missing(pt)) stop("pt must be provided")
  nbs <- sapply(pt, function(z) {
    risk_score <- predict_risk(model, large_data, target_t)
    comps <- true_components(large_data, t = target_t, z = z, risk_score = risk_score)
    nb <- compute_nb(comps, z = z)
    return(nb)
  })
  data.frame(pt = pt, NB_true = nbs)
}

compute_km_nb <- function(model, valid_data, target_t = 1, pt) {
  if (missing(pt)) stop("pt must be provided")
  results <- lapply(pt, function(z) {
    risk_score <- predict_risk(model, valid_data, target_t)
    comps <- km_components(valid_data, t = target_t, z = z, risk_score = risk_score)
    nb <- compute_nb(comps, z = z)
    data.frame(pt = z, NB_km = nb)
  })
  do.call(rbind, results)
}

compute_ipcw_nb <- function(model, valid_data, target_t = 1, pt) {
  if (missing(pt)) stop("pt must be provided")
  results <- lapply(pt, function(z) {
    risk_score <- predict_risk(model, valid_data, target_t)
    comps <- ipcw_components(valid_data, t = target_t, z = z, risk_score = risk_score)
    nb <- compute_nb(comps, z = z)
    data.frame(pt = z, NB_ipcw = nb)
  })
  do.call(rbind, results)
}
