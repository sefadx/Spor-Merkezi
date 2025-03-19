import { Types } from "mongoose";

export function validateIdentityNumber(tcNo: string): boolean {
    if (!/^[1-9][0-9]{10}$/.test(tcNo)) {
      return false;
    }
  
    const digits = tcNo.split('').map(Number);
    const oddSum = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    const evenSum = digits[1] + digits[3] + digits[5] + digits[7];
    const tenthDigit = ((oddSum * 7) - evenSum) % 10;
  
    if (tenthDigit !== digits[9]) return false;
  
    const sumAll = digits.slice(0, 10).reduce((acc, num) => acc + num, 0);
    const eleventhDigit = sumAll % 10;
  
    if (eleventhDigit !== digits[10]) return false;
  
    return true;
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