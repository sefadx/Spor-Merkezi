import mongoose from "mongoose";
import { ISubscription } from "../src/models/subscription";
import Subscription from "../src/models/subscription";
import MemberModel from "./models/member";
import { SportTypes, PaymentMethods } from "../src/enums/lists";

// MongoDB bağlantısı
const connectDB = async () => {
  try {
    await mongoose.connect("mongodb://127.0.0.1:27017/spor_merkezi"); // Burayı kendi veritabanı bağlantı adresinle değiştir
    console.log("✅ MongoDB'ye başarıyla bağlandı!");
  } catch (error) {
    console.error("❌ MongoDB bağlantı hatası:", error);
    process.exit(1);
  }
};

// Rastgele tarih üretme fonksiyonu
const randomDate = (start: Date, end: Date): Date => {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
};

// Rastgele eleman seçen fonksiyon
const getRandomElement = <T>(arr: T[]): T => {
    return arr[Math.floor(Math.random() * arr.length)];
};

// Rastgele üye seçme fonksiyonu
const getRandomMembers = async (count: number) => {
    const members = await MemberModel.find().select("_id").limit(100);
    return members.sort(() => 0.5 - Math.random()).slice(0, count).map(m => m._id);
};

// 10 tane test abonelik verisi oluştur
const generateSubscriptions = async () => {
    try {
        connectDB();
        const members = await getRandomMembers(100); // Rastgele 10 üye seç

        let subscriptions: ISubscription[] = [];
        for (let i = 0; i < 100; i++) {
            const paymentDate = randomDate(new Date(2024, 0, 1), new Date());
            const startDate = new Date(paymentDate);
            const endDate = new Date(startDate);
            endDate.setMonth(startDate.getMonth() + 1); // 1 aylık abonelik

            const subscription: ISubscription = new Subscription({
                memberId: members[i],
                sportType: getRandomElement(Object.values(SportTypes)),
                amount: Math.floor(Math.random() * 500) + 100, // 100-500 TL arası rastgele ödeme
                paymentMethod: getRandomElement(Object.values(PaymentMethods)),
                paymentDate,
                startDate,
                endDate,
            });

            subscriptions.push(subscription);
        }

        await Subscription.insertMany(subscriptions);
        console.log("100 adet test abonelik verisi başarıyla eklendi!");
        mongoose.connection.close();
    } catch (error) {
        console.error("Veri eklenirken hata oluştu:", error);
    }
};

// Çalıştır
generateSubscriptions();
