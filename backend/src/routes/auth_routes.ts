import express from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import { authenticateUser } from "../functions/ldspAuth";
import { BaseResponseModel } from "../models/base_response";

dotenv.config();

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || "supersecretkey"; // Güçlü bir anahtar kullan!
const AUTH_TIMEOUT_MS = 5000; // LDAP/Domain timeout süresi

/**
 * Helper: bir işlemi belirli süre içinde tamamlanmazsa hata fırlatsın.
 */
async function withTimeout<T>(promise: Promise<T>, ms: number, errMsg: string): Promise<T> {
  return Promise.race<T>([
    promise,
    new Promise<never>((_, reject) =>
      setTimeout(() => reject(new Error(errMsg)), ms)
    )
  ]);
}

router.post('/', async (req, res) => {
  try {
    const { username, password } = req.body ?? {};

    // 1) Gerekli alan kontrolü
    if (!username || !password) {
      res.status(400).send(new BaseResponseModel(false, 'Kullanıcı adı ve şifre gerekli'));
      return
    }

    // 2) Admin kısa devre girişi
    if (username === 'admin' && password === 'admin') {
      const token = jwt.sign({ username }, JWT_SECRET, { expiresIn: '2h' });
      res.status(200).json(new BaseResponseModel(true, 'Giriş başarılı', token));
      return
    }

    // 3) LDAP / domain üzerinden kimlik doğrulama (timeout ile sarılmış)
    let authResult;
    try {
      authResult = await withTimeout(
        authenticateUser(username, password),
        AUTH_TIMEOUT_MS,
        'Kimlik doğrulama sunucusu yanıt vermiyor'
      );
    } catch (err: any) {
      // timeout veya bağlantı hatası
      const msg =
        err.message === 'Kimlik doğrulama sunucusu yanıt vermiyor'
          ? err.message
          : 'Kimlik doğrulama sırasında hata oluştu: ' + err.message;
      res.status(504).json(new BaseResponseModel(false, msg));
      return
    }

    // 4) LDAP sonucuna göre reddet veya devam et
    if (!authResult!.success) {
      res.status(401).json(
          new BaseResponseModel(false, authResult!.message || 'Kimlik doğrulama başarısız'));
          return
    }

    // 5) Token oluşturma
    let token: string;
    try {
      token = jwt.sign({ username }, JWT_SECRET, { expiresIn: '2h' });
    } catch (err: any) {
      console.error('JWT Signing Error:', err);
      res.status(500).json(new BaseResponseModel(false,'Token oluşturulurken hata oluştu',null));
      return
    }

    // 6) Başarılı yanıt
    res.status(200).json(new BaseResponseModel(true, 'Giriş başarılı', token!));
  } catch (error: any) {
    console.error('Unexpected Error in /login:', error);

    // LDAP zaman aşımı kodu ayrı ele alındı, burası genel catch
    res.status(500).json(new BaseResponseModel(false,'Sunucu hatası, lütfen daha sonra tekrar deneyin',error.message));
  }
});


/*
router.post("/", async (req, res) => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            res.status(400).json(
                new BaseResponseModel(false, "Kullanıcı adı ve şifre gerekli").toJson()
            );
        }

        if (username === "admin" && password === "admin") {
            const token = jwt.sign({ username }, JWT_SECRET, { expiresIn: "2h" });
            res.status(200).json(
                new BaseResponseModel(true, "Giriş başarılı", token).toJson()
            );

        }

        const authResult = await authenticateUser(username, password);

        if (!authResult.success) {
            res.status(401).json(
                new BaseResponseModel(false, authResult.message || "Kimlik doğrulama başarısız").toJson()
            );
        }

        const token = jwt.sign({ username }, JWT_SECRET, { expiresIn: "2h" });

        res.status(200).json(
            new BaseResponseModel(true, "Giriş başarılı", token).toJson()
        );
    } catch (error: any) {
        console.error("LDAP Authentication Error:", error);

        if (error.code === "ETIMEDOUT") {
            res.status(504).json(
                new BaseResponseModel(false, "LDAP sunucusuna bağlantı zaman aşımına uğradı").toJson()
            );
        }

        res.status(500).json(
            new BaseResponseModel(false, "Sunucu hatası, lütfen daha sonra tekrar deneyin", error.message).toJson()
        );
    }
});*/



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