import { db } from "../config/config.js";

function getUserId(req) {
  const id = Number(req.user?.id);
  if (!Number.isInteger(id) || id <= 0) return null;
  return id;
}

export const listHistory = async (req, res) => {
  try {
    const userId = getUserId(req);
    if (!userId) return res.status(401).json({ error: "Usuario no autorizado" });
    const limit = Math.min(Number(req.query.limit) || 50, 200);
    const [resultSets] = await db.query('CALL sp_list_history(?, ?)', [userId, limit]);
    const rows = Array.isArray(resultSets) ? resultSets[0] ?? [] : [];
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al obtener historial" });
  }
};

export const addHistory = async (req, res) => {
  try {
    const userId = getUserId(req);
    if (!userId) return res.status(401).json({ error: "Usuario no autorizado" });
    const { nombre, direccion, latitud, longitud } = req.body || {};
    if (typeof latitud !== "number" || typeof longitud !== "number") {
      return res.status(400).json({ error: "latitud/longitud requeridas" });
    }
    const [resultSets] = await db.query('CALL sp_add_history(?, ?, ?, ?, ?)', [
      userId,
      nombre || null,
      direccion || null,
      latitud,
      longitud,
    ]);
    const insertedRow = Array.isArray(resultSets) && resultSets[0] ? resultSets[0][0] : null;
    const id = insertedRow?.id ?? null;
    res.status(201).json({ id, usuario: userId, nombre, direccion, latitud, longitud });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al registrar en historial" });
  }
};

export const deleteHistory = async (req, res) => {
  try {
    const userId = getUserId(req);
    const historyId = Number(req.params.id);
    if (!userId) return res.status(401).json({ error: "Usuario no autorizado" });
    if (!Number.isInteger(historyId) || historyId <= 0) {
      return res.status(400).json({ error: "Parametros invalidos" });
    }
    const [resultSets] = await db.query('CALL sp_delete_history(?, ?)', [historyId, userId]);
    const metaRow = Array.isArray(resultSets) && resultSets[0] ? resultSets[0][0] : null;
    const affected = metaRow?.affected ?? 0;
    res.json({ deleted: affected > 0 });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al eliminar del historial" });
  }
};

export const listFavorites = async (req, res) => {
  try {
    const userId = getUserId(req);
    if (!userId) return res.status(401).json({ error: "Usuario no autorizado" });
    const [resultSets] = await db.query('CALL sp_list_favorites(?)', [userId]);
    const rows = Array.isArray(resultSets) ? resultSets[0] ?? [] : [];
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al obtener favoritos" });
  }
};

export const addFavorite = async (req, res) => {
  try {
    const userId = getUserId(req);
    if (!userId) return res.status(401).json({ error: "Usuario no autorizado" });
    const { nombre, direccion, latitud, longitud } = req.body || {};
    if (typeof latitud !== "number" || typeof longitud !== "number") {
      return res.status(400).json({ error: "latitud/longitud requeridas" });
    }
    const [resultSets] = await db.query('CALL sp_add_favorite(?, ?, ?, ?, ?)', [
      userId,
      nombre || null,
      direccion || null,
      latitud,
      longitud,
    ]);
    const row = Array.isArray(resultSets) && resultSets[0] ? resultSets[0][0] : null;
    const id = row?.id ?? null;
    const duplicate = row?.duplicate === 1;
    const status = duplicate ? 200 : 201;
    res.status(status).json({ id, usuario: userId, nombre, direccion, latitud, longitud, duplicate });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al agregar favorito" });
  }
};

export const deleteFavorite = async (req, res) => {
  try {
    const userId = getUserId(req);
    const favoriteId = Number(req.params.id);
    if (!userId) return res.status(401).json({ error: "Usuario no autorizado" });
    if (!Number.isInteger(favoriteId) || favoriteId <= 0) {
      return res.status(400).json({ error: "Parametros invalidos" });
    }
    const [resultSets] = await db.query('CALL sp_delete_favorite(?, ?)', [favoriteId, userId]);
    const metaRow = Array.isArray(resultSets) && resultSets[0] ? resultSets[0][0] : null;
    const affected = metaRow?.affected ?? 0;
    res.json({ deleted: affected > 0 });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al eliminar favorito" });
  }
};
