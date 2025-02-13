import 'package:flutter/material.dart';

class HomeScreenModel {
  HomeScreenModel({required this.title, required this.icon, this.body = const SizedBox()});
  IconData icon;
  String title;
  Widget body;
}
