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
   git clone git@github.com:puzzle404/test_tecnico_api_ecommerce.git
   cd test_tecnico_api_ecommerce
   ```

2. **Configurar las Variables de Entorno**

   Crea un archivo `.env` en la raíz del proyecto para definir las variables de entorno necesarias, como la configuración de la base de datos. Nota: Para propósitos prácticos, se ha decidido incluir el archivo `.env` en el repositorio, pero en condiciones reales de seguridad, esto **no** se debe hacer.

   ```dotenv
   POSTGRES_USER=ecommerce_user
   POSTGRES_PASSWORD=123456
   POSTGRES_DB=ecommerce_db
   DATABASE_HOST=db
   JWT_SECRET_KEY="d1e9b7c5e84a57bb7bd216d16c31a5f6f1b4e18f4e0f8c"
   SENDGRID_API_KEY=
   ```

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

   Si deseas ejecutar los servicios en segundo plano:

   ```bash
   docker-compose up -d
   ```

   La aplicación debería estar corriendo en [http://localhost:3000](http://localhost:3000).

   Para ver los logs en otra terminal:

   ```bash
   docker exec -it test_tecnico_api_ecommerce-app-1 tail -f log/development.log
   ```

### Ejecutando en Apple Silicon (M1/M2)

Si estás usando una Mac con un procesador Apple Silicon (M1/M2), debes asegurarte de que Docker esté configurado para admitir imágenes x86/amd64:

1. **Habilitar Rosetta para Docker**:
   - Abre Docker Desktop.
   - Haz clic en el icono de Configuración (engranaje).
   - Dirígete a "Features in Development" o "Características Experimentales".
   - Habilita la opción "Use Rosetta for x86/amd64 emulation on Apple Silicon".

2. **Ejecutar Docker en Modo x86/amd64**: Rosetta emulará la arquitectura x86 para asegurar la compatibilidad.

## Uso de la API

Puedes utilizar herramientas como [Postman](https://www.postman.com/) o `curl` para probar los diferentes endpoints de la API. El archivo Postman se envía adjunto con el proyecto y contiene ejemplos de solicitudes.

## Tests con RSpec

Si deseas correr las pruebas (usando RSpec), sigue estos pasos:

1. **Crear la Base de Datos de Test**:

   ```bash
   docker-compose run app bundle exec rake db:create RAILS_ENV=test
   ```

2. **Migrar la Base de Datos**:

   ```bash
   docker-compose run app bundle exec rake db:migrate RAILS_ENV=test
   ```

3. **Correr los Tests**:

   ```bash
   docker-compose run app bundle exec rspec
   ```

## Pruebas de Envío Diario de Reporte

Para verificar que el envío diario de reportes funcione correctamente sin tener que esperar 24 horas, puedes modificar el comportamiento del servicio `report-cron` para que el reporte se genere con mayor frecuencia durante la fase de pruebas.

1. **Modificar el Intervalo de Envío**:
   - Abre el archivo `docker-compose.yml` y localiza el servicio `report-cron`.
   - Cambia el valor de `sleep 86400` (24 horas) a un valor más corto, como `sleep 60`, para que el reporte se genere cada minuto.

   **Ejemplo**:

   ```yaml
   report-cron:
     platform: linux/amd64
     build: .
     command: bash -c "while true; do bundle exec rails runner 'DailyPurchaseReportWorker.perform_async'; sleep 60; done"
     depends_on:
       - redis
       - app
     environment:
       DATABASE_HOST: ${DATABASE_HOST}
       DATABASE_USERNAME: ${POSTGRES_USER}
       DATABASE_PASSWORD: ${POSTGRES_PASSWORD}
       DATABASE_NAME: ${POSTGRES_DB}
   ```

2. **Levantar los Servicios**:

   ```bash
   docker-compose up -d report-cron
   ```

3. **Verificar el Envío de Correos**:
   - Comprueba los logs del servicio `sidekiq` para confirmar que el envío del correo se haya realizado correctamente:

   ```bash
   docker-compose logs -f sidekiq
   ```

   - También puedes comprobar la bandeja de entrada del correo de los administradores para verificar el envío del reporte.

4. **Restaurar Configuración Original**:
   - Una vez verificada la funcionalidad, vuelve a cambiar el valor de `sleep` a `sleep 86400` para que el reporte se genere cada 24 horas de forma automática.

## Tecnologías Utilizadas

- **Ruby on Rails 3.2.22**: Framework para construir la aplicación, facilitando la implementación de patrones de diseño MVC.
- **PostgreSQL**: Base de datos relacional configurada para persistir datos en un volumen Docker.
- **Docker**: Herramienta para contenerizar la aplicación, asegurando un entorno consistente.
  - **Servicios en Docker Compose**:
    - **Base de Datos (PostgreSQL)**: Imagen `postgres:9.6`, configurada con las credenciales definidas en `.env`.
    - **Redis**: Almacenamiento en memoria utilizado para manejar colas de trabajo.
    - **Aplicación (Rails)**: Ejecuta el servidor en el puerto 3000, sincronizando cambios de código.
    - **Sidekiq**: Ejecuta trabajos en segundo plano, como el envío de correos y la generación de informes.
    - **Report-Cron**: Ejecuta un worker de Sidekiq cada 24 horas para generar informes.
- **Sidekiq**: Gem para ejecutar trabajos en segundo plano, conectándose a Redis para gestionar las tareas.

## Problemas Comunes

- **Problemas de Conexión a la Base de Datos**: Si ves un error indicando que no se puede conectar a PostgreSQL, asegúrate de que el contenedor `db` esté en ejecución:

  ```bash
  docker-compose ps
  ```

  Asegúrate de que el contenedor `db` está `Up` y no tiene errores.

- **Permisos de Archivos**: Si tienes problemas al guardar archivos, intenta cambiar los permisos con el siguiente comando:

  ```bash
  sudo chown -R $(whoami):$(whoami) .
  ```

## Contribuciones

Si deseas contribuir a este proyecto, por favor realiza un fork del repositorio, crea una rama con tu función y luego realiza un pull request.

## Integración Continua (CI) con GitHub Actions

Para asegurar que el proyecto funcione correctamente con cada cambio realizado, se ha configurado un flujo de Integración Continua (CI) utilizando GitHub Actions. Esto permite ejecutar pruebas automáticas en cada pull request.

1. **Configuración del Workflow de GitHub Actions**:
   - **Checkout code**: Descarga el código del repositorio.
   - **Set up Docker**: Actualiza los paquetes e instala `docker-compose`.
   - **Set up Docker Compose**: Levanta los servicios necesarios para la aplicación.
   - **Build containers**: Construye y levanta los contenedores de la aplicación.
   - **Set up database**: Crea y migra la base de datos en el entorno de pruebas.
   - **Run tests**: Ejecuta las pruebas utilizando `rspec`.

Con esta configuración de CI, puedes garantizar que los cambios realizados no introduzcan errores antes de ser integrados en la rama principal.
