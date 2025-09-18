import jwt from "jsonwebtoken";
import { SECRET } from "../config/config.js";

function extractToken(req) {
  const header = req.headers?.authorization || req.headers?.Authorization;
  if (!header) return null;
  const parts = header.split(" ");
  if (parts.length === 2 && /^Bearer$/i.test(parts[0])) {
    return parts[1];
  }
  if (parts.length === 1) {
    return parts[0];
  }
  return null;
}

export function authenticate(req, res, next) {
  try {
    const token = extractToken(req);
    if (!token) {
      return res.status(401).json({ error: "Token requerido" });
    }
    const decoded = jwt.verify(token, SECRET);
    req.user = {
      id: Number(decoded.id) || decoded.id,
      tipo: decoded.tipo,
      correo: decoded.correo,
      nombre: decoded.nombre,
    };
    return next();
  } catch (err) {
    console.error("routes auth", err?.message || err);
    return res.status(401).json({ error: "Token invalido" });
  }
}
