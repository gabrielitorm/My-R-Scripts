
### GeoBR - Gabrielito Menezes - 06/07/2022
### Informações úteis:
### https://github.com/ipeaGIT/geobr
### https://www.rdocumentation.org/packages/geobr/versions/1.0
### https://www.youtube.com/watch?v=BZ0NQrq3GV4&list=PLWinCsaFzrrHugN3c7CwmlFVl9kdaHQpe

# Instalar o package:

#install.packages("geobr", dependencies = T)

# Carregar packages:

library(geobr)
library(sf)
library(magrittr)
library(dplyr)
library(ggplot2)

# Acesando as informações do GeoBR:

conj_dados <- list_geobr()

conj_dados

View(conj_dados)

conj_dados %>% View()

### Lendo as áeras geográficas:

### Estados do BR

brasil <- read_state(code_state = "all", year = 2018)

plot(brasil)

### Usando o ggplot

ggplot() + geom_sf(data = brasil)

### Adicionando temas ao ggplot

ggplot() + geom_sf(data = brasil) + theme_linedraw()

ggplot() + geom_sf(data = brasil) + theme_void()

ggplot() + geom_sf(data = brasil) + theme_minimal()

ggplot() + geom_sf(data = brasil) + theme_linedraw() +
 ggtitle("Brasil") +  labs(caption = "Fonte: IBGE (2018)")

ggplot() + geom_sf(data = brasil) + theme_minimal() +
  ggtitle("Brasil") +  labs(caption = "Fonte: IBGE (2018)") +
  labs(x="Longitude", y="Latitude")


 ### Mesorrgiões

meso_reg <- read_meso_region(code_meso = "all", year = 2018)


ggplot() + geom_sf(data = meso_reg) + theme_light()


### Lendo todas as áeras geográficas de um estado 


municipios <- read_municipality(code_muni = 43, year = 2018) 

mun <- read_municipality(code_muni = 33 , year = 2018)

plot(municipios)

ggplot() + geom_sf(data=municipios) + theme_minimal()


### Retirando Lagoa Mirim e Lagoa dos Patos
### Criando um novo subset

rs_01 <- municipios[3:499,]

View(rs_01)

ggplot() + geom_sf(data = rs_01) + theme_minimal()

### Exportando o shapefile 
### Podemos criar um shapefile a partir do GeoBr
### Neste exemplo fizemos para o RS

shape_rs <- st_write(rs_01, "rs1.shp")

### Podemos usar esse shape file no GeoDa
### ou no QGIS

#### RS

rs <- read_state(code_state = 43)

plot(rs)

ggplot() + geom_sf(data = rs) + theme_bw()

# Mesorregião

meso_rg <- read_meso_region(code_meso = 43)

ggplot() + geom_sf(data = meso_rg) + theme_light()

# Microrregião

micro_rs <- read_micro_region(code_micro = 43)

ggplot() + geom_sf(data = micro_rs) + theme_light()

micro_rs$name_micro


### Áreas metropolitanas


ma <- read_metro_area()

View(ma)

plot (ma)

### Realizando um subset para RS

rs <- subset(ma, ma$code_state == 43)

plot(rs)

View(rs)


### Fazendo um subset para RM Porto Alegre

rmPoa <- subset(rs, rs$name_metro =="RM Porto Alegre")

plot(rmPoa)

ggplot() + geom_sf(data = rmPoa) + theme_light()

ggplot() + geom_sf(data = rmPoa) + theme_minimal() +
  ggtitle("Região Metropolitana de Porto Alegre") +
  labs(caption = "Fonte: GeoBR")


dim(rmPoa)

names(rmPoa)

glimpse(rmPoa)

# Para mudar a cor do preenchimento usamos o argumento
# fill = "cor". Podemos mudar a cor das linhas também,
# basta usar o argumento color = "cor".

ggplot() + geom_sf(data = rmPoa, fill = "white") + 
                     theme_minimal() +
  ggtitle("Região Metropolitana de Porto Alegre") +
  labs(caption = "Fonte: GeoBR")


### Carregando base de dados

library(readxl)

dados.rs <- read_excel("BaseDadosRS2.xlsx")

View(dados.rs)

rmPoa.dados <- rmPoa %>% left_join(dados.rs, by ="code_muni")


View(rmPoa.dados)



ggplot(rmPoa.dados) + geom_sf(aes(fill = "Renda per capita 2010"))


rmPoa.dados %>% ggplot() + 
  geom_sf(aes(fill = "Renda per capita 2010")) 


summary(rmPoa.dados$`Renda per capita 2010`)



# http://sillasgonzaga.com/material/cdr/ggplot2.html

ggplot(rmPoa.dados) +
  geom_sf(aes(fill =(`Renda per capita 2010`))) +
  # mudar escala de cores para sequencial vermelha
  scale_fill_distiller(type = "seq",
                       palette = "Reds",
                       direction = 1) +
  # deixar o mapa mais limpo e sem eixos
  theme(
    legend.position = "bottom",
    panel.background = element_blank(),
    panel.grid.major = element_line(color = "transparent"),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  ) +
  labs(title = "Renda per capita por cidade em 2010",
       fill = NULL)

#### Renda per capita em 2010

ggplot(rmPoa.dados) +
  geom_sf(aes(fill =(`Renda per capita 2010`))) +
    scale_fill_distiller(type = "seq",
                       palette = "Reds",
                       direction = 1) + 
  theme_minimal() +
  labs(title = "Renda per capita por cidade em 2010",
       fill = NULL, caption = "Fonte: GRM") 
  


### Mapa mais clean

# Carregar o pacote ggsn para colocar 
# o Norte e a escala de medida

library(ggsn)

ggplot(rmPoa.dados) +
  geom_sf(aes(fill =(`Renda per capita 2010`))) +
  scale_fill_distiller(type = "seq",
                       palette = "Reds",
                       direction = 1) + 
  theme_void() +
  labs(title = "Renda per capita por cidade em 2010",
       fill = NULL, caption = "Fonte: GRM") +
  ggsn::scalebar(data = rmPoa.dados, 
                 location="bottomright", 
                 dist=10, 
                 dist_unit = "km", 
                 transform = TRUE, 
                 model = "GRS80",
                 st.size = 1.5) +
  north(data = rmPoa.dados, 
        location="topleft", 
        symbol = 3, 
        scale = 0.15)



#### População Total em 2010

summary(rmPoa.dados$`População total 2010`)

options(scipen=999)    # sem notacao cientifica

ggplot(rmPoa.dados) +
  geom_sf(aes(fill =(`População total 2010`))) +
  scale_fill_distiller(type = "seq",
                       palette = "Reds",
                       direction = 1) + 
  theme_minimal() +
  labs(title = "População total 2010",
       fill = NULL, caption = "Fonte: GRM") 

#### IDHM em 2010

summary(rmPoa.dados$`IDHM 2010`)


ggplot(rmPoa.dados) +
  geom_sf(aes(fill =(`IDHM 2010`))) +
  scale_fill_distiller(type = "seq",
                       palette = "Blues",
                       direction = 1) + 
  theme_minimal() +
  labs(title = "População total 2010",
       fill = NULL, caption = "Fonte: GRM") 





