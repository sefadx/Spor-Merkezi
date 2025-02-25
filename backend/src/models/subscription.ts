import mongoose, { Schema } from "mongoose";
import { PaymentMethods, SportTypes } from "../enums/lists";

export interface ISubscription extends Document {
    memberId: Schema.Types.ObjectId; // Üye ID'si (Referans)
    amount: number; // Ödeme Miktarı
    sportType: SportTypes;
    paymentMethod: PaymentMethods; // Ödeme Yöntemi (Nakit, Kredi Kartı vs.)
    paymentDate: Date; // Ödeme Tarihi
    startDate: Date; // Abonelik Başlangıç Tarihi
    endDate: Date; // Abonelik Bitiş Tarihi
}

const SubscriptionSchema = new Schema<ISubscription>({
    memberId: {
        type: Schema.Types.ObjectId,
        ref: "Member",
        required: true
    },
    sportType: { type: String, required: true, enum: Object.values(SportTypes) },
    amount: { type: Number, required: true },
    paymentMethod: {
        type: String,
        required: true,
        enum: Object.values(PaymentMethods)
    }, // Ödeme Yöntemi
    paymentDate: { type: Date, default: Date.now, index: true }, // Ödeme Tarihi (Varsayılan: Şu anki zaman)
    startDate: { type: Date, required: true }, // Abonelik Başlangıcı
    endDate: { type: Date, required: true }, // Abonelik Bitişi
},
    { timestamps: true });

export default mongoose.model<ISubscription>("Subscription", SubscriptionSchema);