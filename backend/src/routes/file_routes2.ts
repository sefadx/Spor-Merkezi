/**
 * file_routes.ts
 * PDF Dosya yönetimi için API rotaları
 */

import express, { Request, Response } from "express";
import mongoose, { Types } from "mongoose";
import multer from "multer";
import Grid from "gridfs-stream";
import { GridFsStorage } from "multer-gridfs-storage";
import Files from "../models/file";
import { BaseResponseModel } from "../models/base_response";

// Router tanımı
const router = express.Router();

// Sabitler
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const BUCKET_NAME = "uploads";

/**
 * GridFS depolama yapılandırması
 * PDF dosyalarını MongoDB GridFS sisteminde depolamak için kullanılır
 */
const storage = new GridFsStorage({
    url: process.env.MONGO_URI as string,
    options: { useNewUrlParser: true, useUnifiedTopology: true },
    file: (req, file) => {
        // req ve file'ı özel olarak tiplemiyoruz, çünkü bu uyumsuzluğa yol açıyor
        return {
            filename: `${Date.now()}_${file.originalname}`,
            bucketName: BUCKET_NAME,
            metadata: {
                memberId: req.body.memberId,
                reportType: req.body.reportType || "Sağlık Raporu",
                validityPeriod: new Date(req.body.validityPeriod || req.body.endOfValidity),
                approved: false
            }
        };
    }
});

/**
 * PDF dosya filtresi
 * Sadece PDF dosyalarının yüklenmesine izin verir
 */
const fileFilter = (req: Request, file: Express.Multer.File, cb: multer.FileFilterCallback): void => {
    if (file.mimetype !== "application/pdf") {
        return cb(new Error("Sadece PDF dosyaları yüklenebilir!"));
    }
    cb(null, true);
};

/**
 * Multer yükleme yapılandırması
 * Dosya boyutu ve türü sınırlamaları ile dosya yükleme işlemlerini yönetir
 */
const upload = multer({
    storage: storage as any,
    limits: { fileSize: MAX_FILE_SIZE },
    fileFilter
});

// MongoDB bağlantısı ve GridFS ayarları
const conn = mongoose.connection;
let gfs: Grid.Grid;

conn.once("open", () => {
    gfs = Grid(conn.db, mongoose.mongo);
    gfs.collection(BUCKET_NAME);
});

/**
 * Hata işleme yardımcı fonksiyonu
 * API hata yanıtlarını standartlaştırır
 */
const handleError = (res: Response, statusCode: number, message: string, error?: any): void => {
    console.error(`Hata: ${message}`, error);
    res.status(statusCode).json({
        success: false,
        message,
        error: error instanceof Error ? error.message : String(error)
    });
};

/**
 * PDF Dosya yükleme endpointi
 * @route POST /upload
 * @desc Yeni PDF dosyası yükler ve veritabanına kaydeder
 */
router.post("/upload", upload.single("file"), async (req: Request, res: Response): Promise<void> => {
    try {
        const { trainerId, memberId, endOfValidity, approvalDate, reportType } = req.body;
        const file = req.file;

        // Dosya kontrolü
        if (!file) {
            res.status(400).json(new BaseResponseModel(false, "Dosya yüklenemedi.").toJson());
            return;
        }

        // Yeni dosya kaydı oluştur
        // fileId alanı ObjectId olmalı
        const newFile = new Files({
            trainerId,
            memberId,
            //fileId: new Types.ObjectId(file.id), // GridFS ObjectId olarak dönüştür
            filename: file.filename,
            uploadedDate: new Date(),
            endOfValidity: new Date(endOfValidity),
            approvalDate: approvalDate ? new Date(approvalDate) : undefined,
            reportType,
            deleted: false
        });

        // Veritabanına kaydet
        await newFile.save();
        
        res.status(201).json({
            success: true, 
            message: "Dosya başarıyla yüklendi.", 
            file: newFile 
        });
    } catch (error) {
        handleError(res, 500, "Dosya yükleme hatası", error);
    }
});

/**
 * Flutter uygulamasından PDF dosyası yükleme endpointi
 * @route POST /uploadPdf
 * @desc Flutter uygulamasından gönderilen PDF dosyasını işler
 */
router.post("/uploadPdf", upload.single("pdfFile"), async (req: Request, res: Response): Promise<void> => {
    try {
        const { memberId, endOfValidity, description } = req.body;
        const file = req.file;

        // Dosya kontrolü
        if (!file) {
            res.status(400).json(new BaseResponseModel(false, "PDF dosyası bulunamadı.").toJson());
            return;
        }

        // Üye ID kontrolü
        if (!memberId) {
            res.status(400).json(new BaseResponseModel(false, "Üye ID'si gereklidir.").toJson());
            return;
        }

        // Yeni dosya kaydı oluştur
        const newFile = new Files({
            memberId,
            //fileId: new Types.ObjectId(file.id), // GridFS ObjectId olarak dönüştür
            filename: file.filename,
            uploadedDate: new Date(),
            endOfValidity: endOfValidity ? new Date(endOfValidity) : undefined,
            reportType: "PDF Döküman",
            description: description || "Flutter uygulamasından yüklenen PDF dosyası",
            deleted: false
        });

        // Veritabanına kaydet
        await newFile.save();
        
        res.status(201).json({ 
            success: true, 
            message: "PDF dosyası başarıyla yüklendi.", 
            //fileId: file.id,
            fileName: file.filename
        });
    } catch (error) {
        handleError(res, 500, "PDF dosyası yükleme hatası", error);
    }
});

/**
 * Belirli bir üyenin dosyalarını getirme endpointi
 * @route GET /member/:id
 * @desc Belirli bir üyeye ait tüm dosyaları listeler
 */
router.get("/member/:id", async (req: Request, res: Response): Promise<void> => {
    try {
        const memberId = req.params.id;
        
        if (!memberId) {
            res.status(400).json({ success: false, message: "Geçerli bir üye ID'si gereklidir." });
            return;
        }
        
        const files = await Files.find({ memberId, deleted: false });
        res.status(200).json({
            success: true,
            count: files.length,
            files
        });
    } catch (error) {
        handleError(res, 500, "Dosyalar getirilemedi", error);
    }
});

/**
 * Belirli türdeki raporları getirme endpointi
 * @route GET /report-type/:type
 * @desc Belirli bir rapor türüne ait tüm dosyaları listeler
 */
router.get("/report-type/:type", async (req: Request, res: Response): Promise<void> => {
    try {
        const reportType = req.params.type;
        
        if (!reportType) {
            res.status(400).json({ success: false, message: "Geçerli bir rapor türü gereklidir." });
            return;
        }
        
        const files = await Files.find({ reportType, deleted: false });
        res.status(200).json({
            success: true,
            count: files.length,
            files
        });
    } catch (error) {
        handleError(res, 500, "Dosyalar getirilemedi", error);
    }
});

/**
 * Dosya indirme endpointi
 * @route GET /download/:fileId
 * @desc Belirli bir dosyayı GridFS'ten alıp indirme için sunar
 */
router.get("/download/:fileId", async (req: Request, res: Response): Promise<void> => {
    try {
        const fileId = req.params.fileId;

        if (!fileId) {
            res.status(400).json({ success: false, message: "Geçerli bir dosya ID'si gereklidir." });
            return;
        }

        // Dosya bilgilerini gridfs'ten bul
        // ObjectId kullanarak MongoDB'de _id alanına göre arama yapıyoruz
        let objectId: Types.ObjectId;
        try {
            objectId = new Types.ObjectId(fileId);
        } catch (err) {
            res.status(400).json({ success: false, message: "Geçersiz dosya ID formatı." });
            return;
        }
        
        const file = await gfs.files.findOne({ _id: objectId });

        if (!file) {
            res.status(404).json({ success: false, message: "Dosya bulunamadı." });
            return;
        }

        // Dosya türünü kontrol et ve içeriği ayarla
        res.set("Content-Type", file.contentType || "application/pdf");
        res.set("Content-Disposition", `attachment; filename="${file.filename}"`);
        
        // Dosya akışını oluştur ve yanıt olarak gönder
        const readStream = gfs.createReadStream(file._id.toString());
        readStream.on("error", (err) => {
            handleError(res, 500, "Dosya akışı oluşturulurken hata", err);
        });
        
        readStream.pipe(res);
    } catch (error) {
        handleError(res, 500, "Dosya indirme hatası", error);
    }
});

/**
 * Dosya silme endpointi
 * @route DELETE /delete/:fileId
 * @desc GridFS'ten dosyayı siler ve veritabanı kaydını günceller
 */
router.delete("/delete/:fileId", async (req: Request, res: Response): Promise<void> => {
    try {
        const fileId = req.params.fileId;
        
        if (!fileId) {
            res.status(400).json({ success: false, message: "Geçerli bir dosya ID'si gereklidir." });
            return;
        }
        
        // ObjectId oluşturmayı try-catch blogu içine alıyoruz
        let objectId: Types.ObjectId;
        try {
            objectId = new Types.ObjectId(fileId);
        } catch (err) {
            res.status(400).json({ success: false, message: "Geçersiz dosya ID formatı." });
            return;
        }

        // GridFS'ten dosyayı sil
        await new Promise<void>((resolve, reject) => {
            // GridFS tipi hataları önlemek için callback'i any olarak işaretliyoruz
            // Bu, callback tipinin TypeScript tarafından doğru şekilde anlaşılmasını sağlar
            const callback = (err: any) => {
                if (err) {
                    return reject(err);
                }
                resolve();
            };
            
            type GridFSCallback = (err: Error | null) => void;
            // remove fonksiyonuna daha özel bir tip tanımı uyguluyoruz
            gfs.remove({ _id: objectId.toString(), root: BUCKET_NAME }, callback as GridFSCallback);
        });

        // Veritabanında dosyanın silindiğini işaretle
        // Model tanımına göre fileId alanı ObjectId tipindedir.
        // MongoDB sorgu uyumluluğu için _id ve fileId alanı için sorgu yapıyoruz.
        const updateResult = await Files.findOneAndUpdate(
            { $or: [{ _id: objectId }, { fileId: objectId }] }, 
            { deleted: true, deletedAt: new Date() }
        );

        if (!updateResult) {
            res.status(404).json({ success: false, message: "Dosya veritabanı kaydı bulunamadı." });
            return;
        }

        res.status(200).json({ 
            success: true, 
            message: "Dosya başarıyla silindi." 
        });
    } catch (error) {
        handleError(res, 500, "Dosya silme hatası", error);
    }
});

/**
 * Dosya bilgilerini güncelleme endpointi
 * @route PUT /update/:fileId
 * @desc Var olan bir dosyanın metadata bilgilerini günceller
 */
router.put("/update/:fileId", async (req: Request, res: Response): Promise<void> => {
    try {
        const fileId = req.params.fileId;
        const updates = req.body;
        
        if (!fileId) {
            res.status(400).json({ success: false, message: "Geçerli bir dosya ID'si gereklidir." });
            return;
        }
        
        // ObjectId oluşturmayı try-catch blogu içine alıyoruz
        let objectId: Types.ObjectId;
        try {
            objectId = new Types.ObjectId(fileId);
        } catch (err) {
            res.status(400).json({ success: false, message: "Geçersiz dosya ID formatı." });
            return;
        }
        
        // Güvenlik için izin verilen alanları kontrol et
        const allowedUpdates = ["reportType", "description", "endOfValidity", "approved"];
        const updateData: Record<string, any> = {};
        
        for (const key of Object.keys(updates)) {
            if (allowedUpdates.includes(key)) {
                // Tarih alanlarını Date nesnesine dönüştür
                if (key === "endOfValidity") {
                    updateData[key] = new Date(updates[key]);
                } else {
                    updateData[key] = updates[key];
                }
            }
        }
        
        // Güncellenecek alan yoksa hata döndür
        if (Object.keys(updateData).length === 0) {
            res.status(400).json({ 
                success: false, 
                message: "Güncellenecek geçerli bir alan bulunamadı." 
            });
            return;
        }
        
        // Dosyayı güncelle
        // Model tanımına göre fileId alanı ObjectId tipindedir.
        // MongoDB sorgu uyumluluğu için _id ve fileId alanı için sorgu yapıyoruz.
        const updatedFile = await Files.findOneAndUpdate(
            { $or: [{ _id: objectId }, { fileId: objectId }], deleted: false },
            updateData,
            { new: true }
        );
        
        if (!updatedFile) {
            res.status(404).json({ success: false, message: "Dosya bulunamadı." });
            return;
        }
        
        res.status(200).json({
            success: true,
            message: "Dosya bilgileri başarıyla güncellendi.",
            file: updatedFile
        });
    } catch (error) {
        handleError(res, 500, "Dosya güncelleme hatası", error);
    }
});

export default router;