-- Stored Procedures for Destinations (HistorialDestino, FavoritoDestino)
-- Run this after creating tables in quetzalCompassRoverDB.sql

DELIMITER $$

-- Listar historial por usuario con lÃ­mite
DROP PROCEDURE IF EXISTS sp_list_history $$
CREATE PROCEDURE sp_list_history(IN p_usuario INT, IN p_limit INT)
BEGIN
  SELECT 
    id_historial AS id,
    usuario,
    nombre,
    direccion,
    latitud,
    longitud,
    creado_en
  FROM HistorialDestino
  WHERE usuario = p_usuario
  ORDER BY creado_en DESC, id_historial DESC
  LIMIT p_limit;
END $$

-- Agregar entrada de historial y devolver id insertado
DROP PROCEDURE IF EXISTS sp_add_history $$
CREATE PROCEDURE sp_add_history(
  IN p_usuario INT,
  IN p_nombre VARCHAR(100),
  IN p_direccion TEXT,
  IN p_latitud DOUBLE,
  IN p_longitud DOUBLE
)
BEGIN
  INSERT INTO HistorialDestino (usuario, nombre, direccion, latitud, longitud)
  VALUES (p_usuario, p_nombre, p_direccion, p_latitud, p_longitud);
  SELECT LAST_INSERT_ID() AS id;
END $$

-- Eliminar entrada de historial (propiedad del usuario) y devolver afectados
DROP PROCEDURE IF EXISTS sp_delete_history $$
CREATE PROCEDURE sp_delete_history(IN p_id INT, IN p_usuario INT)
BEGIN
  DELETE FROM HistorialDestino WHERE id_historial = p_id AND usuario = p_usuario;
  SELECT ROW_COUNT() AS affected;
END $$

-- Listar favoritos por usuario
DROP PROCEDURE IF EXISTS sp_list_favorites $$
CREATE PROCEDURE sp_list_favorites(IN p_usuario INT)
BEGIN
  SELECT 
    id_favorito AS id,
    usuario,
    nombre,
    direccion,
    latitud,
    longitud,
    creado_en
  FROM FavoritoDestino
  WHERE usuario = p_usuario
  ORDER BY creado_en DESC, id_favorito DESC;
END $$

-- Agregar favorito evitando duplicados por (usuario, latitud, longitud)
-- Devuelve el id y si fue duplicado (duplicate = 1)
DROP PROCEDURE IF EXISTS sp_add_favorite $$
CREATE PROCEDURE sp_add_favorite(
  IN p_usuario INT,
  IN p_nombre VARCHAR(100),
  IN p_direccion TEXT,
  IN p_latitud DOUBLE,
  IN p_longitud DOUBLE
)
BEGIN
  DECLARE v_id INT;
  SELECT id_favorito INTO v_id
  FROM FavoritoDestino
  WHERE usuario = p_usuario AND latitud = p_latitud AND longitud = p_longitud
  LIMIT 1;

  IF v_id IS NULL THEN
    INSERT INTO FavoritoDestino (usuario, nombre, direccion, latitud, longitud)
    VALUES (p_usuario, p_nombre, p_direccion, p_latitud, p_longitud);
    SET v_id = LAST_INSERT_ID();
    SELECT v_id AS id, 0 AS duplicate;
  ELSE
    SELECT v_id AS id, 1 AS duplicate;
  END IF;
END $$

-- Eliminar favorito (propiedad del usuario) y devolver afectados
DROP PROCEDURE IF EXISTS sp_delete_favorite $$
CREATE PROCEDURE sp_delete_favorite(IN p_id INT, IN p_usuario INT)
BEGIN
  DELETE FROM FavoritoDestino WHERE id_favorito = p_id AND usuario = p_usuario;
  SELECT ROW_COUNT() AS affected;
END $$

-- UserService procedures (Usuario y Perfil)
DROP PROCEDURE IF EXISTS getCorreo $$
CREATE PROCEDURE getCorreo(IN p_correo VARCHAR(100))
BEGIN
  SELECT COUNT(*) AS total
  FROM Usuario
  WHERE LOWER(Email) = LOWER(p_correo);
END $$

DROP PROCEDURE IF EXISTS insertClient $$
CREATE PROCEDURE insertClient(
  IN p_nombre VARCHAR(255),
  IN p_username VARCHAR(50),
  IN p_password VARCHAR(255),
  IN p_correo VARCHAR(100),
  IN p_cel VARCHAR(25),
  IN p_tipo INT
)
BEGIN
  DECLARE v_user_id INT;
  DECLARE v_nombre TEXT;
  DECLARE v_celular VARCHAR(25);
  DECLARE v_telefono BIGINT;
  DECLARE v_foto TEXT DEFAULT 'default-avatar.png';

  SET v_nombre = NULLIF(TRIM(p_nombre), '');
  IF v_nombre IS NULL THEN
    SET v_nombre = TRIM(p_username);
  END IF;

  SET v_celular = REPLACE(TRIM(COALESCE(p_cel, '')), ' ', '');
  SET v_celular = REPLACE(v_celular, '-', '');
  SET v_celular = REPLACE(v_celular, '+', '');
  SET v_celular = REPLACE(v_celular, '(', '');
  SET v_celular = REPLACE(v_celular, ')', '');
  SET v_celular = REPLACE(v_celular, '.', '');

  IF v_celular = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Telefono requerido';
  END IF;

  SET v_telefono = CAST(v_celular AS UNSIGNED);

  INSERT INTO Usuario (Username, Password, Email, Telefono, Tipo_Usuario)
  VALUES (TRIM(p_username), p_password, TRIM(p_correo), v_telefono, p_tipo);

  SET v_user_id = LAST_INSERT_ID();

  INSERT INTO Perfil (Nombre, Foto, Usuario)
  VALUES (v_nombre, v_foto, v_user_id);

  SELECT v_user_id AS id;
END $$

DROP PROCEDURE IF EXISTS getPiloto $$
CREATE PROCEDURE getPiloto(IN p_piloto VARCHAR(100))
BEGIN
  DECLARE v_tipo_piloto INT;
  DECLARE v_param VARCHAR(100);

  SELECT id_TipoUsuario
  INTO v_tipo_piloto
  FROM TipoUsuario
  WHERE LOWER(Tipo) = 'piloto'
  LIMIT 1;

  IF v_tipo_piloto IS NULL THEN
    SET v_tipo_piloto = 3;
  END IF;

  SET v_param = TRIM(COALESCE(p_piloto, ''));

  IF v_param = '' THEN
    SELECT NULL AS id;
  ELSEIF v_param REGEXP '^[0-9]+$' THEN
    SELECT id_usuario AS id
    FROM Usuario
    WHERE id_usuario = CAST(v_param AS UNSIGNED)
      AND Tipo_Usuario = v_tipo_piloto
    LIMIT 1;
  ELSE
    SELECT id_usuario AS id
    FROM Usuario
    WHERE (LOWER(Email) = LOWER(v_param) OR LOWER(Username) = LOWER(v_param))
      AND Tipo_Usuario = v_tipo_piloto
    LIMIT 1;
  END IF;
END $$

DROP PROCEDURE IF EXISTS getIdUser $$
CREATE PROCEDURE getIdUser(IN p_id INT)
BEGIN
  SELECT 
    u.id_usuario,
    u.Username,
    u.Email,
    u.Telefono,
    u.Tipo_Usuario,
    p.Nombre,
    p.Foto
  FROM Usuario u
  LEFT JOIN Perfil p ON p.Usuario = u.id_usuario
  WHERE u.id_usuario = p_id
  LIMIT 1;
END $$

DROP PROCEDURE IF EXISTS getUserid $$
CREATE PROCEDURE getUserid(IN p_id INT)
BEGIN
  SELECT 
    u.id_usuario AS id,
    u.Username AS username,
    u.Email AS correo,
    u.Telefono AS telefono,
    u.Tipo_Usuario AS tipo,
    p.Nombre AS nombre,
    p.Foto AS foto
  FROM Usuario u
  LEFT JOIN Perfil p ON p.Usuario = u.id_usuario
  WHERE u.id_usuario = p_id;
END $$

DROP PROCEDURE IF EXISTS updateUser $$
CREATE PROCEDURE updateUser(
  IN p_id INT,
  IN p_nombre VARCHAR(255),
  IN p_apellido VARCHAR(255),
  IN p_telefono VARCHAR(25),
  IN p_direccion TEXT,
  IN p_password VARCHAR(255)
)
BEGIN
  DECLARE v_nombre TEXT;
  DECLARE v_celular VARCHAR(25);
  DECLARE v_telefono BIGINT;
  DECLARE v_password VARCHAR(255);

  SET v_nombre = TRIM(CONCAT(COALESCE(p_nombre, ''), ' ', COALESCE(p_apellido, '')));
  IF v_nombre <> '' THEN
    IF EXISTS (SELECT 1 FROM Perfil WHERE Usuario = p_id) THEN
      UPDATE Perfil
      SET Nombre = v_nombre
      WHERE Usuario = p_id;
    ELSE
      INSERT INTO Perfil (Nombre, Foto, Usuario)
      VALUES (v_nombre, 'default-avatar.png', p_id);
    END IF;
  END IF;

  IF p_telefono IS NOT NULL AND TRIM(p_telefono) <> '' THEN
    SET v_celular = REPLACE(TRIM(p_telefono), ' ', '');
    SET v_celular = REPLACE(v_celular, '-', '');
    SET v_celular = REPLACE(v_celular, '+', '');
    SET v_celular = REPLACE(v_celular, '(', '');
    SET v_celular = REPLACE(v_celular, ')', '');
    SET v_celular = REPLACE(v_celular, '.', '');
    SET v_telefono = CAST(v_celular AS UNSIGNED);
    UPDATE Usuario
    SET Telefono = v_telefono
    WHERE id_usuario = p_id;
  END IF;

  SET v_password = NULLIF(TRIM(COALESCE(p_password, '')), '');
  IF v_password IS NOT NULL THEN
    UPDATE Usuario
    SET Password = v_password
    WHERE id_usuario = p_id;
  END IF;

  SELECT 
    u.id_usuario AS id,
    u.Username AS username,
    u.Email AS correo,
    u.Telefono AS telefono,
    u.Tipo_Usuario AS tipo,
    p.Nombre AS nombre,
    p.Foto AS foto
  FROM Usuario u
  LEFT JOIN Perfil p ON p.Usuario = u.id_usuario
  WHERE u.id_usuario = p_id;
END $$

DROP PROCEDURE IF EXISTS getUserByEmail $$
CREATE PROCEDURE getUserByEmail(IN p_correo VARCHAR(100))
BEGIN
  SELECT 
    u.id_usuario,
    u.Username,
    u.Email AS email,
    u.Password AS password_hash,
    u.Tipo_Usuario,
    p.Nombre AS nombre
  FROM Usuario u
  LEFT JOIN Perfil p ON p.Usuario = u.id_usuario
  WHERE LOWER(u.Email) = LOWER(TRIM(p_correo))
  LIMIT 1;
END $$
DROP PROCEDURE IF EXISTS insertTransport $$
CREATE PROCEDURE insertTransport(
  IN p_tipo INT,
  IN p_ruta INT,
  IN p_piloto INT
)
BEGIN
  DECLARE v_exists INT DEFAULT 0;

  IF p_tipo IS NULL OR p_ruta IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo y ruta son requeridos';
  END IF;

  SELECT COUNT(*) INTO v_exists
  FROM Transporte
  WHERE Ruta = p_ruta;

  IF v_exists > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ruta ya registrada';
  END IF;

  INSERT INTO Transporte (Tipo_Transporte, Ruta, Piloto)
  VALUES (p_tipo, p_ruta, p_piloto);

  SELECT LAST_INSERT_ID() AS id;
END $$
DELIMITER ;








