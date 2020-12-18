# Klasifikasi for R

Official [Klasifikasi](https://klasifikasi.com/) API Client Library

## Requirements
R >= 3.6.3
## Installation
You can install it with devtools
```R
devtools::install_github("bahasa-ai/klasifikasi-r")
```

## Quick Start

You will need valid `clientId` & `clientSecret` of your model. You can get those
from credential section at your model page, which is both unique per model.

```R
clients_data <-klasifikasi::build(clients_data = list(
  list(
    client_id = "client-id",
    client_secret = "client-secret"
  )
))

```
You can pass multiple `clientId` & `clientSecret` too

```R
clients_data <-klasifikasi::build(clients_data = list(
  list(
    client_id = "client-id-1",
    client_secret = "client-secret-1"
  ),
  list(
    client_id = "client-id-2",
    client_secret = "client-secret-2"
  )
))
#'  clients_data variable will be look like this
#'  clients_data: List of n
#'  ..$ publicId-1: List of 3
#'  ....$ client_data: List of 2
#'  ....$ client_auth: List of 2
#'  ....$ client_model: List of 12
#'  ..$ publicId-2: List of 3
#'  ....$ client_data: List of 2
#'  ....$ client_auth: List of 2
#'  ....$ client_model: List of 12
#' 
```

## Classify
You will need you model `publicId` to start classifying with your model. You can get your model `publicId` from your model page or you can get it from return variable of `build()` function, in previous case, from `clients_data` variable

Classifying example
```R
result <- klasifikasi::classify("publicId", clients_data[["publicId"]], "query")
#' result will be look like this
#' result : List of n
#' :List of 2
#' ..$ label: chr "tag 1"
#' ..$ score: num 0.661
#' : List of 2
#' ..$ label: chr "tag 2"
#' ..$ score: num 0.339
```

## Logs
You can get your classifying logs based on your model `publicId`
```R
result_logs <- klasifikasi::logs(
  "publicId",
  clients_data[['publicId']],
  started_at = "2020-12-15T00:00:00+0700",
  ended_at = "2020-12-20T00:00:00+0700",
  take = 5,
  skip = 0)
```
`started_at` & `ended_at` param is mandatory but `skip` & `take`  is optional. Please note, `started_at` & `ended_at` param must be a valid date string (We recommend using ISO 8601 Format)

## Error
All the function above will trigger `stop()` if something bad happen.
```
