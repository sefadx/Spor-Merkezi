import mongoose, { Schema, Document } from "mongoose";
import { SportTypes } from "../enums/lists";

export interface ISession {
    dateTimeStart: string;
    dateTimeEnd: string;
    capacity: Number;
    mainMembers: Schema.Types.ObjectId[];
    waitingMembers: Schema.Types.ObjectId[];
}

export interface IActivity {
    sessionModel?: ISession | null;
    type: string;       // ActivityType Enum -> string olarak saklanabilir
    ageGroup: string;   // AgeGroup Enum
    fee: string;        // FeeType Enum
}

export interface IDay {
    name: string;
    day: number;
    activities: (IActivity | null)[];
}

export interface IWeek {

    initialDayOfWeek: Date;
    days: IDay[];
}

export interface ITableModel extends Document {
    createdAt: Date;
    week: IWeek;
}

const SessionSchema: Schema = new Schema<ISession>({
    dateTimeStart: { type: String, required: true },
    dateTimeEnd: { type: String, required: true },
    capacity: { type: Number, required: true },
    mainMembers: [{ type: Schema.Types.ObjectId, ref: "Member" }],
    waitingMembers: [{ type: Schema.Types.ObjectId, ref: "Member" }],
});

const ActivitySchema: Schema = new Schema<IActivity>({
    sessionModel: { type: SessionSchema, default: null },
    type: { type: String, required: true },
    ageGroup: { type: String, required: true },
    fee: { type: String, required: true },
});

const DaySchema: Schema = new Schema<IDay>({
    name: { type: String, required: true },
    day: { type: Number, required: true },
    activities: [{ type: ActivitySchema, default: null }]
});

const WeekSchema: Schema = new Schema<IWeek>({
    initialDayOfWeek: { type: Date, required: true, index: true },
    days: [DaySchema]
},
    { timestamps: true });

export default mongoose.model<ITableModel>('TableModel', WeekSchema);


/*
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



  final List<TimeSlot> timeSlots = [
    TimeSlot(start: "08:30", end: "09:30", isBreak: false),
    TimeSlot(start: "09:30", end: "10:00", isBreak: true),
    TimeSlot(start: "10:00", end: "11:00", isBreak: false),
    TimeSlot(start: "11:00", end: "11:30", isBreak: true),
    TimeSlot(start: "11:30", end: "12:30", isBreak: false),
    TimeSlot(start: "12:30", end: "13:00", isBreak: true),
    TimeSlot(start: "13:00", end: "14:00", isBreak: false),
    TimeSlot(start: "14:00", end: "14:30", isBreak: true),
    TimeSlot(start: "14:30", end: "15:30", isBreak: false),
    TimeSlot(start: "15:30", end: "16:00", isBreak: true),
    TimeSlot(start: "16:00", end: "17:00", isBreak: false),
    TimeSlot(start: "17:00", end: "17:30", isBreak: true),
    TimeSlot(start: "17:30", end: "18:30", isBreak: false),
    TimeSlot(start: "18:30", end: "19:00", isBreak: true),
    TimeSlot(start: "19:00", end: "20:00", isBreak: false),
    TimeSlot(start: "20:00", end: "20:30", isBreak: true),
    TimeSlot(start: "20:30", end: "21:30", isBreak: false),
  ];

    */
