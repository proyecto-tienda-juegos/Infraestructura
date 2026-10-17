-- Crea una base de datos por microservicio (patron "database per service").
-- Se puede ejecutar a mano en MySQL Workbench o con la consola de MySQL,
-- o dejar que Docker la ejecute automaticamente (ver docker-compose.yml).

CREATE DATABASE IF NOT EXISTS usuario_db        CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS juegos_db         CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS inventario_db     CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS carrito_db        CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS notificaciones_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Las tablas NO se crean aqui: las crea Hibernate al arrancar cada
-- microservicio (spring.jpa.hibernate.ddl-auto=update).
