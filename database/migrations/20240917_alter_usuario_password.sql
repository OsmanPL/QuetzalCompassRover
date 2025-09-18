-- Ajustes de esquema para soportar contrasenas con bcrypt
-- Ejecutar en la base de datos principal antes de recargar los procedimientos

ALTER TABLE Usuario
  MODIFY COLUMN Password VARCHAR(100) NOT NULL,
  MODIFY COLUMN Telefono BIGINT NOT NULL UNIQUE;

-- Vuelva a cargar los procedimientos almacenados actualizados
SOURCE stored_procedures.sql;
