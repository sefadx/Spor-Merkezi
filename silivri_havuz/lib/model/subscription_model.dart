import '../network/api.dart';
import '../utils/enums.dart';
import 'member_model.dart';

class SubscriptionModel implements JsonProtocol {
  SubscriptionModel({
    required this.sportType,
    required this.amount,
    required this.paymentMethods,
    required this.memberId,
    required this.paymentDate,
    required this.startDate,
    required this.endDate,
  });

  final SporTypes sportType;
  final int amount;
  final PaymentMethods paymentMethods;
  final String memberId;
  final DateTime paymentDate;
  final DateTime startDate;
  final DateTime endDate;

  factory SubscriptionModel.fromJson({required Map<String, dynamic> json}) {
    return SubscriptionModel(
        sportType: json["sportType"],
        amount: json["amount"],
        paymentMethods: json["paymentMethods"],
        memberId: json["memberId"],
        paymentDate: json["paymentDate"],
        startDate: json["startDate"],
        endDate: json["endDate"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'sportType': sportType.toString(),
      'amount': amount.toString(),
      'paymentMethod': paymentMethods.toString(),
      'paymentDate': paymentDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
