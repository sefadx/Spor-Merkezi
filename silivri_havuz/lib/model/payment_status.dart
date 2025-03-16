import 'package:flutter/material.dart';

class PaymentStatus {
  PaymentStatus({required this.text}) {
    switch (text) {
      case "Ödeme Yapıldı":
        _color = Colors.green;
      case "Ödeme Yapılmadı":
        _color = Colors.red;
      default:
        _color = Colors.grey;
    }
  }
  final String text;
  Color _color = Colors.black;
  Color get color => _color;
}
