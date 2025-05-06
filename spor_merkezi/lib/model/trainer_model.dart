import 'package:flutter/material.dart';

import '/utils/enums.dart';
import '../network/api.dart';

class TrainerModel implements JsonProtocol {
  TrainerModel({
    required this.identity,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.birthPlace,
    required this.gender,
    required this.educationLevel,
    required this.sportType,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  TrainerModel.id({required String id}) {
    _id = id;
  }

  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;

  late SportTypes? sportType;

  // Kişisel Bilgiler
  late String identity;
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

  // Üyeyi JSON formatına çevirme (örneğin, veritabanı için)
  @override
  Map<String, dynamic> toJson() {
    return {
      'identityNumber': identity,
      'name': name,
      'surname': surname,
      'birthDate': birthDate.toIso8601String(),
      'birthPlace': birthPlace.toString(),
      'gender': gender.toString(),
      'educationLevel': educationLevel.toString(),
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }

  // JSON'dan Üye Sınıfına Çevirme
  factory TrainerModel.fromJson({required Map<String, dynamic> json}) {
    try {
      TrainerModel model = TrainerModel(
        identity: json['identityNumber'],
        name: json['name'],
        surname: json['surname'],
        birthDate: DateTime.parse(json['birthDate']).toLocal(),
        birthPlace: Cities.fromString(json['birthPlace']),
        gender: Genders.fromString(json['gender']),
        educationLevel: EducationLevels.fromString(json['educationLevel']),
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        address: json['address'],
        sportType: SportTypes.fromString(json["sportType"]),
      );
      model._id = json["_id"];
      model._createdAt = DateTime.parse(json['createdAt']).toLocal();
      return model;
    } catch (err) {
      debugPrint(err.toString());
      if (err.toString() == "type 'String' is not a subtype of type 'TrainerModel'") {
        return TrainerModel.id(id: json["_id"]);
      }
      rethrow;
    }
  }

  String get displayName => "$name $surname";
  String get dropdownText => "$displayName $identity";
}
