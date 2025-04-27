import '../network/api.dart';
import '../utils/enums.dart';
import 'member_model.dart';

class SubscriptionModel implements JsonProtocol {
  SubscriptionModel({
    required this.type,
    required this.ageGroup,
    required this.fee,
    required this.amount,
    required this.member,
    required this.paymentDate,
  });

  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;
  final ActivityType type;
  final AgeGroup ageGroup;
  final FeeType fee;
  final int amount;
  final MemberModel member;
  final DateTime paymentDate;

  factory SubscriptionModel.fromJson({required Map<String, dynamic> json}) {
    SubscriptionModel model = SubscriptionModel(
      type: ActivityType.fromString(json["type"]),
      ageGroup: AgeGroup.fromString(json["ageGroup"]),
      fee: FeeType.fromString(json["fee"]),
      amount: json["amount"],
      member: MemberModel.fromJson(json: json["memberId"]),
      paymentDate: DateTime.parse(json["paymentDate"]).toLocal(),
    );
    model._id = json["_id"];
    model._createdAt = DateTime.parse(json['createdAt']).toLocal();
    return model;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'memberId': member.toJson(),
      'type': type.toString(),
      'ageGroup': ageGroup.toString(),
      'fee': fee.toString(),
      'amount': amount.toString(),
      'paymentDate': paymentDate.toIso8601String(),
    };
  }
}

/*
import '../network/api.dart';
import '../utils/enums.dart';
import 'member_model.dart';

class SubscriptionModel implements JsonProtocol {
  SubscriptionModel({
    required this.sportType,
    required this.amount,
    required this.paymentMethods,
    required this.member,
    required this.paymentDate,
    required this.startDate,
    required this.endDate,
  });

  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;
  final SportTypes sportType;
  final int amount;
  final String paymentMethods;
  final MemberModel member;
  final DateTime paymentDate;
  final DateTime startDate;
  final DateTime endDate;

  factory SubscriptionModel.fromJson({required Map<String, dynamic> json}) {
    SubscriptionModel model = SubscriptionModel(
        sportType: SportTypes.fromString(json["sportType"]),
        amount: json["amount"],
        paymentMethods: json["paymentMethod"],
        member: MemberModel.fromJson(json: json["memberId"]),
        paymentDate: DateTime.parse(json["paymentDate"]).toLocal(),
        startDate: DateTime.parse(json['startDate']).toLocal(),
        endDate: DateTime.parse(json['endDate']).toLocal());
    model._id = json["_id"];
    model._createdAt = DateTime.parse(json['createdAt']).toLocal();
    return model;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'memberId': member.toJson(),
      'sportType': sportType.toString(),
      'amount': amount.toString(),
      'paymentMethod': paymentMethods.toString(),
      'paymentDate': paymentDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
 */
