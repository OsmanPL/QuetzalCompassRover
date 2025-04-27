import { Router } from "express";
import {
    calcularRutaMasRapida,
    calcularRutaMasSegura,
  } from "../services/routesService.js";

const router = Router();

router.post("/Rapida", calcularRutaMasRapida);
router.post("/Segura", calcularRutaMasSegura);

export default router;