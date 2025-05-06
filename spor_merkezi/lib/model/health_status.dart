import 'package:flutter/material.dart';

class HealthStatus {
  HealthStatus({required this.text}) {
    switch (text) {
      case "Sağlıklı":
        _color = Colors.green;
        break;
      case "Kontrol Ediliyor":
        _color = Colors.amber;
        break;
      case "Hasta":
        _color = Colors.black;
        break;
      case "Kontrol Yapılmadı":
        _color = Colors.red;
        break;

      default:
        _color = Colors.grey;
    }
  }
  final String text;
  Color _color = Colors.grey;
  Color get color => _color;
}
