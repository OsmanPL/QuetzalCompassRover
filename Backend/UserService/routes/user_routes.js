import { Router } from "express";
import {
  registrarCliente,
  editarUsuario,
  obtenerUsuario,
  InicioSesion,
  registrarTransporte,
} from "../services/user_service.js";
import { authenticate } from "../middlewares/auth.js";

const router = Router();

router.get("/get/Usuario/:id?", authenticate, obtenerUsuario);
router.post("/update/User", authenticate, editarUsuario);
router.post("/Login", InicioSesion);
router.post("/Cliente/Registrar", registrarCliente);
router.post("/Transporte/Registrar", authenticate, registrarTransporte);

export default router;
