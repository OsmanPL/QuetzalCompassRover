import { Router } from "express";
import {
    calcularRutaRapida,
    calcularRutaSegura,
    calcularRutaTiempo,
  } from "../services/routesService.js";
import { authenticate } from "../middlewares/auth.js";

const router = Router();

router.use(authenticate);

router.post("/Rapida", calcularRutaRapida);
router.post("/Segura", calcularRutaSegura);
router.post("/Tiempo", calcularRutaTiempo);

export default router;
