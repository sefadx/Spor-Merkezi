import mongoose, { Schema, Document } from "mongoose";
import Member, { IMember } from "../models/member";

export interface ISession extends Document {
 createdAt: Date;
 sessionName: string;
 trainer: IMember;
    members: IMember[];
}