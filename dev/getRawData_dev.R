library(googlesheets4)

conn <- gs4_get('https://docs.google.com/spreadsheets/d/1vc3shTj6WqyrPTIbwNYOlijL50ih5Vk-5KjTfS_pVPY/edit#gid=449286518')

data <- range_read(conn, sheet = 'bp-dataset')
data <- data[,-1]

names(data) <- c('DATE','SYS','DIAS','WT','EX','MDX')
data$MDX <- NA_real_
data$DATE <- as.Date(data$DATE)
data$DATE <- as.character(data$DATE)
data$ID <- seq(1:nrow(data))
data <- dplyr::select(data,ID,everything())

gs4_deauth()

googlesheets4::gs4_auth(path = './inst/app/www/.token/rivermenu-96e6b5c5652d.json')
xxx <- googlesheets4::read_sheet('https://docs.google.com/spreadsheets/d/1vc3shTj6WqyrPTIbwNYOlijL50ih5Vk-5KjTfS_pVPY/edit#gid=449286518')
