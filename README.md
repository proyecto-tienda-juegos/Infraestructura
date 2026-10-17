# infra

Contiene la infraestructura compartida del sistema: el servidor de registro (Eureka) y el punto de entrada único (API Gateway).

```
infra/
 ├── eureka-server/   # puerto 8761 - registro y descubrimiento de servicios
 └── api-gateway/     # puerto 8080 - enruta las peticiones hacia cada microservicio
```

## Orden para levantar el sistema

El orden importa: Eureka tiene que estar arriba antes que el resto, o los demás no tendrán dónde registrarse.

1. **Eureka Server** (primero, siempre):
   ```bash
   cd eureka-server
   mvn spring-boot:run
   ```
   Verifica que quedó arriba entrando a `http://localhost:8761` — deberías ver el panel de Eureka (por ahora sin instancias registradas).

2. **API Gateway** (segundo):
   ```bash
   cd api-gateway
   mvn spring-boot:run
   ```

3. **Microservicios de negocio** (Usuario, Juegos, Inventario, Carrito, Notificaciones): cada uno después, en el orden que quieras.

## ⚠️ Importante: a cada microservicio le falta registrarse en Eureka

El `usuario-service` que armamos antes todavía **no sabe que Eureka existe**. Para que aparezca en `http://localhost:8761` y el Gateway pueda enrutarle peticiones, a **cada** microservicio (Usuario, Juegos, Inventario, Carrito, Notificaciones) hay que agregarle:

**1. En el `pom.xml`**, el mismo bloque `spring-cloud.version` + `dependencyManagement` que tiene este `eureka-server`, y esta dependencia:

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

**2. En su `application.properties`**, agregar al final:

```properties
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

(El `spring.application.name` que ya tiene cada uno, por ejemplo `usuario-service`, es justo el nombre que el Gateway usa en sus rutas `lb://usuario-service`, así que no hay que tocarlo.)

## Verificar que todo quedó conectado

1. Entra a `http://localhost:8761` → deberías ver `USUARIO-SERVICE`, `JUEGOS-SERVICE`, etc. en la lista de instancias registradas.
2. Prueba en Postman pegándole directo al Gateway en vez de al microservicio:
   `GET http://localhost:8080/api/usuarios` (en vez de `http://localhost:8081/api/usuarios`)

## Kafka

El archivo `docker-compose.yml` levanta un broker Kafka en `localhost:9092` (necesita Docker instalado):

```bash
docker compose up -d      # levantar
docker compose down       # detener
```

Debe estar arriba **antes** de iniciar `carrito-service` y `notificaciones-service`.

## Bases de datos

Cada microservicio tiene su propia base de datos:

| Microservicio | Base de datos |
|---|---|
| usuario-service | `usuario_db` |
| juegos-service | `juegos_db` |
| inventario-service | `inventario_db` |
| carrito-service | `carrito_db` |
| notificaciones-service | `notificaciones_db` |

Dos formas de crearlas (elige una):

1. **Con Docker**: `docker compose up -d` levanta MySQL y ejecuta `mysql/init.sql` automáticamente. El usuario es `root` y la contraseña `root1234`: ponla en `spring.datasource.password` de cada microservicio. Si ya tienes MySQL instalado en tu PC, cambia el puerto en `docker-compose.yml` (ver comentario) para que no choquen.
2. **Sin Docker**: abre `mysql/init.sql` en MySQL Workbench y ejecútalo contra tu MySQL local.

Solo se crean las bases de datos vacías; las tablas las crea Hibernate al arrancar cada microservicio.

El **API Gateway no tiene base de datos**: solo enruta peticiones, no guarda datos.
