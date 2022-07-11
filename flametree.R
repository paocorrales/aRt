library(flametree)

# Elejí una semilla
this_seed <- 314

# Elejí los colores
shades <- c("#1b2e3c", "#0c0c1e", "#74112f", "#f3e3e2")

# Estructura de datos que define los arboles
dat <- flametree_grow(seed = this_seed, time = 10, trees = 10)

# Gráfico
tree <- dat %>%
  flametree_plot(
    background = "antiquewhite",
    palette = shades,
    style = "nativeflora"
  )

tree
# Guarda el gráfico
flametree_save(tree, filename = "fig/tree.png")
