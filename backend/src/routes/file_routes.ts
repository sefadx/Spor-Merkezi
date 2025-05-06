import express, { Request, Response, Router } from "express";
import mongoose, { Types } from "mongoose";
import multer from "multer";
import { GridFsStorage } from "multer-gridfs-storage";
import Files from "../models/file";
import { BaseResponseModel } from "../models/base_response";
import { safeObjectId } from "../functions/validators";

// Router tanımı
const router: Router = express.Router();

// Sabitler
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const BUCKET_NAME = "uploads";

// GridFsStorage konfigurasyonu
const storage = new GridFsStorage({
    url: process.env.MONGO_URI || "mongodb://localhost:27017/spor_merkezi",
    options: { useNewUrlParser: true, useUnifiedTopology: true },
    file: (req, file) => {
        // Benzersiz bir dosya adı oluştur
        const uniqueFileName = `${Date.now()}_${req.body.memberId}`;
        console.log(`Dosya yükleniyor: ${uniqueFileName}, Mime Type: ${file.mimetype}`);

        return {
            filename: uniqueFileName,
            bucketName: BUCKET_NAME,
            metadata: {
                trainerId: req.body.trainerId,
                memberId: req.body.memberId,
                reportType: req.body.reportType || "Doküman",
                originalName: file.originalname,
                uploadDate: new Date(),
                contentType: file.mimetype
            }
        };
    }
});

// Hata durumunda log kaydı oluştur
storage.on('file', (file) => {
    console.log('GridFS File Event - File saved to MongoDB:', file);
    console.log('File ID:', file.id); // Burada file.id özelliği tanımlı olmalı
});

storage.on('streamError', (error, conf) => {
    console.error('GridFS Stream Error:', error);
    console.log('Stream configuration:', conf);
});

// Hata durumunda log kaydı oluştur
storage.on('error', (err) => {
    console.error('GridFS Depolama Hatası:', err);
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

// MongoDB bağlantısı
const conn = mongoose.connection;

// GridFS File interface extension
interface GridFSFile {
    _id: Types.ObjectId;
    filename: string;
    contentType: string;
    length: number;
    chunkSize: number;
    uploadDate: Date;
    metadata?: any;
}

/**
 * Dosya yükleme endpointi
 * @route POST /upload
 * @desc Yeni bir PDF dosyası yükler
 */
router.post("/upload", upload.single("file"), async (req: Request, res: Response) => {

    const { memberId, reportType, approvalDate } = req.body;
    const file = req.file as Express.Multer.File & { id?: string, contentType?: string };
    console.log(req.body);
    console.log("Yüklenen dosya:", file);

    if (!file) {
        res.status(400).json(new BaseResponseModel(false, "Dosya yüklenemedi"));
    }

    if (!memberId) {
        res.status(400).json(new BaseResponseModel(false, "Üye ID'si zorunludur"));
    }

    // GridFsStorage, file objesine bir id atar 
    if (!file.id && !(file as any)._id) {
        res.status(400).json(new BaseResponseModel(false, "Dosya ID'si oluşturulamadı"));
    }

    // GridFS'in oluşturduğu dosya ID'sini al
    const fileId = file.id || (file as any)._id;
    const contentType = file.contentType || (file as any).contentType;

    try {
        // Yeni dosya kaydı oluştur
        const newFile = new Files({
            trainerId: req.body.trainerId ? safeObjectId(req.body.trainerId) : undefined,
            memberId: safeObjectId(memberId),
            fileId: safeObjectId(fileId),
            fileSize: file.size,
            mimeType: file.contentType || "application/pdf",
            fileName: file.filename || `${Date.now()}_file.pdf`,
            approvalDate: req.body.approvalDate,
            reportType: reportType || "Doküman",
        });

        // Veritabanına kaydet
        await newFile.save();
        res.status(200).json(new BaseResponseModel(true, "Dosya başarıyla yüklendi", { fileId }));
    } catch (error) {
        console.error("Dosya yükleme hatası:", error);

        // Eğer newFile kaydedilemediyse ve fileId varsa, GridFS'den dosyayı sil
        if (fileId) {
            try {
                if (!mongoose.connection.db) {
                    throw new Error('Database connection not available');
                }
                const gfs = new mongoose.mongo.GridFSBucket(mongoose.connection.db, {
                    bucketName: BUCKET_NAME,
                });

                // fileId'yi ObjectId'ye çevirerek silme işlemini gerçekleştir
                const objectId = safeObjectId(fileId.toString());
                if (!objectId) {
                    throw new Error('Invalid ObjectId format');
                }
                await gfs.delete(objectId);
                console.log(`GridFS'den dosya silindi: ${fileId}`);
            } catch (deleteError) {
                console.error("GridFS dosya silme hatası:", deleteError);
            }
        }

        res.status(500).json(new BaseResponseModel(false, "Dosya yükleme hatası: " + (error as Error).message));
    }
});

/**
 * Belirli bir üyenin dosyalarını getirme endpointi
 * @route GET /upload/member/:id
 * @desc Belirli bir üyeye ait tüm dosyaları listeler
 */
router.get("/download/member/:id", async (req: Request, res: Response) => {
    try {
        const memberId = req.params.id;

        if (!memberId) {
            res.status(400).json(
                new BaseResponseModel(false, "Geçerli bir üye ID'si gereklidir")
            );
        }

        const files = await Files.find({ memberId, deleted: false });
        res.status(200).json(new BaseResponseModel(true, "Dosyalar başarıyla getirildi", files));
    } catch (error) {
        console.error("Dosyaları getirme hatası:", error);
        res.status(500).json(
            new BaseResponseModel(false, "Dosyalar getirilirken hata oluştu", (error as Error).message)
        );
    }
});

/**
 * Dosya indirme endpointi
 * @route GET /download/:fileId
 * @desc Belirli bir dosyayı GridFS'ten alıp indirme için sunar
 */
router.get("/download/:fileId", async (req: Request, res: Response) => {
    try {
        const fileId = req.params.fileId;

        if (!fileId) {
            res.status(400).json(
                new BaseResponseModel(false, "Dosya ID'si gereklidir")
            );
        }

        // MongoDB bağlantısını kontrol et
        if (!conn.db) {
            res.status(500).json(
                new BaseResponseModel(false, "Veritabanı bağlantısı hazır değil")
            );
        }

        try {
            // MongoDB GridFSBucket oluştur
            if (!conn.db) {
                throw new Error("Database connection is not available");
            }
            const bucket = new mongoose.mongo.GridFSBucket(conn.db, { bucketName: BUCKET_NAME });

            // Geçerli bir ObjectId oluştur
            const objectId = new mongoose.Types.ObjectId(fileId);

            // Önce dosya bilgilerini al
            const files = bucket.find({ _id: objectId });
            const filesArray = await files.toArray();

            if (!filesArray.length) {
                console.log("Dosya bulunamadı:", fileId);
                res.status(404).json(
                    new BaseResponseModel(false, "Dosya bulunamadı")
                );
            }

            const fileInfo = filesArray[0] as GridFSFile;

            // Dosya türünü ve indirme header'larını ayarla
            res.set("Content-Type", fileInfo.contentType || "application/pdf");
            res.set("Content-Disposition", `attachment; filename="${fileInfo.filename}"`);

            // Dosya indirme akışını başlat
            const downloadStream = bucket.openDownloadStream(objectId);

            // Hata yönetimi
            downloadStream.on("error", (error) => {
                console.error("Dosya okuma hatası:", error);
                // Yanıt zaten gönderilmeye başlanmış olabilir, bu durumu kontrol et
                if (!res.headersSent) {
                    res.status(500).json(
                        new BaseResponseModel(false, "Dosya okuma hatası", error.message)
                    );
                }
            });

            // Daha güvenli akış işleme
            downloadStream.pipe(res);

        } catch (err) {
            console.error("Dosya bulunurken veya indirme akışı başlatılırken hata:", err);

            if (err instanceof mongoose.Error.CastError || (err as Error).name === 'BSONError') {
                res.status(400).json(
                    new BaseResponseModel(false, "Geçersiz dosya ID formatı")
                );
            }

            res.status(500).json(
                new BaseResponseModel(false, "Dosya işleme hatası", (err as Error).message)
            );
        }

    } catch (error) {
        console.error("Genel dosya indirme hatası:", error);
        // Yanıt zaten gönderilmeye başlanmış olabilir, bu durumu kontrol et
        if (!res.headersSent) {
            res.status(500).json(
                new BaseResponseModel(false, "Dosya indirme hatası", (error as Error).message)
            );
        }
    }
});

/**
 * Dosya silme endpointi
 * @route DELETE /delete/:fileId
 * @desc Belirli bir dosyayı siler (soft delete)
 */
router.delete("/delete/:fileId", async (req: Request, res: Response) => {
    try {
        const { fileId } = req.params;

        if (!fileId) {
            res.status(400).json(
                new BaseResponseModel(false, "Dosya ID'si gereklidir")
            );
        }

        // Önce dosya kaydını bul
        const file = await Files.findOne({ fileId: safeObjectId(fileId) });

        if (!file) {
            res.status(404).json(
                new BaseResponseModel(false, "Dosya bulunamadı")
            );
        }

        // Soft delete işlemi
        file!.deleted = true;
        //file.deletedAt = new Date();
        await file!.save();

        res.status(200).json(
            new BaseResponseModel(true, "Dosya başarıyla silindi")
        );
    } catch (error) {
        console.error("Dosya silme hatası:", error);
        res.status(500).json(
            new BaseResponseModel(false, "Dosya silinirken hata oluştu", (error as Error).message)
        );
    }
});

export default router;
