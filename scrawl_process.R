# preliminaries -----------------------------------------------------------
# El siguiente script fue traducido adaptado de "aRt programming" de Danielle Navarro

# Carga los paquetes
library(dplyr)
library(ambient) 
library(scico)

# Guardad los parámetros necesarios en una lista. En cada caso los 
# los parámetros deben ser enteros positivos
art_par <- list(
  seed = 2,        # semilla para generar números aleatorios
  n_paths = 500,   # número de caminos
  n_steps = 80,    # número de pasos
  sz_step = 200,   # tamaño de un paso típico
  sz_slip = 200    # tamaño de una patinada típica
)


# iniciando la base -------------------------------------------------


# Para asegurarnos que es reproducible, usamos la semilla
set.seed(art_par$seed)

# Para dibujar nuestro garabato, tenemos que definir el "estado" (state) de nuestro dibujo
# luego del primer "paso" (step). Cada camino (path) comienza en una ubicación random del  
# espacio de dibujo (variables: x e y), y tiene una coordenada escondida z que arranca 
# en 0 para cada camino 
state <- tibble(
  x = runif(art_par$n_paths, min = 0, max = 2), # números aleatorios uniformes entre 0 y 2
  y = runif(art_par$n_paths, min = 0, max = 2), # números aleatorios uniformes entre 0 y 2
  z = 0
)

# Es una buena práctica asignarle un id a cada camino y de la misma manera, asignar un id a 
# a cada paso (este es el primer paso por lo que step_id = 1 para todos los caminos)
state <- state %>% 
  mutate(
    path_id = 1:art_par$n_paths,
    step_id = 1
  )

# Finalmente, creamos una nueva variable art_dat que guardara los datos para cada paso
# a medida que "dibujamos"
art_dat <- state


# creando los datos -----------------------------------------------


# Crea una variable "dummy" stop_painting. Es una variable lógica que le dice a R 
# si debe continuar dibujando o debe parar
stop_painting <- FALSE

while(stop_painting == FALSE) {
  
  # Esto es un poco de magia... Toma el dataframe con el estado actual y
  # y genera un nuevo paso con valores para x, y y z que indican como "mover"
  # el pincel.
  step <- curl_noise(
    generator = gen_simplex,
    x = state$x,
    y = state$y,
    z = state$z,
    seed = c(1, 1, 1) * art_par$seed
  )
  
  # Use los datos en "step" para modificar el estado (state) actual moviendo 
  # el pincel de acuerdo a x e y. Además "resbala" un poquito en la dimensión z.
  state <- state %>% 
    mutate(
      x = x + step$x * art_par$sz_step / 10000, # paso en el eje x
      y = y + step$y * art_par$sz_step / 10000, # paso en el eje y
      z = z + step$z * art_par$sz_slip / 10000, # paso en el eje z (invisible)
      step_id = step_id + 1                     # incrementa el paso!
    )
  
  # Agrega los datos del nuevo paso al final del dataframe art_dat
  art_dat <- bind_rows(art_dat, state)
  
  # El valor de step_id en la última final de art_dat  nos indica cuantos pasos 
  # dibujamos hasta ahora
  current_step <- last(art_dat$step_id)
  
  # Si ya dibujamos todos los pasos necesarios modificamos la variable stop_painting
  # para dejar de dibujar!
  if(current_step >= art_par$n_steps) {
    stop_painting <- TRUE
  }
}

# dibujamos --------------------------------------------------------

palette_name <- "grayC"

art_pic <- ggplot(
  data = art_dat,
  mapping = aes(
    x = x, 
    y = y, 
    group = path_id,
    color = step_id
  )
) + 
  geom_path(
    size = .5,
    alpha = .5,
    show.legend = FALSE
  ) +
  coord_equal() +
  theme_void() +
  scale_color_scico(palette = palette_name)



