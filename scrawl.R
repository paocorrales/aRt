library(scrawl)

# Estructura de datos
data <- scrawl_build(seed = 1, 
                     n_paths = 1000, 
                     n_steps = 50, 
                     sz_step = 50, 
                     sz_slip = 5)

# Grafico 
scrawl_plot(data)

# Guardo el gráfico

ggsave(filename = "fig/scrawl.png")

