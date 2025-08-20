import express from "express";
import morgan from "morgan";
import cors from "cors";
import { PORT } from "./config/config.js";
import routesRoute from "./routes/routesServiceRoute.js";
import { inicializarGrafo } from "./services/routesService.js"; // 👈 IMPORTAR FUNCIÓN

const app = express();

const corsOptions = {
  origin: "*",
};

// Middlewares
app.use(morgan("dev"));
app.use(cors(corsOptions));
app.use(express.json({ limit: "200mb" }));
app.use(express.urlencoded({ extended: true, limit: "200mb" }));
app.use(express.text({ limit: "200mb" }));

app.get("/", (req, res) => {
  res.send("Bienvenido a la API de Routes Service");
});

app.use("/ruta", routesRoute);

async function main() {
  console.log("Inicializando grafo...");
  await inicializarGrafo(); // 👈 LLAMAR FUNCIÓN UNA VEZ
  console.log("Grafo cargado correctamente.");

  app.listen(PORT, () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
  });
}

main();
