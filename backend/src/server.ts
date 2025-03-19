import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import memberRoutes from "./routes/member_routes";
import sessionRoutes from "./routes/session_routes";
import subscriptionRoutes from "./routes/subscription_routes";
import trainerRoutes from "./routes/trainer_routes";
import variablesRoutes from "./routes/form_variables";
import loginRoutes from "./routes/auth_routes";
import fileRoutes from "./routes/file_routes";
import { F } from "@faker-js/faker/dist/airline-CBNP41sR";
import file from "./models/file";

//sudo systemctl start mongod
//sudo systemctl enable mongod

//brew services start mongodb/brew/mongodb-community@5.0
//brew services start mongodb-community
//brew services stop mongodb-community
//npm run dev

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

const conn = mongoose.connection;


app.use("/upload", fileRoutes);//express.static("uploads"));
app.use("/member", memberRoutes);
app.use("/session", sessionRoutes);
app.use("/subscription", subscriptionRoutes);
app.use("/trainer", trainerRoutes);
app.use("/variables", variablesRoutes);
app.use("/login", loginRoutes);

app.listen(PORT, () => {
  console.log(`Server ${PORT} portunda çalışıyor`);
});

export { conn };