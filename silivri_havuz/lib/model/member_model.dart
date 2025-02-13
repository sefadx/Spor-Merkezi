import '../model/health_status.dart';
import '../model/payment_status.dart';

import '../network/api.dart';

class MemberModel implements JsonProtocol {
  String? createdAt;

  // Kişisel Bilgiler
  String identity;
  String name;
  String surname;
  DateTime birthDate;
  String birthPlace;
  String gender;
  String educationLevel;

  // İletişim Bilgileri
  String phoneNumber;
  String email;
  String address;

  // Acil Durum Kişi Bilgileri
  String emergencyContactName;
  String emergencyContactPhoneNumber;

  // Durum Kontrolü
  HealthStatus? healthStatusCheck = HealthStatus(text: "Kontrol Yapılmadı");
  PaymentStatus? paymentStatus = PaymentStatus(text: "Ödeme yapılmadı");

  MemberModel({
    this.createdAt,
    required this.identity,
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
    this.healthStatusCheck,
    this.paymentStatus,
  });

  // Üyeyi JSON formatına çevirme (örneğin, veritabanı için)
  @override
  Map<String, dynamic> toJson() {
    return {
      'identityNumber': identity,
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
    return MemberModel(
      createdAt: json['createdAt'],
      identity: json['identityNumber'],
      name: json['name'],
      surname: json['surname'],
      birthDate: DateTime.parse(json['birthDate']).toLocal(),
      birthPlace: json['birthPlace'],
      gender: json['gender'],
      educationLevel: json['educationLevel'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
      emergencyContactName: json['emergencyContact']['name'],
      emergencyContactPhoneNumber: json['emergencyContact']['phone'],
      healthStatusCheck: HealthStatus(text: json['healthStatusCheck']),
      paymentStatus: PaymentStatus(text: json['paymentStatus']),
    );
  }

  String get displayName => "$name $surname";
}
