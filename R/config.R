#' Set package options
#'
#' @param config_list list of package config
#' @export
config <- function (config_list=NULL) {
  cfg = list(
    url = 'https://api.klasifikasi.com'
  )
  result <- if (is.null(config_list) && !is.list(config_list)) cfg else modifyList(cfg, config_list)
  return(result)
}

cfg <- config()
