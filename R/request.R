#'Request client token
#'
#'Use this function to request client data
#'
#'@param client_data list of clientId & clientSecret
#'@param cfg list of package options, created by created by [config()]
#'@export
#'@examples
#'client_data = list(
#'  clientId = 'clientid',
#'  clientSecret = 'clientSecret
#')
#'client_token <- request_token(client_data, config())
request_token <- function(client_data, cfg) {
  url <- cfg['url']
  fullUrl <- paste(url, "/api/v1/auth/token", sep="")

  r <- httr::POST(url = fullUrl, body = client_data, encode = 'json')
  response_body <- httr::content(r, "parsed")
  response_code <- httr::status_code(r)

  return(list(body = response_body, code = response_code))
}

#' Get model data
#'
#' Use this function to get model data based on client token
#' @param client_token client token, created by [request_token()$body]
#' @cfg list of package options, created by [config()]
#' @export
#'
get_model_data <- function (client_token, cfg) {
  url <- cfg['url']
  fullUrl <- paste(url, "/api/v1/auth/activeClient", sep="")
  auth <- paste("Bearer", client_token$auth$token, sep=" ")

  r <- httr::GET(url = fullUrl, httr::add_headers(Authorization = auth))
  response_body <- httr::content(r, "parsed")
  response_code <- httr::status_code(r)

  return (list(body = response_body, code = response_code))
}

#' Get classify result
#'
#' Use this function to get classifying result
#' @param client_token client token, created by [build()[['publicId']]$client_auth$token]
#' @param public_id public id model
#' @param query query
#' @cfg list of package options, created by [config()]
#' @export
#'
get_classifying_result <- function(client_token, public_id, query, cfg) {
  url <- cfg['url']
  fullUrl <- paste(url, "/api/v1/classify/", public_id, sep = "")
  auth <- paste("Bearer", client_token, sep=" ")
  req_body <- list(query = query)

  r <- httr::POST(url = fullUrl, httr::add_headers(Authorization = auth), body = req_body,encode = "json")

  response_body <- httr::content(r, "parsed")
  response_code <- httr::status_code(r)

  return (list( body = response_body, code = response_code ))
}

#' Get model logs
#'
#' Use this function get classifying logs from a model
#' @param client_token client token, created by [build()[['publicId']]$client_auth$token]
#' @param public_id public id model
#' @param query_string list of query string in url
#' @param cfg list of package options, created by [config()]
#' @export
#'
get_logs <- function(client_token, public_id, list_query, cfg) {
  url <- cfg['url']
  fullUrl <- paste(url, "/api/v1/history/", public_id, sep = "")
  auth <- paste("Bearer", client_token, sep=" ")

  r <- httr::GET(fullUrl, httr::add_headers(Authorization = auth), query = list_query)
  response_body <- httr::content(r, "parsed")
  response_code <- httr::status_code(r)

  return (list( body = response_body, code = response_code ))
}
