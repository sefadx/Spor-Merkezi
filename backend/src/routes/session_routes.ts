import express, { Request, Response, NextFunction } from "express";
import { BaseResponseModel } from "../models/base_response";
import TableModel, { ITableModel } from "../models/session";

var response: BaseResponseModel;

const router = express.Router();


router.post("/", async (req: Request, res: Response) => {
    try {
        const sessionData: ITableModel = req.body;
        const newSession = new TableModel(sessionData);
        const savedSession = await newSession.save();

        console.log('API POST: "/session" => Post request is successful');
        console.log(savedSession);

        res.status(200).send(
            new BaseResponseModel(true, "Veri başarıyla eklendi", savedSession)
        );
    } catch (error: any) {
        console.error(`API POST: "/session" => Post request failed. ${error.message}`);

        let errorMessage = "Veri eklenirken hata oluştu.";

        // **Hata Türlerine Göre Özel Cevap Dönme**
        if (error.name === "ValidationError") {
            errorMessage = "Geçersiz veri: " + Object.values(error.errors).map((err: any) => err.message).join(", ");
        } else if (error.code === 11000) {
            errorMessage = "Bu seans zaten kayıtlı!";
        } else if (error.name === "MongoNetworkError") {
            errorMessage = "Veritabanı bağlantı hatası!";
        }

        res.status(400).send(
            new BaseResponseModel(false, errorMessage)
        );
    }
});


// Tüm seansları getir
router.get("/", async (req: Request, res: Response) => {
    try {
        // Query parametreleri ile filtreleme ve sayfalama desteği ekleyelim
        const { page = "1", limit = "100", search } = req.query;
        console.log(`API GET: "/session" => Page: ${page}, Limit: ${limit}, Search: ${search}`);

        // Sayfalama ve sınır parametrelerini sayıya çevir
        const pageNumber = parseInt(page as string, 10);
        const limitNumber = parseInt(limit as string, 10);

        // Geçersiz parametre kontrolü
        if (isNaN(pageNumber) || isNaN(limitNumber) || pageNumber < 1 || limitNumber < 1) {
            res.status(400).json(new BaseResponseModel(false, "Geçersiz sayfa veya limit parametresi").toJson());
        }

        // Arama işlemi
        let query: any = {};
        if (search && search != "null") {
            //query = { deleted: false };
            const date = new Date(search as string);

            if (isNaN(date.getTime())) {
                return res.status(400).json(new BaseResponseModel(false, "Geçersiz tarih formatı").toJson());
            }

            const startOfDay = new Date(date);
            startOfDay.setUTCHours(0, 0, 0, 0);

            const endOfDay = new Date(date);
            endOfDay.setUTCHours(23, 59, 59, 999);

            query.initialDayOfWeek = { $gte: startOfDay, $lte: endOfDay };
        }
        console.log("Query: ", query);
        // MongoDB sorgusunu oluştur
        const tableModel = await TableModel.find(query).
            //populate("trainer")
            skip((pageNumber - 1) * limitNumber)
            .limit(limitNumber)
            .sort({ initialDayOfWeek: -1 });

        // Toplam kayıt sayısını al
        const totalSessions = await TableModel.countDocuments(query);

        console.log('API GET: "/session" => Successfully read from database');
        console.log(tableModel);

        // Yanıtı JSON formatında döndür
        res.status(200).send(new BaseResponseModel(
            true,
            "Veriler başarıyla yüklendi.",
            tableModel,
            /*{
              session,
              total: totalMembers,
              page: pageNumber,
              limit: limitNumber,
              totalPages: Math.ceil(totalMembers / limitNumber)
            }*/
        ));

    } catch (error) {
        console.log(`API GET: "/session" => Database reading error: ${(error as Error).message}`);
        res.status(400).send(new BaseResponseModel(false, "Veritabanı okuma hatası", (error as Error).message).toJson());
    }
});


// Belirli bir üyeyi getir
router.get("/:id", async (req, res) => {
    try {
        const session = await TableModel.findById(req.params.id);
        if (!session) {
            res.status(404).send(new BaseResponseModel(false, "Seans bulunamadı").toJson());
        }
        res.status(200).send(new BaseResponseModel(true, "Veri başarıyla getirildi", session));
    } catch (error) {
        res.status(500).json({ error: (error as Error).message });
    }
});

// Üyeyi güncelle
router.put("/:id", async (req, res) => {
    try {
        const updatedSession = await TableModel.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }// Güncellenen veriyi döndür
        );
        if (!updatedSession) {
            res.status(404).send(new BaseResponseModel(false, "Seans bulunamadı").toJson());
        }
        res.json(updatedSession);
    } catch (error) {
        res.status(400).send(new BaseResponseModel(false, "Güncelleme başarısız.", (error as Error).message).toJson());
    }
});

// Seansı sil
router.delete("/:id", async (req: Request, res: Response) => {
    try {
        const deletedSession = await TableModel.findByIdAndUpdate(
            req.params.id,
            { deleted: true },
            { new: true }// Silinen veriyi döndür
        );
        if (!deletedSession) {
            res.status(404).json(new BaseResponseModel(false, "Seans bulunamadı").toJson());
        }
        res.status(200).send(new BaseResponseModel(true, "Seans silindi", deletedSession).toJson());
    } catch (error) {
        res.status(400).send(new BaseResponseModel(false, "Silme başarısız.", (error as Error).message).toJson());
    }
});

export default router;
