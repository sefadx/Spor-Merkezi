import mongoose from "mongoose";
import { faker } from "@faker-js/faker";
import Member from "../src/models/member"; // Model dosyanın yolunu güncelle
import { Cities, EducationLevels, Genders, HealthStatus, PaymentStatus } from "./enums/lists";

// 🔹 MongoDB bağlantısını aç
const connectDB = async () => {
  try {
    await mongoose.connect("mongodb://127.0.0.1:27017/spor_merkezi"); // Burayı kendi veritabanı bağlantı adresinle değiştir
    console.log("✅ MongoDB'ye başarıyla bağlandı!");
  } catch (error) {
    console.error("❌ MongoDB bağlantı hatası:", error);
    process.exit(1);
  }
};

// 🔹 100 sahte üye oluştur
const generateTestData = (count: number) => {
  const testData = [];
  for (let i = 0; i < count; i++) {
    testData.push({
      identityNumber: faker.string.numeric(11), // 11 haneli TC Kimlik Numarası
      name: faker.person.firstName(),
      surname: faker.person.lastName(),
      birthDate: faker.date.birthdate(),
      birthPlace: faker.helpers.arrayElement(Object.values(Cities)), // Enum değerlerine uygun olması için sabit bırakılabilir
      gender: faker.helpers.arrayElement(Object.values(Genders)),
      educationLevel: faker.helpers.arrayElement(Object.values(EducationLevels)),
      phoneNumber: faker.phone.number({ style: 'international' }),
      email: faker.internet.email(),
      address: faker.location.streetAddress(),
      emergencyContact: {
        name: faker.person.fullName(),
        phone: faker.phone.number({ style: 'international' }),
      },
      healthStatus: faker.helpers.arrayElement(Object.values(HealthStatus)),
      paymentStatus: faker.helpers.arrayElement(Object.values(PaymentStatus)),
      createdAt: new Date(),
    });
  }
  return testData;
};

// 🔹 Verileri MongoDB'ye ekle
const seedDatabase = async () => {
  await connectDB(); // Veritabanına bağlan
  try {
    const testData = generateTestData(100);
    await Member.insertMany(testData); // 📌 Verileri toplu ekle

    console.log("✅ 100 test verisi başarıyla eklendi!");
  } catch (error) {
    console.error("❌ Veri eklenirken hata oluştu:", error);
  } finally {
    mongoose.connection.close(); // Bağlantıyı kapat
  }
};

// 🔹 Çalıştır
seedDatabase();
