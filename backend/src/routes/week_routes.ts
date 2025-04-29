import express, { Request, Response, NextFunction } from "express";
import { BaseResponseModel } from "../models/base_response";
import WeekModel, { IWeek } from "../models/week";
import Subscription, { ISubscription } from "../models/subscription";


var response: BaseResponseModel;
 
const router = express.Router();

router.post("/", async (req: Request, res: Response) => {
    try {
        console.log('API POST: "/Table" => Post request is successful');
        console.log(req.body); // Gelen veriyi kontrol etmek için logla
      const weekData: IWeek = req.body;
  
      // 1. Seanslardaki üyeler için abonelik kredisi düş
      for (const day of weekData.days) {
        for (const activity of day.activities) {
          if (!activity || !activity.sessionModel) continue;
  
          const session = activity.sessionModel;
  
          for (const memberId of session.mainMembers) {
            // Üyeye ait aboneliği getir
            const subscription = await Subscription.findOne({ memberId });
  
            if (subscription) {
              if (subscription.credit > 0) {
                subscription.credit -= 1;
                await subscription.save();
                console.log(`Üye ${memberId} için 1 kredi düşüldü. Kalan: ${subscription.credit}`);
              } else {
                console.log(`Üye ${memberId} için kredi yok. Atlandı.`);
              }
            } else {
              console.log(`Üye ${memberId} için abonelik bulunamadı. Atlandı.`);
            }
          }
        }
      }
  
      // 2. Haftayı kaydet
      const newTable = new WeekModel(weekData);
      const savedTable = await newTable.save();
  
      console.log("Yeni hafta başarıyla kaydedildi:", savedTable);
      res.status(200).json(new BaseResponseModel(true, "Hafta başarıyla oluşturuldu.", savedTable).toJson());
  
    } catch (error) {
      console.error("Hafta oluşturulamadı:", error);
      res.status(400).json(new BaseResponseModel(false, "Hafta oluşturulamadı.", (error as Error).message).toJson());
    }
  });
  
  
  
/*
router.post("/", async (req: Request, res: Response) => {
    try {
        const tableData: ITableModel = req.body;
        const newTable = new TableModel(tableData);
        const savedTable = await newTable.save();

        console.log('API POST: "/Table" => Post request is successful');
        console.log(savedTable);

        res.status(200).send(
            new BaseResponseModel(true, "Veri başarıyla eklendi", savedTable).toJson()
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
*/

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
        const tableModel = await WeekModel.find(query).
            //populate("trainer")
            skip((pageNumber - 1) * limitNumber)
            .limit(limitNumber)
            .sort({ initialDayOfWeek: -1 });

        // Toplam kayıt sayısını al
        const totalSessions = await WeekModel.countDocuments(query);

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


// Belirli bir haftayı getir
router.get("/:id", async (req, res) => {
    try {
        const session = await WeekModel.findById(req.params.id);
        if (!session) {
            res.status(404).send(new BaseResponseModel(false, "Seans bulunamadı").toJson());
        }
        res.status(200).send(new BaseResponseModel(true, "Veri başarıyla getirildi", session));
    } catch (error) {
        res.status(500).json({ error: (error as Error).message });
    }
});


// Belirli bir haftayı getir (ID ile)
router.put("/:id", async (req: Request, res: Response) => {
    try {
      const tableId = req.params.id;
      const updatedData: IWeek = req.body;
  
      // 1. Eski tabloyu al
      const existingTable = await WeekModel.findById(tableId);
      if (!existingTable) {
        return res.status(404).json(new BaseResponseModel(false, "Hafta bulunamadı").toJson());
      }
  
      // 2. Gün gün, aktivite aktivite, seans seans karşılaştır
      for (let i = 0; i < updatedData.days.length; i++) {
        const newDay = updatedData.days[i];
        const oldDay = existingTable.days[i];
  
        if (!oldDay) continue;
  
        for (let j = 0; j < newDay.activities.length; j++) {
          const newAct = newDay.activities[j];
          const oldAct = oldDay.activities[j];
  
          if (!newAct?.sessionModel || !oldAct?.sessionModel) continue;
  
          const newMembers = new Set(newAct.sessionModel.mainMembers.map(id => id.toString()));
          const oldMembers = new Set(oldAct.sessionModel.mainMembers.map(id => id.toString()));
  
          // Eklenen üyeler (yeni listede olup eskide olmayanlar)
          const added = [...newMembers].filter(id => !oldMembers.has(id));
          // Çıkarılan üyeler (eski listede olup yenide olmayanlar)
          const removed = [...oldMembers].filter(id => !newMembers.has(id));
  
          for (const memberId of added) {
            const subscription = await Subscription.findOne({ memberId });
            if (subscription && subscription.credit > 0) {
              subscription.credit -= 1;
              await subscription.save();
              console.log(`Üye ${memberId} eklendi → 1 kredi düşüldü (Kalan: ${subscription.credit})`);
            }
          }
  
          for (const memberId of removed) {
            const subscription = await Subscription.findOne({ memberId });
            if (subscription) {
              subscription.credit += 1;
              await subscription.save();
              console.log(`Üye ${memberId} çıkarıldı → 1 kredi geri verildi (Yeni: ${subscription.credit})`);
            }
          }
        }
      }
  
      // 3. Güncelle ve kaydet
      const updatedTable = await WeekModel.findByIdAndUpdate(tableId, updatedData, { new: true });
  
      res.status(200).json(new BaseResponseModel(true, "Hafta başarıyla güncellendi.", updatedTable).toJson());
  
    } catch (error) {
      console.error("Hafta güncellenemedi:", error);
      res.status(400).json(new BaseResponseModel(false, "Hafta güncellenemedi.", (error as Error).message).toJson());
    }
  });
  
  

/*
// Üyeyi güncelle
router.put("/:id", async (req, res) => {
    try {
        console.log("Güncellenen veri: ", req.body);
        const updatedSession = await TableModel.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }// Güncellenen veriyi döndür
        );
        if (!updatedSession) {
            res.status(404).send(new BaseResponseModel(false, "Seans bulunamadı").toJson());
        }
        res.send(new BaseResponseModel(true, "Seans güncellendi", updatedSession).toJson());
    } catch (error) {
        console.error("Güncelleme hatası: ", error);
        res.status(400).send(new BaseResponseModel(false, "Güncelleme başarısız.", (error as Error).message).toJson());
    }
});*/

// Seansı sil
router.delete("/:id", async (req: Request, res: Response) => {
    try {
        const deletedSession = await WeekModel.findByIdAndUpdate(
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
