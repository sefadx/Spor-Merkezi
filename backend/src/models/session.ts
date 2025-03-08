import mongoose, { Schema, Document } from "mongoose";
import { SportTypes } from "../enums/lists";

export interface ISession extends Document {
    createdAt: Date;
    sportType: SportTypes;
    trainer: Schema.Types.ObjectId;
    dateTimeStart: Date;
    dateTimeEnd: Date;
    capacity: Number;
    mainMembers: Schema.Types.ObjectId[];
    waitingMembers: Schema.Types.ObjectId[];
    deleted?: Boolean;
}

const SessionSchema = new Schema<ISession>({
    createdAt: { type: Date, default: Date.now, index: true },
    sportType: { type: String, required: true, enum: Object.values(SportTypes) },
    trainer: { type: Schema.Types.ObjectId, ref: "Trainer" },
    dateTimeStart: { type: Date, required: true, index: true },
    dateTimeEnd: { type: Date, required: true },
    mainMembers: [{ type: Schema.Types.ObjectId, ref: "Member" }],
    waitingMembers: [{ type: Schema.Types.ObjectId, ref: "Member" }],
    capacity: { type: Number, required: true },
    deleted: { type: Boolean, default: false },
},
    { timestamps: true });

export default mongoose.model<ISession>("Session", SessionSchema);