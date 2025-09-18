import { Router } from "express";
import {
  listHistory,
  addHistory,
  deleteHistory,
  listFavorites,
  addFavorite,
  deleteFavorite,
} from "../services/destinations_service.js";
import { authenticate } from "../middlewares/auth.js";

const router = Router();

router.use(authenticate);

// Historial
router.get("/user/history", listHistory);
router.post("/user/history", addHistory);
router.delete("/user/history/:id", deleteHistory);

// Favoritos
router.get("/user/favorites", listFavorites);
router.post("/user/favorites", addFavorite);
router.delete("/user/favorites/:id", deleteFavorite);

export default router;

