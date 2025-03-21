import 'package:flutter/material.dart';

import '../model/member_model.dart';
import '../model/trainer_model.dart';
import '../utils/enums.dart';

import '../network/api.dart';

class FileModel implements JsonProtocol {
  FileModel({
    required this.trainerModel,
    required this.memberModel,
    required this.approvalDate,
    //required this.endOfValidity,
    required this.fileName,
    required this.fileSize,
    required this.reportType,
  });

  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;

  late final TrainerModel trainerModel;
  late final MemberModel memberModel;
  late final String fileName;
  late final String fileId;
  late final int fileSize;
  late final String mimeType;
  late final ReportTypes reportType;
  //late DateTime endOfValidity;
  late DateTime approvalDate;

  factory FileModel.fromJson({required Map<String, dynamic> json}) {
    debugPrint(json.toString());
    FileModel model = FileModel(
      trainerModel: TrainerModel.id(id: json["trainerId"]),
      memberModel: MemberModel.id(id: json["memberId"]),
      approvalDate: DateTime.parse(json["approvalDate"]).toLocal(),
      fileName: json["fileName"] ?? json["filename"],
      reportType: ReportTypes.fromString(json["reportType"]),
      fileSize: json["fileSize"],
    );
    model._id = json["_id"];
    model.fileId = json["fileId"];
    model.mimeType = json["mimeType"];
    model._createdAt = DateTime.parse(json["createdAt"]).toLocal();
    return model;
  }

  /*
  factory FileModel.fromJson({required Map<String, dynamic> json}) => FileModel(
    trainerModel: TrainerModel.id(id: json["trainerModel"]),
    memberModel: MemberModel.id(id: json["memberModel"]),
    approvalDate: json["approvalDate"],
    fileName: json["fileName"],
    reportType: ReportTypes.fromString(json["reportType"]),
  )..fileId = json["fileId"];
  */

  @override
  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerModel.id,
      'memberId': memberModel.id,
      'fileName': fileName,
      //'endOfValidity': endOfValidity.toIso8601String(),
      'approvalDate': approvalDate.toIso8601String(),
      'reportType': reportType.toString()
    };
  }
}
