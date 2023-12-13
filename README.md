# Api-dummyJson - Shopify

## Uso de la aplicación dockerizada:

### Requisitos:

- Docker-compose (ver 2.4)
- Docker
- Puertos a usar:
    - 8084 => aplicación de Spring
    - 8085 => phpMyAdmin para ver los datos
    - 3307 => MySQL

Los 3 servicios se ejecutan dentro de una misma sub-red. Para visualizarla, puede ejecutar: `docker network inspect apidummyjson_shopify-network`

Arranque de los servicios utilizando el script:

```shell
 ❯ sudo ./buildLinux.sh      

Usage: ./buildLinux.sh [compile|rebuild|start|full|clean|help]

  compile - Compile the project into the .jar (using Maven inside the container).
  local   - Compile the .jar and run it without containers.
  rebuild - Build the Docker image.
  start   - Configure MySQL and then start the application using Docker Compose.
  full    - Perform a full build and then start the application.
  clean   - Stop and remove Docker containers.
  help    - Display this help message.
```

## Advertencia: Para la primera vez que se ejecuta siempre usar el script

```shell
sudo ./buildLinux.sh full
```

Esto hará que en la carpeta /opt/dummy-shopify/mysql-data se cargue la data. En caso nuestro contenedor muera, podremos recuperarla.

Para "reanudar" nuestro sistema en caso lo hayamos detenido con CTRL + C, podemos ejecutar:

```shell
sudo ./buildLinux.sh start
```

### Puertos en uso:

Puertos y URL usadas en esta APP:

    http://localhost:8084 => Para ingresar al servicio de Spring
    http://localhost:8085 => Para ingresar al phpMyAdmin y controlar la db, las credenciales están dentro del .env
    http://localhost:3307 => Ingreso a la db MySQL igual, las credenciales están en el .env

### Recuperación de la data

Como mencioné, este contenedor persiste nuestros datos.

Para ingresar a estos, están en el path de nuestro servidor: /opt/dummy-shopify/mysql-data

Luego, en la carpeta usuarios, encontraremos el backup:

```shell
[root@server mysql-data]# ls
 auto.cnf        binlog.000003   binlog.000006   ca-key.pem        client-key.pem       ib_buffer_pool  '#innodb_redo'   mysql.ibd            private_key.pem   server-key.pem   undo_002
 binlog.000001   binlog.000004   binlog.000007   ca.pem           '#ib_16384_0.dblwr'   ibdata1         '#innodb_temp'   mysql.sock           public_key.pem    sys              usuarios
 binlog.000002   binlog.000005   binlog.index    client-cert.pem  '#ib_16384_1.dblwr'   ibtmp1           mysql           performance_schema   server-cert.pem   undo_001
[root@server mysql-data]# cd usuarios/
[root@server usuarios]# ls
usuarios.ibd
```


### Recuperación de la base de datos

Para hacer un backup de la base de datos y guardarlo en un archivo SQL, puedes utilizar el siguiente comando:

```shell
mysqldump -u TU_USUARIO -pTU_CONTRASEÑA NOMBRE_DE_LA_BASE_DE_DATOS > backup.sql
```

Guarda este archivo de manera segura, ya que contiene datos sensibles.

Para restaurar la base de datos desde el archivo de respaldo, puedes utilizar el siguiente comando:

```shell
mysql -u TU_USUARIO -pTU_CONTRASEÑA NOMBRE_DE_LA_BASE_DE_DATOS < backup.sql
```


Reemplaza TU_USUARIO, TU_CONTRASEÑA, y NOMBRE_DE_LA_BASE_DE_DATOS con tus credenciales y detalles de la base de datos. 
Este comando restaurará la base de datos desde el archivo de respaldo.