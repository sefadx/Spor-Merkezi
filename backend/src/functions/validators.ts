import { Types } from "mongoose";

export function validateTCKN(tckn: string): boolean {
  if (!/^[1-9][0-9]{10}$/.test(tckn)) {
    return false; // 11 haneli olmalı ve ilk hanesi 0 olamaz
  }

  const digits = tckn.split('').map(Number);

  const sumOdd = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
  const sumEven = digits[1] + digits[3] + digits[5] + digits[7];

  const check10 = ((sumOdd * 7) - sumEven) % 10;
  const check11 = (sumOdd + sumEven + digits[9]) % 10;

  return digits[9] === check10 && digits[10] === check11;
}

  /**
 * ObjectId güvenli dönüşüm fonksiyonu
 * Geçerli bir ObjectId oluşturma işlemini güvenli hale getirir
 */
export function safeObjectId(id: string): Types.ObjectId | null {
  try {
    return new Types.ObjectId(id);
  } catch (error) {
    return null;
  }
}