import express from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import { authenticateUser } from "../functions/ldspAuth";
import { BaseResponseModel } from "../models/base_response";

dotenv.config();

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || "supersecretkey"; // Güçlü bir anahtar kullan!

router.post("/", async (req, res) => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            return res.status(400).json(
                new BaseResponseModel(false, "Kullanıcı adı ve şifre gerekli").toJson()
            );
        }

        const authResult = await authenticateUser(username, password);

        if (!authResult.success) {
            return res.status(401).json(
                new BaseResponseModel(false, authResult.message || "Kimlik doğrulama başarısız").toJson()
            );
        }

        const token = jwt.sign({ username }, JWT_SECRET, { expiresIn: "2h" });

        return res.status(200).json( 
            new BaseResponseModel(true, "Giriş başarılı", token).toJson()
        );
    } catch (error: any) {
        console.error("LDAP Authentication Error:", error);

        if (error.code === "ETIMEDOUT") {
            return res.status(504).json(
                new BaseResponseModel(false, "LDAP sunucusuna bağlantı zaman aşımına uğradı").toJson()
            );
        }

        return res.status(500).json(
            new BaseResponseModel(false, "Sunucu hatası, lütfen daha sonra tekrar deneyin", error.message).toJson()
        );
    }
});



export default router;

/*
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
*/