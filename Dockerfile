# Etapa de construcción (Build stage)
FROM debian:latest AS build-env

# Instalar dependencias necesarias para Flutter Web
RUN apt-get update && apt-get install -y curl git wget unzip xz-utils zip libglu1-mesa
RUN apt-get clean

# Clonar el repositorio de Flutter (versión estable)
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Establecer la variable de entorno del path de Flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Habilitar flutter web y obtener dependencias
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Copiar el código fuente de la aplicación
RUN mkdir /app/
COPY . /app/
WORKDIR /app/

# Inicializar/Configurar la plataforma web requerida por Flutter
RUN flutter create . --platforms web

# Obtener paquetes y construir la aplicación web de producción
RUN flutter pub get
RUN flutter build web --release

# Etapa del servidor de producción (Production server stage)
FROM nginx:alpine
# Copiar los archivos compilados de la etapa de construcción al servidor web Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Exponer el puerto 80
EXPOSE 80

# Iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
