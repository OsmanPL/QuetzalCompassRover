import { Router } from "express";
import {
  registrarCliente,
  editarUsuario,
  obtenerUsuario,
  InicioSesion,
  registrarTransporte,
} from "../services/user_service.js";

const router = Router();

router.get("/get/Usuario/:id", obtenerUsuario);
router.post("/update/User", editarUsuario);
router.post("/Login", InicioSesion);
router.post("/Cliente/Registrar", registrarCliente);
router.post("/Transporte/Registrar", registrarTransporte);

export default router;
