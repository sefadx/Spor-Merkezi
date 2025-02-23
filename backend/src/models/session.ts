import mongoose, { Schema, Document } from "mongoose";
import { IMember } from "../models/member";

export interface ISession extends Document {
    createdAt: Date;
    sessionName: string;
    trainer: Schema.Types.ObjectId;
    dateTimeStart: Date;
    dateTimeEnd: Date;
    capacity: Number;
    members: Schema.Types.ObjectId[];
}

const SessionSchema = new Schema<ISession>({
    createdAt: { type: Date, default: Date.now, index: true },
    sessionName: { type: String, required: true, trim: true },
    trainer: { type: Schema.Types.ObjectId, ref: "Member" },
    dateTimeStart: { type: Date, required: true, index: true },
    dateTimeEnd: { type: Date, required: true },
    members: [{ type: Schema.Types.ObjectId, ref: "Member" }],
},
    { timestamps: true });

export default mongoose.model<ISession>("Session", SessionSchema);