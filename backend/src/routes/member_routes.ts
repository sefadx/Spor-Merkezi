import { Router, Request, Response, NextFunction } from "express";
import { BaseResponseModel } from "../models/base_response";
import Member, { IMember } from "../models/member";

var response: BaseResponseModel;

const router = Router();

// Yeni üye ekle
/*router.post("/", async (req: Request, res: Response) => {
  try {
    const memberData: IMember = req.body;
    const newMember = new Member(memberData);
    const savedMember = await newMember.save();
    console.log("API POST: \"/member\" =>  Post request is successful");
    res.status(200).json(new BaseResponseModel(true, "Veri başarıyla eklendi", savedMember).toJson());
  } catch (error) {
    console.log(`API POST: "/member" => Post request failed. ${(error as Error).message}`);
    res.status(400).json(new BaseResponseModel(false, "Veri eklenirken hata oluştu.").toJson());
  }
});*/

router.post("/", async (req: Request, res: Response) => {
  try {
    const memberData: IMember = req.body;
    const newMember = new Member(memberData);
    const savedMember = await newMember.save();

    console.log('API POST: "/member" => Post request is successful');

    res.status(200).json(
      new BaseResponseModel(true, "Veri başarıyla eklendi", savedMember)
    );
  } catch (error: any) {
    console.error(`API POST: "/member" => Post request failed. ${error.message}`);

    let errorMessage = "Veri eklenirken hata oluştu.";
    let errorCode = 400;

    // **Hata Türlerine Göre Özel Cevap Dönme**
    if (error.name === "ValidationError") {
      errorMessage = "Geçersiz veri: " + Object.values(error.errors).map((err: any) => err.message).join(", ");
    } else if (error.code === 11000) {
      errorMessage = "Bu kişi zaten kayıtlı!";
    } else if (error.name === "MongoNetworkError") {
      errorMessage = "Veritabanı bağlantı hatası!";
      errorCode = 500;
    }

    res.status(errorCode).json(
      new BaseResponseModel(false, errorMessage)
    );
  }
});


// Tüm üyeleri getir
/*router.get("/", async (req: Request, res: Response) => {
  try {
    const members = await Member.find();
    console.log("API GET: \"/member\" =>  Succesfully read from database");
    res.status(200).send(new BaseResponseModel(
      true,
      "Veriler başarıyla yüklendi.",
      members).toJson(),);
  } catch (error) {
    console.log("API GET: \"/member\" =>  Database reading error");
    res.status(500).json({ error: (error as Error).message });
  }
});*/

router.get("/", async (req: Request, res: Response) => {
  try {
    // Query parametreleri ile filtreleme ve sayfalama desteği ekleyelim
    const { page = "1", limit = "10", search } = req.query;

    // Sayfalama ve sınır parametrelerini sayıya çevir
    const pageNumber = parseInt(page as string, 10);
    const limitNumber = parseInt(limit as string, 10);

    // Geçersiz parametre kontrolü
    if (isNaN(pageNumber) || isNaN(limitNumber) || pageNumber < 1 || limitNumber < 1) {
      res.status(400).json(new BaseResponseModel(false, "Geçersiz sayfa veya limit parametresi").toJson());
    }

    // Arama işlemi
    const query: any = {};
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: "i" } }, // İsme göre arama (Büyük/Küçük harf duyarsız)
        { surname: { $regex: search, $options: "i" } } // Soyisme göre arama
      ];
    }

    // MongoDB sorgusunu oluştur
    const members = await Member.find(query)
      .skip((pageNumber - 1) * limitNumber)
      .limit(limitNumber);

    // Toplam kayıt sayısını al
    const totalMembers = await Member.countDocuments(query);

    console.log('API GET: "/member" => Successfully read from database');

    // Yanıtı JSON formatında döndür
    res.status(200).send(new BaseResponseModel(
      true,
      "Veriler başarıyla yüklendi.",
      members,
      /*{
        members,
        total: totalMembers,
        page: pageNumber,
        limit: limitNumber,
        totalPages: Math.ceil(totalMembers / limitNumber)
      }*/
    ));

  } catch (error) {
    console.log(`API GET: "/member" => Database reading error: ${(error as Error).message}`);
    res.status(400).send(new BaseResponseModel(false, "Veritabanı okuma hatası", (error as Error).message).toJson());
  }
});


// Belirli bir üyeyi getir
router.get("/:id", async (req, res) => {
  try {
    const member = await Member.findById(req.params.id);
    if (!member) {
      res.status(404).json({ message: "Üye bulunamadı" });
    }
    res.json(member);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

// Üyeyi güncelle
router.put("/:id", async (req, res) => {
  try {
    const updatedMember = await Member.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedMember) {
      res.status(404).json({ message: "Üye bulunamadı" });
    }
    res.json(updatedMember);
  } catch (error) {
    res.status(400).json({ error: (error as Error).message });
  }
});

// Üyeyi sil
router.delete("/:id", async (req: Request, res: Response) => {
  try {
    const deletedMember = await Member.findByIdAndDelete(req.params.id);
    if (!deletedMember) {
      res.status(404).json({ message: "Üye bulunamadı" });
    }
    res.json({ message: "Üye silindi" });
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

export default router;
