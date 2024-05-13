import express from "express";
import morgan from "morgan";
import cors from "cors";
import { PORT } from "./config/config.js";
import index from "./routes/index_routes.js";
import user_service from "./routes/user_routes.js";
import bodyParser from "body-parser";
const app = express();
//Cors
var corsOptions = {
  origin: "*",
};

// Middlewares
app.use(morgan("dev"));
app.use(cors(corsOptions));
app.use(
  express.json({
    limit: "200mb",
  })
);
app.use(
  express.urlencoded({
    limit: "200mb",
    extended: true,
  })
);
app.use(
  express.text({
    limit: "200mb",
  })
);
// Routes
app.use("/", index);
app.use("/", user_service);

app.listen(PORT, () => {
  console.log(`Server on port http://localhost:${PORT}`);
});
