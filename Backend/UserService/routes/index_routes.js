import { Router } from "express";
import { index } from "../services/index_service.js";

const router = Router();

router.get("/", index);

export default router;
