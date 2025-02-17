import mongoose, { Schema, Document } from "mongoose";
import Member, { IMember } from "../models/member";

export interface ISession extends Document {
 createdAt: Date;
 sessionName: string;
 trainer: IMember;
 dateTimeStart: Date;
 dateTimeEnd: Date;
 members: IMember[];
}

const SessionSchema = new Schema({
 createdAt: { type: Date, default: Date.now },
 sessionName: { type: String, required: true },
 trainer: { type: Schema.Types.ObjectId, ref: "Member" },
 dateTimeStart: { type: Date, required: true },
 dateTimeEnd: { type: Date, required: true },
 members: [{ type: Schema.Types.ObjectId, ref: "Member" }],
});