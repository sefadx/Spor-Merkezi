import mongoose, { Schema } from "mongoose";
import { AgeGroups, ActivityTypes, FeeTypes, SportTypes } from "../enums/lists";

export interface ISubscription extends Document {
    memberId: Schema.Types.ObjectId; // Üye ID'si (Referans)
    amount: number; // Ödeme Miktarı
    type: ActivityTypes;
    ageGroup: AgeGroups;
    fee: FeeTypes;
    credit: number; // Kredi Miktarı
    //paymentMethod: PaymentMethods; // Ödeme Yöntemi (Nakit, Kredi Kartı vs.)
    paymentDate: Date; // Ödeme Tarihi 
    //startDate: Date; // Abonelik Başlangıç Tarihi
    //endDate: Date; // Abonelik Bitiş Tarihi
}

const SubscriptionSchema = new Schema<ISubscription>({
    memberId: {
        type: Schema.Types.ObjectId,
        ref: "Member",
        required: true,
    },
    //sportType: { type: String, required: true, enum: Object.values(SportTypes) },
    type: { type: String, required: true, enum: Object.values(ActivityTypes) },
    ageGroup: { type: String, required: true, enum: Object.values(AgeGroups) },
    fee: { type: String, required: true, enum: Object.values(FeeTypes) },
    amount: { type: Number, required: true, trim: true},
    credit: { type: Number, default: 8, trim: true }, // Kredi Miktarı (Varsayılan: 0)
    /*paymentMethod: {
        type: String,
        required: true,
        enum: Object.values(PaymentMethods)
    }, */// Ödeme Yöntemi
    paymentDate: { type: Date, required: true, index: true }, // Ödeme Tarihi (Varsayılan: Şu anki zaman)
    //startDate: { type: Date, required: true }, // Abonelik Başlangıcı
    //endDate: { type: Date, required: true }, // Abonelik Bitişi
},
    { timestamps: true });

export default mongoose.model<ISubscription>("Subscription", SubscriptionSchema);