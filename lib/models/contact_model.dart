import 'package:flutter/material.dart';

class ContactModel {
  final IconData icon;
  final String title;
  final String value;
  final String url;

  ContactModel({
    required this.icon,
    required this.title,
    required this.value,
    required this.url,
  });
}