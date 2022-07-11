library(voronoise)

# Semilla
set.seed(314)

# Estructura de datos
dat <- tibble::tibble(
  x = runif(n = 50, min = .1, max = .9),
  y = runif(n = 50, min = .1, max = .9),
  shade = sample(colours(), size = 50, replace = TRUE)
)

# Grafico
voronoise_base(dat) + 
  geom_voronoise(fill = "antiquewhite2") + 
  geom_voronoise(perturb = perturb_uniform(.2)) 

# Guarda el gráfico
ggsave(filename = "fig/voronoise.png")

# Otro grafico 
voronoise_base(
  data = voronoise_data(100, viridis::magma(10)), # Datos
  background = "skyblue3"
) + 
  geom_voronoise(fill = "skyblue2") +
  geom_voronoise(
    perturb = perturb_float(
      angles = c(0, 90, 180), 
      noise = c(2, 1)
    )
  )
