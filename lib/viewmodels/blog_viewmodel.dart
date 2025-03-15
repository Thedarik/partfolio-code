import 'package:flutter/material.dart';
import '../models/blog_model.dart';

class BlogViewModel with ChangeNotifier {
  final List<BlogModel> _blogs = [
    BlogModel(
      title: 'Flutterda State Management',
      description: 'Flutterda state managementni tushunish va qo\'llash.',
      link: 'https://example.com/flutter-state-management',
    ),
    BlogModel(
      title: 'UI/UX Dizayn Prinsiplari',
      description: 'Zamonaviy UI/UX dizayn prinsiplari va ularni qo\'llash.',
      link: 'https://example.com/ui-ux-principles',
    ),
    BlogModel(
      title: 'DevOps Asoslari',
      description: 'DevOps asoslari va ularni loyihalarga qo\'llash.',
      link: 'https://example.com/devops-basics',
    ),
  ];

  List<BlogModel> get blogs => _blogs;
}