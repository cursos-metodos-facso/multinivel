# general & atom workflow

## logica general:

- archivo clave: config.yaml, aquí se establece toda la arquitectura del sitio.
- Luego, en la estructura hay carpetas claves:
  - **content**: aquí está todo lo que se busca desde el yaml, son los contenidos del sitio. En general se usa para aquellos archivos que requieren compilación (tipo Rmd)
  - **static**: aquí los archivos estáticos que no requieren compilación (images, textos, etc.). Aquí también los archivos Rmd que requieren compilación especial, tipo presentaciones Xaringan; de otra manera son compilados como Rmd a página html y se pierde todo el formato.
  - **public**: es lo que finalmente se arma como sitio public luego de la compilación, y contiene elementos tanto de contenido como los estáticos. Esto no se toca, se genera automáticamente desde content y static al generar el sitio.
  - **theme**: archivos css y otros de estilo del sitio.


# Clonando blogdown datamanagement de Kieran Healey

- fork en github
- clonar a local
- ajustar theme: el theme de este sitio conduce a otro repositorio que lo tiene, lo que generó problemas en el deploy. Primer intento: bajar los archivos del repo directamente a la carpeta del tema original; no resultó porque de todas maneras la carpeta quedó vinculada al repo original y pedía verificación adicional, generando problemas en netlify. Segundo intento: generar otra carpeta en themes con nombre distinto, copiar
- Luego, para renderizar los Rmd a html se requiere pandoc-sidenote. Para instalar:

wget https://github.com/schollz/pandoc-sidenote/releases/download/v1.0/pandoc-sidenote
chmod +x pandoc-sidenote
sudo mv pandoc-sidenote /usr/local/bin

- Y con eso debería andar.

- Luego, hacer el push a Github
- en Netlify, conectar con el repositorio
- importante: al principio cuando se pide el comando con el cual ejecutar el sitio, dar la versión de hugo de esta manera "hugo_0.54.0". Para revisar la versión, en terminal: hugo version
- tambien en Netlify tiene que ser especificado como "public"


# Atom workflow

- To render website

  - Open R in project terminal
  blogdown::build_site(local = FALSE, method = c("html", "custom"),run_hugo = TRUE)
  - blogdown:::serve_site()
  - automáticamente abre browser con sitio
  - A veces no rinde a la primera ... y se ve solo el footer; intentar de nuevo
  - luego el serve_site queda activo y los cambios se van actualizando automáticamente al modificar el Rmd (no requiere el build_site, al menos no a cada rato)
