import { Router } from "express";
import {
    calcularRutaRapida,
    calcularRutaSegura,
  } from "../services/routesService.js";

const router = Router();

router.post("/Rapida", calcularRutaRapida);
router.post("/Segura", calcularRutaSegura);

export default router;