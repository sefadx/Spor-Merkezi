import mongoose, { Schema, Document } from "mongoose";
import { Cities, EducationLevels, Genders, SportTypes } from "../enums/lists";

export interface ITrainer extends Document {
    createdAt?: Date;
    active?: boolean;
    identityNumber: string,
    name: string,
    surname: string,
    birthDate: Date,
    birthPlace: Cities,
    gender: Genders,
    educationLevel: string,
    phoneNumber: string,
    email: string,
    address: string,
    sportType?: SportTypes;
    students: Schema.Types.ObjectId[];
    deleted?: boolean;
}

const TrainerSchema = new Schema<ITrainer>({
    createdAt: { type: Date, default: Date.now, index: true },
    active: { type: Boolean, default: true },
    identityNumber: { type: String, required: true, unique: true },
    name: { type: String, required: true, trim: true },
    surname: { type: String, required: true, trim: true },
    birthDate: { type: Date, required: true },
    birthPlace: { type: String, required: true, enum: Object.values(Cities) },
    gender: { type: String, required: true, enum: Object.values(Genders) },
    educationLevel: { type: String, required: true, enum: Object.values(EducationLevels) },
    phoneNumber: { type: String, required: true },
    email: { type: String, required: true, lowercase: true, match: /.+\@.+\..+/ },
    address: { type: String, required: true, trim: true },
    sportType: { type: String, enum: Object.values(SportTypes) },
    students: [{ type: Schema.Types.ObjectId, ref: "Member" }],
    deleted: { type: Boolean, default: false },
},
    { timestamps: true });

export default mongoose.model<ITrainer>("Trainer", TrainerSchema);