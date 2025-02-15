import mongoose, { Schema, Document } from "mongoose";
import { Cities, Genders, EducationLevels, HealthStatusChecks, PaymentStatus } from "../enums/lists";
import { validateIdentityNumber } from "../functions/validators";

// Üye modelinin TypeScript arayüzü
export interface IMember extends Document {
    identityNumber: string,
    name: string,
    surname: string,
    birthDate: Date,
    birthPlace: Cities,
    gender: Genders,
    educationLevel: string,
    phoneNumber: string,
    email: string,
    address: string,
    emergencyContact: {
        name: string,
        phone: String,
    };
    healthStatusCheck: HealthStatusChecks,
    paymentStatus: PaymentStatus,
    createdAt?: Date;
}

// Mongoose Şema Tanımı
const MemberSchema: Schema = new Schema({
    identityNumber: {
        type: String, required: true, unique: true,
        /*validate: {
            validator: validateIdentityNumber,
            message: 'Geçersiz TC Kimlik Numarası',
        }*/
    },
    name: { type: String, required: true, trim: true },
    surname: { type: String, required: true, trim: true },
    birthDate: { type: Date, required: true },
    birthPlace: { type: String, required: true, enum: Object.values(Cities) },
    gender: { type: String, required: true, enum: Object.values(Genders) },
    educationLevel: { type: String, required: true, enum: Object.values(EducationLevels) },
    phoneNumber: { type: String, required: true },
    email: { type: String, required: true, lowercase: true, match: /.+\@.+\..+/ },
    address: { type: String, required: true, trim: true },
    emergencyContact: {
        name: { type: String, required: true, trim: true },
        phone: { type: String, required: true, trim: true },
    },
    healthStatusCheck: {
        type: String,
        required: true,
        enum: Object.values(HealthStatusChecks),
        default: HealthStatusChecks.KontrolYapilmadi
    },
    paymentStatus: {
        type: String,
        required: true,
        enum: Object.values(PaymentStatus),
        default: PaymentStatus.OdemeYapilmadi
    },
    createdAt: { type: Date, default: Date.now },
});

// Modeli dışa aktarma
export default mongoose.model<IMember>("Member", MemberSchema);
