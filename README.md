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
   git@github.com:puzzle404/test_tecnico_api_ecommerce.git
   cd test_tecnico_api_ecommerce
   ```

2. **Configurar las Variables de Entorno**

   Crea un archivo `.env` en la raíz del proyecto para definir las variables de entorno necesarias, como la configuración de la base de datos. NOTA: PARA CASOS PRACTICOS SE DECIDIO INCLUIR EL ARCHIVO .env EN EL RESPOSITORIO (en condiciones normales por seguridad ESTO NO SE HACE).

   ```
    POSTGRES_USER=ecommerce_user
    POSTGRES_PASSWORD=123456
    POSTGRES_DB=ecommerce_db
    DATABASE_HOST=db
    JWT_SECRET_KEY="d1e9b7c5e84a57bb7bd216d16c31a5f6f1b4e18f4e0f8c"
    SENDGRID_API_KEY="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"

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
   docker-compose run app bundle exec rake db:seed
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

   Para tener logs con mayor descripcion correr en otra terminal:
   ```bash
   docker exec -it test_tecnico_api_ecommerce-app-1 tail -f log/development.log
   ```


## Uso de la API

Puedes utilizar herramientas como [Postman](https://www.postman.com/) o `curl` para probar los diferentes endpoints de la API.

Si hay un archivo de Postman o un script de `curl` que acompañe a este proyecto, proporciónalo aquí para facilitar las pruebas a los desarrolladores.

## Tests con Rspec

Si deseas correr las pruebas (usando RSpec), puedes hacerlo los siguiente comandos:

1 - Creamos la base de datos de test:
```bash
docker-compose run app bundle exec rake db:create RAILS_ENV=test
```
2 - Migramos la base
```bash
docker-compose run app bundle exec rake db:migrate RAILS_ENV=test
```

- Antes de correr los seeds, crear un usuario administrador asignandole un correo para que puedan testear los envios de correos (reporte diario y primera compra de producto)
```bash
docker-compose run app bundle exec rspec
```

## Pruebas de Envío Diario de Reporte

Para verificar que el envío diario de reportes funcione correctamente sin tener que esperar 24 horas, puedes modificar el comportamiento del servicio report-cron para que el reporte se genere con mayor frecuencia durante la fase de pruebas.

Pasos para Testear el Envío de Reporte Diario

1. Modificar el Intervalo de Envío

Abre el archivo docker-compose.yml y localiza el servicio report-cron.

Cambia el valor de sleep 86400 (24 horas) a un valor más corto, como sleep 60, para que el reporte se genere cada minuto.

Ejemplo:

yaml
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

2. Levantar los Servicios

Luego de modificar el archivo docker-compose.yml, ejecuta el siguiente comando para levantar el servicio:

```bash
docker-compose up -d report-cron
```
Esto hará que el DailyPurchaseReportWorker se ejecute automáticamente y genere reportes cada minuto.

3. Verificar el Envío de Correos

Puedes comprobar los logs del servicio sidekiq para confirmar que el envío del correo del reporte se haya realizado exitosamente.

Para ver los logs de Sidekiq:

```bash
docker-compose logs -f sidekiq
```
También puedes comprobar en la bandeja de entrada del correo de los administradores para verificar que hayan recibido el reporte.

Restaurar Configuración Original

Una vez verificada la funcionalidad del envío diario, vuelve a cambiar el valor de sleep en el archivo docker-compose.yml a sleep 86400 para que el reporte se genere cada 24 horas de forma automática.

## Tecnologías Utilizadas

- **Ruby on Rails 3.2.22**: Framework de desarrollo web para construir y estructurar la aplicación, facilitando la implementación de patrones de diseño MVC (Modelo-Vista-Controlador) y la gestión de bases de datos, vistas y controladores.

- **PostgreSQL**: Base de datos relacional que almacena de forma segura la información de la aplicación, como usuarios, productos y transacciones. La base de datos está configurada para persistir datos en un volumen Docker (postgres_data), lo que asegura su integridad en el entorno de desarrollo.

- **Docker**: Herramienta para contenerizar la aplicación, asegurando un entorno de desarrollo consistente y replicable en diferentes sistemas. Docker Compose se utiliza para orquestar múltiples servicios y ejecutar la configuración de la aplicación en conjunto.

  **Servicios en Docker Compose**:
    **Base de Datos (PostgreSQL)**: Utiliza la imagen postgres:9.6, configurada con las credenciales definidas en .env, y montada en el volumen postgres_data para la persistencia de datos.
    **Redis**: Servicio de almacenamiento en memoria, utilizado principalmente para manejar colas de trabajo en segundo plano, requerido por Sidekiq.
    **Aplicación (Rails)**: Contenedor que ejecuta el servidor de Rails en el puerto 3000, y sincroniza los archivos de la aplicación para reflejar cambios en el código sin necesidad de reconstruir el contenedor.
    **Sidekiq**: Ejecuta trabajos en segundo plano, como el envío de correos electrónicos y la generación de informes, conectándose a Redis para gestionar las tareas de manera eficiente.
    **Report-Cron**: Contenedor especial configurado para ejecutar automáticamente un worker de Sidekiq cada 24 horas, generando informes de compras y enviándolos a los administradores.
- **Sidekiq**: Gem que permite ejecutar trabajos en segundo plano (background jobs), esencial para manejar tareas que no necesitan procesarse en tiempo real, como el envío de correos electrónicos y el procesamiento de informes. Sidekiq utiliza Redis para gestionar la cola de trabajos en la aplicación, optimizando la ejecución de procesos largos o intensivos.

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

## Contribuciones

Si deseas contribuir a este proyecto, por favor realiza un fork del repositorio, crea una rama con tu función y luego realiza un pull request.
