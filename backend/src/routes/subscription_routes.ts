import express, { Request, Response } from "express";
import Subscription, { ISubscription } from "../models/subscription";
import { BaseResponseModel } from "../models/base_response";
import Member, { IMember } from "../models/member";

const router = express.Router();

router.post("/", async (req: Request, res: Response) => {
    try {
        console.log('API POST: "/subscription" => Post request is successful');
        const { memberId, type, ageGroup, fee, amount, paymentDate } = req.body;

        const member = await Member.findById(memberId);
        if (!member) {
            res.status(400).json(new BaseResponseModel(false, "Üye kaydı bulunamadı").toJson());
        }

        // En güncel aboneliği kontrol et
        const latestSub = await Subscription.findOne({ memberId }).sort({ paymentDate: -1 });

        // Eğer varsa ve hala kredisi varsa, yeni abonelik oluşturulamaz
        if (latestSub && latestSub.credit > 0) {
            res.status(400).json(
                new BaseResponseModel(false, "Üyenin halen kullanmadığı kredi mevcut. Yeni abonelik tanımlanamaz.").toJson()
            );
        }

        const subscriptionData: ISubscription = req.body;
        const newSubscription = new Subscription(subscriptionData);
        const saved = await newSubscription.save();

        res.status(200).json(new BaseResponseModel(true, "Abonelik başarıyla oluşturuldu.", saved).toJson());
    } catch (error) {
        console.error("Abonelik oluşturulamadı:", error);
        res.status(400).json(new BaseResponseModel(false, "Abonelik oluşturulamadı.", error).toJson());
    }
});


/*
router.post("/", async (req: Request, res: Response) => {
    try {
      console.log('API POST: "/subscription" => Post request is successful');
      const { memberId, type, ageGroup, fee, amount, paymentDate } = req.body;
  
      const member = await Member.findById(memberId);
      if (!member) {
         res.status(400).json(new BaseResponseModel(false, "Üye kaydı bulunamadı").toJson());
      }
  
      // Aynı üyeye ait mevcut abonelik varsa ve kredisi 0'dan büyükse yeni abonelik yapılamaz
      const existing = await Subscription.findOne({ memberId });
      if (existing && existing.credit > 0) {
         res.status(400).json(new BaseResponseModel(false, "Üyenin halen kullanmadığı kredi mevcut. Yeni abonelik tanımlanamaz.").toJson());
      }
  
      // Önceki varsa sil ya da güncelle (isteğe bağlı)
      if (existing) {
        await Subscription.deleteOne({ _id: existing._id });
      }
  
      const subscriptionData: ISubscription = req.body;
      const newSubscription = new Subscription(subscriptionData);
      const saved = await newSubscription.save();
  
      res.status(200).json(new BaseResponseModel(true, "Abonelik başarıyla oluşturuldu.", saved).toJson());
    } catch (error) {
      console.error("Abonelik oluşturulamadı:", error);
      res.status(400).json(new BaseResponseModel(false, "Abonelik oluşturulamadı.", error).toJson());
    }
  });
  */

/*
// Yeni abonelik oluşturma 
router.post("/", async (req: Request, res: Response) => {
    try {
      console.log('API POST: "/subscription" => Post request is successful');
      console.log(req.body); // Gelen veriyi kontrol etmek için logla
  
      const { memberId, type, ageGroup, fee, amount, paymentDate } = req.body;
  
      // Zorunlu alan kontrolü
      if (!memberId || !type || !ageGroup || !fee || !amount || !paymentDate) {
        res.status(400).json(new BaseResponseModel(false, "Eksik abonelik verisi").toJson());
      }
  
      // Üye var mı kontrol et
      const member = await Member.findById(memberId);
      if (!member) {
        res.status(400).json(new BaseResponseModel(false, "Üye kaydı bulunamadı").toJson());
      }
  
      const subscriptions = await Subscription.find({ memberId });

      // Abonelik oluştur
      const subscriptionData: ISubscription = new Subscription({
        memberId,
        type, 
        ageGroup,
        fee,
        amount,
        paymentDate: new Date(paymentDate),
      });
  
      const newSubscription = new Subscription(subscriptionData);
      const savedSubscription = await newSubscription.save();
  
      console.log("Yeni abonelik kaydedildi:", savedSubscription);
      res.status(200).json(new BaseResponseModel(true, "Abonelik başarıyla oluşturuldu.", savedSubscription).toJson());
    } catch (error) {
      console.error("Abonelik oluşturulamadı:", error);
      res.status(400).json(new BaseResponseModel(false, "Abonelik oluşturulamadı.", (error as Error).message).toJson());
    }
  });*/
  
/*
// Yeni abonelik oluşturma
router.post("/", async (req: Request, res: Response) => {
    try {
        console.log('API POST: "/subscription" => Post request is successful');
        console.log(req.body); // Gelen veriyi kontrol etmek için logla
        const { memberId, type, ageGroup, fee, amount, paymentDate} = req.body;

        const member = await Member.findById(memberId);
            if (!member) {
              res.status(400).json(new BaseResponseModel(false, "Üye kaydı bulunamadı").toJson());
            }

        const subscriptionData: ISubscription = req.body;
        const newSubscription = new Subscription(subscriptionData);
        const savedSubscription = await newSubscription.save();
        console.log("Yeni abonelik kaydedildi:", savedSubscription);
        res.status(200).json(new BaseResponseModel(true, "Abonelik başarıyla oluşturuldu.", savedSubscription).toJson());
    } catch (error) {
        console.error("Abonelik oluşturulamadı:", error);
        res.status(400).json(new BaseResponseModel(false, "Abonelik oluşturulamadı.", error).toJson());
    }
}); 
*/
// API örneği: Üye adı, soyadı, T.C. no ve diğer alanlara göre filtreleme
router.get("/", async (req: Request, res: Response) => {
    try {
        console.log('API GET: "/subscription" => Get request is successful');
        console.log(req.query);

        const { search, type, ageGroup, fee } = req.query;
        const query: any = {};

        if (search && search !== "null") {
            query.$or = [
                { type: { $regex: search, $options: "i" } },
                { ageGroup: { $regex: search, $options: "i" } },
                { fee: { $regex: search, $options: "i" } }
            ];
        }

        const memberMatch: any = {};
        if (search && search !== "null") {
            memberMatch.$or = [
                { firstName: { $regex: search, $options: "i" } },
                { lastName: { $regex: search, $options: "i" } },
                { identityNumber: { $regex: search, $options: "i" } }
            ];
        }

        if (type) query.type = type;
        if (ageGroup) query.ageGroup = ageGroup;
        if (fee) query.fee = fee;

        // Eğer type, ageGroup veya fee varsa sadece kredi hakkı olanları getir
        if (type || ageGroup || fee) {
            query.credit = { $gt: 0 };
        }

        const subscriptions = await Subscription.find(query)
            .populate({
                path: "memberId",
                match: memberMatch
            })
            .sort({ paymentDate: -1 });

        const filtered = subscriptions.filter(sub => sub.memberId !== null);

        res.status(200).json(new BaseResponseModel(true, "Abonelikler başarıyla getirildi.", filtered).toJson());
    } catch (error) {
        console.error("Abonelik sorgulama hatası:", error);
        res.status(400).json(new BaseResponseModel(false, "Veri alınamadı.", error).toJson());
    }
});

// Belirli bir aboneliği getirme
router.get("/:id", async (req: Request, res: Response) => {
    try {
        console.log('API GET: "/subscription/:id" => Get request is successful');
        const subscription = await Subscription.find({memberId: req.params.id}).populate("memberId");
        if (!subscription) res.status(404).json(new BaseResponseModel(false, "Abonelik bulunamadı.").toJson());

        res.status(200).json(new BaseResponseModel(true, "Abonelik başarıyla getirildi.", subscription).toJson());
    } catch (error) {
        res.status(400).json(new BaseResponseModel(false, "Veri alınamadı.", error).toJson());
    }
}); 

// Aboneliği güncelleme
router.put("/:id", async (req: Request, res: Response) => {
    try {
        const updatedSubscription = await Subscription.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedSubscription) res.status(404).json(new BaseResponseModel(false, "Abonelik bulunamadı.").toJson());

        res.status(200).json(new BaseResponseModel(true, "Abonelik güncellendi.", updatedSubscription).toJson());
    } catch (error) {
        res.status(400).json(new BaseResponseModel(false, "Güncelleme başarısız.", error).toJson());
    }
});

/*
// Aboneliği silme
router.delete("/:id", async (req: Request, res: Response) => {
    try {
        const deletedSubscription = await Subscription.findByIdAndDelete(req.params.id);
        if (!deletedSubscription) res.status(404).json(new BaseResponseModel(false, "Abonelik bulunamadı.").toJson());

        res.status(200).json(new BaseResponseModel(true, "Abonelik silindi.", deletedSubscription).toJson());
    } catch (error) {
        res.status(400).json(new BaseResponseModel(false, "Silme başarısız.", error).toJson());
    }
});
*/

export default router;





//const subscriptions = await Subscription.find().populate("memberId");
//console.log(subscriptions); // Abonelikler üye bilgileriyle birlikte getirilir


//const expiredSubscriptions = await Subscription.find({ endDate: { $lt: new Date() } });
//console.log("Süresi dolmuş abonelikler:", expiredSubscriptions);
