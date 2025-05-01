import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import memberRoutes from "./routes/member_routes";
import weekRoutes from "./routes/week_routes";
import subscriptionRoutes from "./routes/subscription_routes";
import trainerRoutes from "./routes/trainer_routes";
import variablesRoutes from "./routes/form_variables";
import loginRoutes from "./routes/auth_routes";
import fileRoutes from "./routes/file_routes";

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


app.use("/", fileRoutes);//express.static("uploads"));
app.use("/member", memberRoutes);
app.use("/week", weekRoutes);
app.use("/subscription", subscriptionRoutes);
app.use("/trainer", trainerRoutes);
app.use("/variables", variablesRoutes);
app.use("/login", loginRoutes);

app.listen(PORT, () => {
  console.log(`Server ${PORT} portunda çalışıyor`);
}); 

export { conn };

//proje ilk kurulumda default haftayı ekle
/*
db.weekdefaults.insertOne({
  type: "default",
  initialDayOfWeek: ISODate("2020-01-01T00:00:00.000Z"),
  daysOff: [],
  days: [
    {
      name: "Pazartesi",
      day: 1,
      activities: Array.from({ length: 17 }, (_, i) =>
        i % 2 === 0
          ? { type: "empty", ageGroup: "empty", fee: "empty" }
          : null
      )
    },
    {
      name: "Salı",
      day: 2,
      activities: Array.from({ length: 17 }, (_, i) =>
        i % 2 === 0
          ? { type: "empty", ageGroup: "empty", fee: "empty" }
          : null
      )
    },
    {
      name: "Çarşamba",
      day: 3,
      activities: Array.from({ length: 17 }, (_, i) =>
        i % 2 === 0
          ? { type: "empty", ageGroup: "empty", fee: "empty" }
          : null
      )
    },
    {
      name: "Perşembe",
      day: 4,
      activities: Array.from({ length: 17 }, (_, i) =>
        i % 2 === 0
          ? { type: "empty", ageGroup: "empty", fee: "empty" }
          : null
      )
    },
    {
      name: "Cuma",
      day: 5,
      activities: Array.from({ length: 17 }, (_, i) =>
        i % 2 === 0
          ? { type: "empty", ageGroup: "empty", fee: "empty" }
          : null
      )
    },
    {
      name: "Cumartesi",
      day: 6,
      activities: Array.from({ length: 17 }, (_, i) =>
        i % 2 === 0
          ? { type: "empty", ageGroup: "empty", fee: "empty" }
          : null
      )
    },
    {
      name: "Pazar",
      day: 7,
      activities: Array.from({ length: 17 }, (_, i) =>
        i % 2 === 0
          ? { type: "empty", ageGroup: "empty", fee: "empty" }
          : null
      )
    }
  ]
})
*/