import 'package:silivri_havuz/model/member_model.dart';
import 'package:silivri_havuz/model/trainer_model.dart';
import 'package:silivri_havuz/utils/enums.dart';

import '../network/api.dart';

class FileModel implements JsonProtocol {
  FileModel({
    required this.trainerModel,
    required this.memberModel,
    required this.approvalDate,
    required this.endOfValidity,
    required this.fileName,
    required this.reportType,
  });

  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;

  late TrainerModel trainerModel;
  late MemberModel memberModel;
  late String fileName;
  late ReportTypes reportType;
  late DateTime endOfValidity;
  late DateTime approvalDate;

  FileModel.fromJson({required Map<String, dynamic> json}) {}

  @override
  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerModel.id,
      'memberId': memberModel.id,
      'fileName': fileName,
      'endOfValidity': endOfValidity.toIso8601String(),
      'approvalDate': approvalDate.toIso8601String(),
      'reportType': reportType.toString()
    };
  }
}
