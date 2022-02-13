library(tidyverse)
library(readxl)
library(janitor)
#install.packages("tidygeocoder")
library(tidygeocoder)
library(sf)
library(mapview)

uk_addresses <- read_excel("data/street-addresses.xlsx",
                           sheet = "UK Addresses") %>%
  clean_names()


geo("221B Baker Street")

braga <- geo("Rua Braga, 202")
scs <- geo("Rua Amazonas, São Caetano do Sul,  439")


# Colocando o KEY no arquivo env
usethis::edit_r_environ()

braga %>% 
  bind_rows(scs) %>% 
  select(address, long, lat) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  mapview()


uk_addresses <- uk_addresses %>% 
  geocode(street = street_address,
          city = city,
          postalcode = post_code,
          country = country,
          method = "iq")

uk_addresses %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  mapview()


# MEDICOS ----

regioes <- read_xlsx("../../../aleatorio/Monica/Mailing_com_Regioes.xlsx") %>% 
  clean_names()

regioes

set.seed(123)
aa <- regioes %>% 
  filter(uf == "SP") %>% 
  sample_n(10)

aa <- aa %>% 
  separate(endereco, into = c("end_curto"), sep = ",", remove = TRUE)

bb <- aa %>% 
  geocode(street = end_curto, city = cidade, state = uf, method = "iq") 

bb %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  mapview()
