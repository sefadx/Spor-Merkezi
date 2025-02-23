import { Router, Request, Response } from "express";
import { BaseResponseModel } from "../models/base_response";
import { Cities, Genders, EducationLevels, HealthStatus, PaymentStatus } from "../enums/lists";

var response: BaseResponseModel;
const router = Router();

router.get("/:id?", async (req: Request, res: Response) => {
    try {
        let list: String[] = [];
        /*switch (req.params.id != null ? req.params.id.toLowerCase() : "") {
            case "Cities".toLowerCase():
                list = Object.values(Cities);
                console.log(list);
                break;
            case "Genders":
                list = Object.values(Genders);
                console.log(list);
                break;
            case "EducationLevels":
                list = Object.values(EducationLevels);
                console.log(list);
                break;
            case "HealthStatusChecks":
                list = Object.values(HealthStatusChecks);
                console.log(list);
                break;
            case "PaymentStatus":
                list = Object.values(PaymentStatus);
                console.log(list);
                break;
            default:
                const map: Map<string, string[]> = new Map<string, string[]>([
                    ["Cities", Object.values(Cities)],
                    ["Genders", Object.values(Genders)],
                    ["EducationLevels", Object.values(EducationLevels)],
                    ["HealthStatusCheck", Object.values(HealthStatusChecks)],
                    ["PaymentStatus", Object.values(PaymentStatus)],
                ]);
                console.log(map);
                break;
        }*/

        const map: Map<string, string[]> = new Map<string, string[]>([
            ["Cities", Object.values(Cities)],
            ["Genders", Object.values(Genders)],
            ["EducationLevels", Object.values(EducationLevels)],
            ["HealthStatusCheck", Object.values(HealthStatus)],
            ["PaymentStatus", Object.values(PaymentStatus)],
        ]);
        console.log(map);
        console.log("API GET: \"/variables\" =>  Succesfully read");
        res.status(200).send(new
            BaseResponseModel(
                true,
                "Veriler başarıyla yüklendi.",
                Object.fromEntries(map)
            ).toJson(),);
    } catch (error) {
        console.log("API GET: \"/member\" =>  Database reading error");
        res.status(500).json({ error: (error as Error).message });
    }
});

export default router;