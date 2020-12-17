#' Build pacckage
#'
#' Retrieve client token & client model data
#' @param client_data Nested list with client_id & client_secret key
#' @param cfg list of package options, created by created by [config()]
#' @export
#' @return List of client_data, client_auth & client_model with publicId key
#'
#' @example
#' client_data_1 = list(
#'   client_id = "b7ea9f90-9b6c-41e1-8aa8-449ec5a3c1f8",
#'   client_secret = "1f48ae74-0a5d-4c95-991e-57d4eea42238"
#' )
#' client_data_2 = list(
#'   client_id = "e249df6c-d9ef-4cc3-9f97-bf7f51426f2c",
#'   client_secret = "de53faf5-c583-4828-ac11-e13baff9b139"
#' )
#' clients_data <-build_client(clients_data = list(client_data_1, client_data_2))

build_client <- function(clients_data, cfg = config()) {

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
