import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import memberRoutes from "./routes/member_routes";
import variablesRoutes from "./routes/form_variables";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5001;

//app.use(cors());
app.use(cors({ origin: "*" }));

app.use(express.json());

mongoose
  .connect(process.env.MONGO_URI as string)
  .then(() => console.log("MongoDB Bağlandı"))
  .catch((err) => console.error(err));

app.use("/member", memberRoutes);
app.use("/variables", variablesRoutes);

app.listen(PORT, () => {
  console.log(`Server ${PORT} portunda çalışıyor`);
});
