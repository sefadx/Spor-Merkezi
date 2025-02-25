import express, { Request, Response } from "express";
import Subscription, { ISubscription } from "../models/subscription";
import { BaseResponseModel } from "../models/base_response";

const router = express.Router();

// Yeni abonelik oluşturma
router.post("/", async (req: Request, res: Response) => {
  try {
    const { memberId, amount, paymentMethod, startDate, endDate } = req.body;

    const subscriptionData: ISubscription = req.body;
    const newSubscription = new Subscription(subscriptionData);
    const savedSubscription = await newSubscription.save();
    res.status(200).json(new BaseResponseModel(true, "Abonelik başarıyla oluşturuldu.", savedSubscription).toJson());
  } catch (error) {
    res.status(400).json(new BaseResponseModel(false, "Abonelik oluşturulamadı.", error).toJson());
  }
});

// Abonelikleri listeleme
router.get("/", async (req: Request, res: Response) => {
  try {
    const subscriptions = await Subscription.find();//.populate("memberId", "name surname");
    res.status(200).json(new BaseResponseModel(true, "Abonelikler başarıyla getirildi.", subscriptions).toJson());
  } catch (error) {
    res.status(400).json(new BaseResponseModel(false, "Veri alınamadı.", error).toJson());
  }
});

// Belirli bir aboneliği getirme
router.get("/:id", async (req: Request, res: Response) => {
  try {
    const subscription = await Subscription.findById(req.params.id).populate("memberId");
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

export default router;





//const subscriptions = await Subscription.find().populate("memberId");
//console.log(subscriptions); // Abonelikler üye bilgileriyle birlikte getirilir


//const expiredSubscriptions = await Subscription.find({ endDate: { $lt: new Date() } });
//console.log("Süresi dolmuş abonelikler:", expiredSubscriptions);
