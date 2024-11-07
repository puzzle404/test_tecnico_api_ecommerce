# Dockerfile usando RVM
FROM ubuntu:18.04

# Actualizar el sistema y agregar dependencias necesarias
RUN apt-get update -qq && apt-get install -y \
  curl gnupg build-essential libssl-dev libreadline-dev zlib1g-dev \
  libpq-dev git-core # Se agrega libpq-dev para PostgreSQL

# Instalar RVM para gestionar Ruby
RUN gpg --keyserver-options auto-key-retrieve --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 || true \
  && gpg --keyserver-options auto-key-retrieve --keyserver hkp://keyserver.ubuntu.com --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || true \
  && curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
  && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - \
  && curl -sSL https://get.rvm.io | bash -s stable

# Instalar Ruby 1.9.3 y usarlo por defecto
RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm install 1.9.3 && rvm use 1.9.3 --default"

# Configurar la variable de entorno PATH para RVM
ENV PATH /usr/local/rvm/gems/ruby-1.9.3-p551/bin:/usr/local/rvm/rubies/ruby-1.9.3-p551/bin:/usr/local/rvm/bin:$PATH
ENV GEM_HOME /usr/local/rvm/gems/ruby-1.9.3-p551
ENV BUNDLE_APP_CONFIG /usr/local/rvm/gems/ruby-1.9.3-p551

# Instalar Bundler
RUN /bin/bash -l -c "gem install bundler -v 1.17.3"

# Crear directorio para la aplicación
WORKDIR /app
COPY . /app

# Instalar las dependencias de la aplicación si el Gemfile existe
RUN if [ -f Gemfile ]; then /bin/bash -l -c "bundle install"; fi

# Comando para levantar el servidor Rails
CMD ["/bin/bash", "-l", "-c", "rails server -b 0.0.0.0"]
