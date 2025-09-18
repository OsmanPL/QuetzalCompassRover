import { validarToken } from "../config/config.js";

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

export const authenticate = async (req, res, next) => {
  try {
    const token = extractToken(req);
    if (!token) {
      return res.status(401).json({ success: false, message: "Token requerido" });
    }
    const decoded = await validarToken(token);
    if (!decoded) {
      return res.status(401).json({ success: false, message: "Token invalido" });
    }
    req.user = {
      id: Number(decoded.id) || decoded.id,
      tipo: decoded.tipo,
      correo: decoded.correo,
      nombre: decoded.nombre,
    };
    return next();
  } catch (error) {
    console.error("authenticate error", error);
    return res.status(401).json({ success: false, message: "No autorizado" });
  }
};
