import 'package:flutter/material.dart';

import '../model/health_status.dart';
import '../model/payment_status.dart';
import '../network/api.dart';
import '../utils/enums.dart';

class MemberModel implements JsonProtocol {
  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;
  // Kişisel Bilgiler
  late String identityNumber;
  late String name;
  late String surname;
  late DateTime birthDate;
  late Cities birthPlace;
  late Genders gender;
  late EducationLevels educationLevel;

  // İletişim Bilgileri
  late String phoneNumber;
  late String email;
  late String address;

  // Acil Durum Kişi Bilgileri
  late String emergencyContactName;
  late String emergencyContactPhoneNumber;

  // Durum Kontrolü
  late HealthStatus? healthStatus = HealthStatus(text: "Kontrol Yapılmadı");
  late PaymentStatus? paymentStatus = PaymentStatus(text: "Ödeme yapılmadı");

  MemberModel({
    required this.identityNumber,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.birthPlace,
    required this.gender,
    required this.educationLevel,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.emergencyContactName,
    required this.emergencyContactPhoneNumber,
    this.healthStatus,
    this.paymentStatus,
  });

  MemberModel.id({required String id}) {
    _id = id;
  }

  // Üyeyi JSON formatına çevirme (örneğin, veritabanı için)
  @override
  Map<String, dynamic> toJson() {
    return {
      'identityNumber': identityNumber,
      'name': name,
      'surname': surname,
      'birthDate': birthDate.toIso8601String(),
      'birthPlace': birthPlace,
      'gender': gender,
      'educationLevel': educationLevel,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'emergencyContact': {
        'name': emergencyContactName,
        'phone': emergencyContactPhoneNumber,
      },
    };
  }

  // JSON'dan Üye Sınıfına Çevirme
  factory MemberModel.fromJson({required Map<String, dynamic> json}) {
    try {
      MemberModel model = MemberModel(
        identityNumber: json['identityNumber'],
        name: json['name'],
        surname: json['surname'],
        birthDate: DateTime.parse(json['birthDate']).toLocal(),
        birthPlace: Cities.fromString(json['birthPlace']),
        gender: Genders.fromString(json['gender']),
        educationLevel: EducationLevels.fromString(json['educationLevel']),
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        address: json['address'],
        emergencyContactName: json['emergencyContact']['name'],
        emergencyContactPhoneNumber: json['emergencyContact']['phone'],
        healthStatus: HealthStatus(text: json['healthStatus']),
        paymentStatus: PaymentStatus(text: json['paymentStatus']),
      );
      model._id = json["_id"];
      model._createdAt = DateTime.parse(json['createdAt']).toLocal();
      return model;
    } catch (err) {
      debugPrint("MemberModel.fromJson() : $err");
      if (err.toString() == "type 'String' is not a subtype of type 'MemberModel'") {
        return MemberModel.id(id: json["_id"]);
      }
      rethrow;
    }
  }

  String get displayName => "$name $surname";
}
