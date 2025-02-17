import { Router, Request, Response } from "express";
import { BaseResponseModel } from "../models/base_response";
import Member, { IMember } from "../models/member";

var response: BaseResponseModel;

const router = Router();

// Yeni üye ekle
router.post("/", async (req: Request, res: Response) => {
  try {
    const memberData: IMember = req.body;
    const newMember = new Member(memberData);
    const savedMember = await newMember.save();
    console.log("API POST: \"/member\" =>  Post request is successful");
    res.status(200).json(new BaseResponseModel(true, "Veri başarıyla eklendi", savedMember).toJson());
  } catch (error) {
    console.log(`API POST: "/member" => Post request failed. ${(error as Error).message}`);
    res.status(400).json(new BaseResponseModel(false, "Veri eklenirken hata oluştu.").toJson());
    //res.status(400).json({ error: (error as Error).message });
  }
});

// Tüm üyeleri getir
router.get("/", async (req: Request, res: Response) => {
  try {
    const members = await Member.find();
    console.log("API GET: \"/member\" =>  Succesfully read from database");
    res.status(200).send(new BaseResponseModel(
      true,
      "Veriler başarıyla yüklendi.",
      members).toJson(),);
  } catch (error) {
    console.log("API GET: \"/member\" =>  Database reading error");
    res.status(500).json({ error: (error as Error).message });
  }
});

// Belirli bir üyeyi getir
router.get("/:id", async (req, res) => {
  try {
    const member = await Member.findById(req.params.id);
    if (!member) {
      res.status(404).json({ message: "Üye bulunamadı" });
    }
    res.json(member);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

// Üyeyi güncelle
router.put("/:id", async (req, res) => {
  try {
    const updatedMember = await Member.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedMember) {
      res.status(404).json({ message: "Üye bulunamadı" });
    }
    res.json(updatedMember);
  } catch (error) {
    res.status(400).json({ error: (error as Error).message });
  }
});

// Üyeyi sil
router.delete("/:id", async (req: Request, res: Response) => {
  try {
    const deletedMember = await Member.findByIdAndDelete(req.params.id);
    if (!deletedMember) {
      res.status(404).json({ message: "Üye bulunamadı" });
    }
    res.json({ message: "Üye silindi" });
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

export default router;
