import 'package:flutter/material.dart';
import '../models/service_model.dart';

class ServicesViewModel with ChangeNotifier {
  final List<ServiceModel> _services = [
    ServiceModel(
      icon: Icons.mobile_friendly,
      title: 'Mobil Ilovalar',
      description: 'Flutter yordamida yuqori sifatli mobil ilovalar yaratish.',
    ),
    ServiceModel(
      icon: Icons.design_services,
      title: 'UI/UX Dizayn',
      description: 'Zamonaviy va foydalanuvchi uchun qulay interfeyslar yaratish.',
    ),
    ServiceModel(
      icon: Icons.code,
      title: 'Backend Rivojlantirish',
      description: 'Java va boshqa texnologiyalar yordamida backend yechimlari.',
    ),
  ];

  List<ServiceModel> get services => _services;
}