#' Build pacckage
#'
#' Retrieve client token & client model data
#' @param client_data Nested list with client_id & client_secret key
#' @param cfg list of package options, created by created by [config()]
#' @export
#' @return List of client_data, client_auth & client_model with publicId key
#'
#' @example
#' client_data_1 <- list(
#'   client_id = "client_id",
#'   client_secret = "client_secret"
#' )
#' init_app(clients_data = list(client_data_1))
#'
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
