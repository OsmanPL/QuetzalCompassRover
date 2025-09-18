import express from "express";
import morgan from "morgan";
import cors from "cors";
import { PORT } from "./config/config.js";
import destinationsRoutes from "./routes/destinations_routes.js";

const app = express();

const corsOptions = { origin: "*" };
app.use(morgan("dev"));
app.use(cors(corsOptions));
app.use(express.json({ limit: "20mb" }));
app.use(express.urlencoded({ extended: true, limit: "20mb" }));

app.get("/", (_req, res) => {
  res.send("Destinations Service OK");
});

app.use("/", destinationsRoutes);

app.listen(PORT, () => {
  console.log(`Destinations Service on http://localhost:${PORT}`);
});

