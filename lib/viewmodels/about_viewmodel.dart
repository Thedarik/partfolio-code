import 'package:flutter/material.dart';
import '../models/skill_model.dart';

class AboutViewModel with ChangeNotifier {
  final List<SkillModel> _skills = [
    SkillModel(name: 'Flutter/Dart', level: 0.9),
    SkillModel(name: 'UI/UX Design', level: 0.7),
    SkillModel(name: 'Java', level: 0.8),
    SkillModel(name: 'Backend', level: 0.75),
    SkillModel(name: 'DevOps', level: 0.6),
  ];

  List<SkillModel> get skills => _skills;

  final List<String> _experience = [
    'Flutter Dasturchi - 3.5 yil',
    'Flutter Instruktor',
    'Java Backend tajriba',
    'DevOps qiziqish',
  ];

  List<String> get experience => _experience;

  final List<String> _goals = [
    'O\'z IT kompaniyasini yaratish',
    'Global innovatsion loyihalar',
    'O\'qitish va mentorliq',
    'DevOps ko\'nikmalarini rivojlantirish',
  ];

  List<String> get goals => _goals;
}