import express from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import { authenticateUser } from "../functions/ldspAuth";
import { BaseResponseModel } from "../models/base_response";

dotenv.config();

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || "supersecretkey"; // Güçlü bir anahtar kullan!

router.post("/", async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        res.status(400).json(new BaseResponseModel(false, "Kullanıcı adı ve şifre gerekli").toJson());
    }

    const authResult = await authenticateUser(username, password);

    if (!authResult.success) {
        res.status(400).json(new BaseResponseModel(false, authResult.message).toJson());
    } else {
        // Kullanıcı doğrulandı, JWT token oluştur
        const token = jwt.sign({ username }, JWT_SECRET, { expiresIn: "2h" });

        res.status(200).json(new BaseResponseModel(true, "Giriş başarılı", token).toJson());
    }


});

export default router;
