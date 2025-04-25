import mongoose, { Schema, Document } from "mongoose";
import { ReportTypes } from "../enums/lists";

export interface IFiles extends Document {
    trainerId: Schema.Types.ObjectId; // Trainer ID'si (Referans)
    memberId: Schema.Types.ObjectId;  // Dosyanın ait olduğu üyenin ID’si
    fileId: Schema.Types.ObjectId;    // GridFS'te saklanan dosyanın ID’si
    fileName: string;                 // Dosya adı
    fileSize: number;                 // Dosya boyutu,
    mimeType: string;                 // Dosya türü,
    createdAt?: Date;               // Yükleme tarihi
    //endOfValidity: Date;            // Geçerlilik süresi (örneğin 6 ay)
    approvalDate: Date;              // Onaylandığı tarih
    reportType: ReportTypes;            // Dosya tipi (örn. sağlık raporu)
    deleted?: boolean;                // Dosyanın silinip silinmediği
}

const FilesSchema = new Schema<IFiles>({
    createdAt: { type: Date, default: Date.now },
    trainerId: { type: Schema.Types.ObjectId, ref: "Trainer", required: true },
    memberId: { type: Schema.Types.ObjectId, ref: "Member", required: true },
    fileId: { type: Schema.Types.ObjectId, required: true },
    fileName: { type: String, required: true },
    fileSize: { type: Number, required: true },
    mimeType: { type: String, required: true },
    //endOfValidity: { type: Date, required: true },
    approvalDate: { type: Date, required: true },
    reportType: { type: String, required: true, enum: Object.values(ReportTypes) },
    deleted: { type: Boolean, default: false },
}, { timestamps: true });

export default mongoose.model<IFiles>("Files", FilesSchema);