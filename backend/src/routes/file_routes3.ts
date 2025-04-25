/**
 * file_api.ts
 * PDF Dosya yönetimi için API rotaları (CRUD işlemleri)
 * TypeScript ve Express kullanarak dosya yükleme işlemlerini yönetir
 */

import express, { Request, Response, Router } from "express";
import mongoose, { Types } from "mongoose";
import multer from "multer";
import path from "path";
import fs from "fs";
import File from "../models/file";

// Router tanımı
const router: Router = express.Router();

// Sabitler
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const UPLOAD_DIR = path.join(__dirname, '../../uploads');

/**
 * API Yanıt tipi tanımı
 */
interface ApiResponse<T> {
    success: boolean;
    message: string;
    data?: T;
    count?: number;
    error?: string;
}

// Uploads klasörünün varlığını kontrol et, yoksa oluştur
if (!fs.existsSync(UPLOAD_DIR)) {
    fs.mkdirSync(UPLOAD_DIR, { recursive: true });
    console.log(`Uploads klasörü oluşturuldu: ${UPLOAD_DIR}`);
}

/**
 * Disk depolama yapılandırması
 * Dosyaları sunucu diskine kaydeder
 */
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, UPLOAD_DIR);
    },
    filename: function (req, file, cb) {
        // Benzersiz bir dosya adı oluştur
        const uniqueFileName = `${Date.now()}_${file.originalname.replace(/\s+/g, '_')}`;
        console.log(`Dosya yükleniyor: ${uniqueFileName}, Mime Type: ${file.mimetype}`);
        cb(null, uniqueFileName);
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
    storage: storage,
    limits: { fileSize: MAX_FILE_SIZE },
    fileFilter
});

// MongoDB bağlantısı
const conn = mongoose.connection;

conn.once("open", () => {
    console.log('MongoDB bağlantısı başarılı');
});

/**
 * Hata işleme yardımcı fonksiyonu
 * API hata yanıtlarını standartlaştırır
 */
function handleApiError(res: Response, statusCode: number, message: string, error?: any): void {
    console.error(`Hata: ${message}`, error);
    res.status(statusCode).json({
        success: false,
        message,
        error: error instanceof Error ? error.message : String(error)
    });
}

/**
 * API yanıtı oluşturma yardımcı fonksiyonu
 * Standart API yanıtı formatını oluşturur
 */
function createApiResponse<T>(success: boolean, message: string, data?: T, count?: number): ApiResponse<T> {
    return {
        success,
        message,
        ...(data && { data }),
        ...(count !== undefined && { count })
    };
}

/**
 * ObjectId güvenli dönüşüm fonksiyonu
 * Geçerli bir ObjectId oluşturma işlemini güvenli hale getirir
 * @param id - String, number veya Buffer olabilir
 * @returns Types.ObjectId | null - Geçerli bir ObjectId veya null
 */
function safeObjectId(id: string | number | Buffer): Types.ObjectId | null {
    try {
        // Eğer id bir number ise, createFromTime() kullan (deprecated uyarısını önler)
        if (typeof id === 'number') {
            return Types.ObjectId.createFromTime(id);
        }
        // Diğer durumlar için normal constructor'u kullan
        return new Types.ObjectId(id);
    } catch (error) {
        return null;
    }
}

/**
 * Dosya yükleme endpointi
 * @route POST /api/files
 * @desc Yeni bir PDF dosyası yükler
 */
router.post("/", upload.single("file"), async (req: Request, res: Response): Promise<void> => {
    try {
        const { memberId, reportType, endOfValidity, description } = req.body;
        const file = req.file;

        if (!file) {
            res.status(400).json(createApiResponse(false, "Yüklenecek dosya bulunamadı"));
            return;
        }

        if (!memberId) {
            res.status(400).json(createApiResponse(false, "Üye ID'si gereklidir"));
            return;
        }

        console.log('Yüklenen dosya bilgileri:', {
            filename: file.filename,
            originalname: file.originalname,
            path: file.path,
            destination: file.destination,
            size: file.size,
            mimetype: file.mimetype
        });

        // Dosya yolu bilgisini kontrol et
        if (!file.path) {
            console.error('Dosya yolu bilgisi eksik:', file);
            res.status(500).json(createApiResponse(false, "Dosya yüklenirken bir hata oluştu: Dosya yolu bulunamadı"));
            return;
        }

        // Dosyanın fiziksel olarak var olup olmadığını kontrol et
        if (!fs.existsSync(file.path)) {
            console.error('Dosya disk üzerinde bulunamadı:', file.path);
            res.status(500).json(createApiResponse(false, "Dosya yükleme işlemi tamamlanamadı"));
            return;
        }

        // Benzersiz bir dosya ID'si oluştur (MongoDB ObjectID)
        const fileId = new Types.ObjectId();

        // Yeni dosya kaydı oluştur
        const newFile = new File({
            _id: fileId,
            memberId: safeObjectId(memberId),
            trainerId: safeObjectId(req.body.trainerId),
            fileId: fileId, // Artık bu sadece bir referans ID
            filename: file.filename,
            filePath: file.path, // Dosyanın fiziksel disk yolunu sakla
            uploadedDate: new Date(),
            fileSize: file.size,
            mimeType: file.mimetype,
            endOfValidity: endOfValidity ? new Date(endOfValidity) : new Date(Date.now() + 180 * 24 * 60 * 60 * 1000), // Varsayılan 6 ay
            approvalDate: new Date(), // Henüz onaylanmadı
            reportType: reportType || "Doküman",
            description: description || `${file.originalname} dosyası`,
            approved: false,
            deleted: false
        });

        // Veritabanına kaydet
        await newFile.save();

        res.status(201).json(createApiResponse(
            true,
            "Dosya başarıyla yüklendi",
            {
                _id: newFile._id,
                filename: newFile.filename,
                reportType: newFile.reportType,
                uploadDate: newFile.createdAt
            }
        ));
    } catch (error) {
        handleApiError(res, 500, "Dosya yükleme hatası", error);
    }
});

export default router;