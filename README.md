# Nombre del Proyecto: API E-commerce - Desafío Técnico

## Descripción
Esta es una API de e-commerce creada como parte de un desafío técnico. La aplicación está desarrollada con Ruby on Rails (versión 3.2.22) y se utiliza Docker para facilitar la configuración del entorno. La base de datos utilizada es PostgreSQL.

## Requisitos Previos
Antes de comenzar, asegúrate de tener lo siguiente instalado:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Git (para clonar el repositorio)

## Instrucciones de Instalación

1. **Clonar el Repositorio**

   Abre una terminal y clona este repositorio desde GitHub:

   ```bash
   git clone https://github.com/cparram/api-ecommerce.git
   cd api-ecommerce
   ```

2. **Configurar las Variables de Entorno**

   Crea un archivo `.env` en la raíz del proyecto para definir las variables de entorno necesarias, como la configuración de la base de datos:

   ```
   DATABASE_HOST=db
   DATABASE_USERNAME=app
   DATABASE_PASSWORD=password
   DATABASE_NAME=app_development
   ```

   Estas variables serán utilizadas por Docker y Rails para configurar la conexión con la base de datos.

3. **Construir los Contenedores con Docker**

   Construye las imágenes Docker necesarias:

   ```bash
   docker-compose build
   ```

4. **Crear y Migrar la Base de Datos**

   Una vez que se hayan construido los contenedores, ejecuta los siguientes comandos para crear y migrar la base de datos:

   ```bash
   docker-compose run app bundle exec rake db:create
   docker-compose run app bundle exec rake db:migrate
   ```

5. **Cargar Datos Iniciales (Opcional)**

   Si tienes seeds definidos para poblar la base de datos con datos de prueba:

   ```bash
   docker-compose run app bundle exec rake db:seed
   ```

6. **Levantar el Servidor**

   Ahora puedes levantar el servidor de Rails. Utiliza el siguiente comando:

   ```bash
   docker-compose up
   ```

   La aplicación debería estar corriendo en [http://localhost:3000](http://localhost:3000).

## Uso de la API

Puedes utilizar herramientas como [Postman](https://www.postman.com/) o `curl` para probar los diferentes endpoints de la API.

Si hay un archivo de Postman o un script de `curl` que acompañe a este proyecto, proporciónalo aquí para facilitar las pruebas a los desarrolladores.

## Pruebas

Si deseas correr las pruebas (usando RSpec u otro framework), puedes hacerlo con el siguiente comando:

```bash
docker-compose run app bundle exec rspec
```

## Problemas Comunes

- **Problemas de Conexión a la Base de Datos**: Si ves un error indicando que no puede conectar al servidor de PostgreSQL, asegúrate de que el contenedor de la base de datos esté en ejecución:

  ```bash
  docker-compose ps
  ```

  Asegúrate de que el contenedor `db` está `Up` y no tiene errores.

- **Permisos de Archivos**: Si tienes problemas al guardar archivos, intenta cambiar los permisos de los archivos en el contenedor con el siguiente comando:

  ```bash
  sudo chown -R $(whoami):$(whoami) .
  ```

## Tecnologías Utilizadas

- **Ruby on Rails 3.2.22**: Framework de desarrollo web.
- **PostgreSQL**: Base de datos relacional.
- **Docker**: Para la configuración del entorno de desarrollo.

## Contribuciones

Si deseas contribuir a este proyecto, por favor realiza un fork del repositorio, crea una rama con tu función y luego realiza un pull request.

## Contacto

Para cualquier consulta o problema, puedes contactarme en [tu-email@ejemplo.com].
