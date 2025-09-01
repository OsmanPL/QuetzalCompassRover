import { Router } from "express";
import {
    calcularRutaRapida,
    calcularRutaSegura,
    calcularRutaTiempo,
  } from "../services/routesService.js";

const router = Router();

router.post("/Rapida", calcularRutaRapida);
router.post("/Segura", calcularRutaSegura);
router.post("/Tiempo", calcularRutaTiempo);

export default router;
