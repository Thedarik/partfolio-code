import 'package:flutter/material.dart';
import '../models/project_model.dart';

class PortfolioViewModel with ChangeNotifier {
  final List<ProjectModel> _projects = [
    ProjectModel(
      title: 'E-commerce App',
      description: 'Flutter bilan yaratilgan to\'liq funksionallikdagi e-commerce ilovasi.',
      image: 'assets/project1.jpg',
      link: 'https://example.com/ecommerce',
    ),
    ProjectModel(
      title: 'Social Media App',
      description: 'Foydalanuvchilar uchun interfeysi sodda ijtimoiy tarmoq ilovasi.',
      image: 'assets/project2.jpg',
      link: 'https://example.com/socialmedia',
    ),
    ProjectModel(
      title: 'Task Manager',
      description: 'Vazifalarni boshqarish uchun qulay ilova.',
      image: 'assets/project3.jpg',
      link: 'https://example.com/taskmanager',
    ),
  ];

  List<ProjectModel> get projects => _projects;
}