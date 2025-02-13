import 'package:intl/intl.dart';

import '../network/api.dart';
import '../utils/extension.dart';
import 'member_model.dart';

class SessionModel implements JsonProtocol {
  SessionModel({required this.sessionName, required this.trainerName, required this.date, required this.capacity, required this.participants});

  final String sessionName, trainerName;
  final DateTime date;
  String get dateString => format.format(date);

  /// DateTime dateTimeStart dateTimeEnd değişkenleri oluşturulacak controllerden alınan text veriler utc 8086 formatına dönüştürülüp veritabanına dateTimeStart ve dateTimeEnd olarak Date tipinde kaydedilecek.

  final int capacity;
  final List<MemberModel> participants;

  factory SessionModel.fromJson({required Map<String, dynamic> json}) {
    return SessionModel(
        sessionName: json["sessionName"],
        trainerName: json["trainerName"],
        date: json["date"],
        capacity: json["capacity"],
        participants: json["participants"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionName': sessionName,
      'trainerName': trainerName,
      'date': date.millisecondsSinceEpoch,
      'capacity': capacity,
      'participants': participants,
    };
  }
}
