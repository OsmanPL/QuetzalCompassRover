import bcrypt from "bcryptjs";
import { crearToken, db } from "../config/config.js";

const ADMIN_TYPES = new Set([1, 2]);
const SALT_ROUNDS = 10;

function isAdmin(user) {
  const tipo = Number(user?.tipo);
  return ADMIN_TYPES.has(tipo);
}

function normalizeEmail(value) {
  if (!value) return "";
  return String(value).trim().toLowerCase();
}

function normalizeText(value) {
  if (!value && value !== 0) return "";
  return String(value).trim();
}

function sanitizePhone(value) {
  const raw = normalizeText(value);
  if (!raw) return "";
  return raw.replace(/[\s\-+().]/g, "");
}

function unwrapSingleRow(resultSets) {
  if (!Array.isArray(resultSets)) return null;
  const [first] = resultSets;
  if (Array.isArray(first)) return first[0] ?? null;
  return first ?? null;
}

function unwrapRows(resultSets) {
  if (!Array.isArray(resultSets)) return [];
  const [first] = resultSets;
  return Array.isArray(first) ? first : [];
}

function hashPassword(plain) {
  return new Promise((resolve, reject) => {
    bcrypt.hash(String(plain), SALT_ROUNDS, (err, hash) => {
      if (err) return reject(err);
      return resolve(hash);
    });
  });
}

function comparePassword(plain, hash) {
  return new Promise((resolve, reject) => {
    bcrypt.compare(String(plain), String(hash), (err, same) => {
      if (err) return reject(err);
      return resolve(Boolean(same));
    });
  });
}

export const registrarCliente = async (req, res) => {
  try {
    const { nombre, usuario, pass, correo, cel, tipo } = req.body || {};

    const email = normalizeEmail(correo);
    const username = normalizeText(usuario);
    const rawPassword = normalizeText(pass);
    const displayName = normalizeText(nombre) || username;
    const phone = sanitizePhone(cel);
    const tipoUsuario = Number.isInteger(Number(tipo)) ? Number(tipo) : 2;

    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      return res.status(400).json({ success: false, message: "Correo invalido" });
    }
    if (!username || username.length < 3) {
      return res.status(400).json({ success: false, message: "Usuario invalido" });
    }
    if (!rawPassword || rawPassword.length < 8) {
      return res
        .status(400)
        .json({ success: false, message: "La contrasena debe tener al menos 8 caracteres" });
    }
    if (!phone) {
      return res.status(400).json({ success: false, message: "Celular requerido" });
    }

    const [correoResult] = await db.query("CALL getCorreo(?)", [email]);
    const correoRow = unwrapSingleRow(correoResult);
    if ((correoRow?.total ?? 0) > 0) {
      return res.status(409).json({ success: false, message: "Correo existente" });
    }

    const hashedPassword = await hashPassword(rawPassword);
    await db.query("CALL insertClient(?, ?, ?, ?, ?, ?)", [
      displayName,
      username,
      hashedPassword,
      email,
      phone,
      tipoUsuario,
    ]);

    return res.status(201).json({ success: true, message: "Usuario registrado exitosamente." });
  } catch (error) {
    console.error("registrarCliente error", error);
    const sqlMessage = error?.sqlMessage || error?.message;
    if (error?.sqlState === "45000") {
      return res.status(400).json({ success: false, message: sqlMessage });
    }
    if (error?.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ success: false, message: "Usuario o telefono ya existe" });
    }
    return res.status(500).json({ success: false, message: "Ocurrio un error inesperado" });
  }
};

export const registrarTransporte = async (req, res) => {
  try {
    const requester = req.user;
    if (!requester || !isAdmin(requester)) {
      return res.status(403).json({ success: false, message: "Acceso denegado" });
    }

    const { tipo, ruta, piloto } = req.body || {};
    const tipoId = Number(tipo);
    const rutaId = Number(ruta);
    if (!Number.isInteger(tipoId) || tipoId <= 0) {
      return res.status(400).json({ success: false, message: "Tipo de transporte invalido" });
    }
    if (!Number.isInteger(rutaId) || rutaId <= 0) {
      return res.status(400).json({ success: false, message: "Ruta invalida" });
    }

    let pilotoId = null;
    const pilotoRef = normalizeText(piloto);
    if (pilotoRef) {
      const [pilotoResult] = await db.query("CALL getPiloto(?)", [pilotoRef]);
      const pilotoRow = unwrapSingleRow(pilotoResult);
      if (!pilotoRow?.id) {
        return res.status(400).json({ success: false, message: "Piloto no encontrado" });
      }
      pilotoId = Number(pilotoRow.id);
    }

    const [insertResult] = await db.query("CALL insertTransport(?, ?, ?)", [
      tipoId,
      rutaId,
      pilotoId,
    ]);
    const insertRow = unwrapSingleRow(insertResult);

    return res.status(201).json({
      success: true,
      message: "Transporte registrado exitosamente.",
      id: insertRow?.id ?? null,
    });
  } catch (error) {
    console.error("registrarTransporte error", error);
    if (error?.sqlState === "45000") {
      return res.status(400).json({ success: false, message: error.sqlMessage });
    }
    if (error?.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ success: false, message: "Ruta ya registrada" });
    }
    return res.status(500).json({ success: false, message: "Ocurrio un error inesperado" });
  }
};

export const editarUsuario = async (req, res) => {
  try {
    const requester = req.user;
    if (!requester) {
      return res.status(401).json({ resultado: "No autorizado" });
    }

    const {
      idCliente,
      nombre,
      apellido = "",
      telefono = "",
      direccion = "",
      password = "",
    } = req.body || {};

    const targetId = Number(idCliente ?? requester.id);
    if (!Number.isInteger(targetId) || targetId <= 0) {
      return res.status(400).json({ resultado: "Id invalido" });
    }

    const admin = isAdmin(requester);
    if (!admin && Number(requester.id) !== targetId) {
      return res.status(403).json({ resultado: "Acceso denegado" });
    }

    const [userRows] = await db.query("CALL getIdUser(?)", [targetId]);
    const targetUser = unwrapSingleRow(userRows);
    if (!targetUser) {
      return res.status(404).json({ resultado: "Usuario no encontrado" });
    }

    const firstName = normalizeText(nombre) || targetUser.Nombre || "";
    const lastName = normalizeText(apellido);
    const phone = sanitizePhone(telefono);
    const address = normalizeText(direccion);

    let hashedPassword = null;
    const trimmedPassword = normalizeText(password);
    if (trimmedPassword) {
      if (trimmedPassword.length < 8) {
        return res.status(400).json({ resultado: "La contrasena debe tener al menos 8 caracteres" });
      }
      hashedPassword = await hashPassword(trimmedPassword);
    }

    await db.query("CALL updateUser(?, ?, ?, ?, ?, ?)", [
      targetId,
      firstName,
      lastName,
      phone,
      address,
      hashedPassword,
    ]);

    return res.status(200).json({ resultado: "Usuario actualizado exitosamente." });
  } catch (error) {
    console.error("editarUsuario error", error);
    if (error?.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ resultado: "Telefono ya registrado" });
    }
    if (error?.sqlState === "45000") {
      return res.status(400).json({ resultado: error.sqlMessage });
    }
    return res.status(500).json({ resultado: "Ocurrio un error inesperado" });
  }
};

export const InicioSesion = async (req, res) => {
  try {
    const { correo, pass } = req.body || {};
    const email = normalizeEmail(correo);
    const rawPassword = normalizeText(pass);

    if (!email || !rawPassword) {
      return res.status(400).json({ success: false, message: "Credenciales requeridas" });
    }

    const [resultSets] = await db.query("CALL getUserByEmail(?)", [email]);
    const row = unwrapSingleRow(resultSets);
    if (!row?.password_hash) {
      return res.status(400).json({ success: false, message: "Contrasena o correo incorrectos" });
    }

    const isValid = await comparePassword(rawPassword, row.password_hash);
    if (!isValid) {
      return res.status(400).json({ success: false, message: "Contrasena o correo incorrectos" });
    }

    const payload = {
      id: row.id_usuario,
      correo: row.email,
      nombre: row.nombre ?? row.Username,
      tipo: row.Tipo_Usuario,
    };

    const token = crearToken(payload);
    return res.status(200).json({
      success: true,
      message: "Inicio de sesion exitoso.",
      token,
      user: payload,
      expiresIn: 24 * 60 * 60,
    });
  } catch (error) {
    console.error("InicioSesion error", error);
    return res.status(500).json({ success: false, message: "Ocurrio un error inesperado" });
  }
};

export const obtenerUsuario = async (req, res) => {
  try {
    const requester = req.user;
    if (!requester) {
      return res.status(401).json({ resultado: "No autorizado" });
    }

    const requestedParam = req.params?.id;
    const targetId = Number(requestedParam ?? requester.id);
    if (!Number.isInteger(targetId) || targetId <= 0) {
      return res.status(400).json({ resultado: "Id invalido" });
    }

    const admin = isAdmin(requester);
    if (!admin && Number(requester.id) !== targetId) {
      return res.status(403).json({ resultado: "Acceso denegado" });
    }

    const [userRows] = await db.query("CALL getUserid(?)", [targetId]);
    const data = unwrapRows(userRows);
    return res.status(200).json({
      resultado: "Cliente obtenido exitosamente.",
      data,
    });
  } catch (error) {
    console.error("obtenerUsuario error", error);
    return res.status(500).json({ resultado: "Ocurrio un error inesperado" });
  }
};


