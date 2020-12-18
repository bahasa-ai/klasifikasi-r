#' Build package
#'
#' Retrieve client token & client model data
#' @param client_data Nested list with client_id & client_secret key
#' @param cfg list of package options, created by created by [config()]
#' @export
#' @return List of client_data, client_auth & client_model with publicId key
#'
#' @example
#' client_data_1 = list(
#'   client_id = "client-id-1",
#'   client_secret = "client-secret-1"
#' )
#' client_data_2 = list(
#'   client_id = "client-id-2",
#'   client_secret = "client-secret-2"
#' )
#' clients_data <-build(clients_data = list(client_data_1, client_data_2))

build <- function(clients_data, cfg = config()) {

  result <- list()

  for (client_data in clients_data) {

    client_token_response = request_token(list(clientId = client_data$client_id,
      clientSecret = client_data$client_secret
    ), cfg)
    if (client_token_response$code != 200) {
      stop(client_token_response$body$error)
    }

    client_model_response = get_model_data(client_token_response$body, cfg)
    if (client_token_response$code != 200) {
      stop(client_model_response$body$error)
    } else if (!exists('model', client_model_response$body)) {
      stop("Client didnt have any model !")
    }

    data <- list(
      client_data = client_data,
      client_auth = client_token_response$body$auth,
      client_model = client_model_response$body$model
    )

    result[[data$client_model$publicId]] = data

  }
  return(result)
}

#' Classyfing into a model
#'
#' Get classifying result from a model
#' @param public_id public id of a model, you can get it from your model page in klasifikasi webapp
#' @param client_list client list from a model, you can get it from [build()[['publicId']]]
#' @param cfg list of package options, created by created by [config()]
#' @export
#' @return list of tag result
#'
#'
classify <- function (public_id, client_list, query, cfg = config()) {
  if (is.null(client_list)) {
    stop("client list cant be null !")
  }

  client_token <- client_list$client_auth$token
  classifying_result_response = get_classifying_result(client_token, public_id, query, cfg)
  if (classifying_result_response$code != 200) {
    stop(classifying_result_response$body$error)
  }

  return(classifying_result_response$body$result)
}
