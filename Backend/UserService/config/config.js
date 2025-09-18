import { config } from "dotenv";
import { createPool } from "mysql2/promise";
import jwt from "jsonwebtoken";
import { Storage } from "@google-cloud/storage";

config();

// Base de datos
export const DB_HOST = process.env.DB_HOST;
export const DB_USER = process.env.DB_USER;
export const DB_PASSWORD = process.env.DB_PASSWORD;
export const DB_DATABASE = process.env.DB_DATABASE;
export const DB_PORT = process.env.DB_PORT;
export const PORT = process.env.PORT || 3000;
export const SECRET = process.env.SECRET;

// Crear de base de datos mysql
export const db = createPool({
  host: DB_HOST,
  user: DB_USER,
  password: DB_PASSWORD,
  port: DB_PORT,
  database: DB_DATABASE,
});

export const crearToken = ({ id, tipo, correo, nombre }) => {
  const payload = { id, tipo };
  if (correo) payload.correo = correo;
  if (nombre) payload.nombre = nombre;
  const token = jwt.sign(payload, SECRET, {
    expiresIn: "24h",
  });
  return token;
};

export const crearTokenProv = ({ id, tipo }) => {
  return crearToken({ id, tipo });
};

export const validarToken = async (token) => {
  try {
    const decoded = jwt.verify(token, SECRET);
    return decoded;
  } catch (error) {
    console.log(error);
    return null;
  }
};

export const storage = new Storage({
  keyFilename: "./key.json",
});
