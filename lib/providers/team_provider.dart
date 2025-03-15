import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Skill {
  final String name;
  final double level;

  Skill({required this.name, required this.level});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String,
      level: (json['level'] as num).toDouble(),
    );
  }
}

class TeamMember {
  final String name;
  final String position;
  final String image;
  final String description;
  final List<Skill> skills;

  TeamMember({
    required this.name,
    required this.position,
    required this.image,
    required this.description,
    required this.skills,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    var skillsList = json['skills'] as List;
    List<Skill> skills = skillsList.map((skill) => Skill.fromJson(skill)).toList();

    return TeamMember(
      name: json['name'] as String,
      position: json['position'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      skills: skills,
    );
  }
}

class TeamProvider with ChangeNotifier {
  List<TeamMember> _teamMembers = [];
  bool _isLoading = false;
  String? _error;

  List<TeamMember> get teamMembers => _teamMembers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final Map<int, bool> _animationTriggered = {};
  Map<int, bool> get animationTriggered => _animationTriggered;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  TeamProvider() {
    fetchTeamMembers();
  }

  Future<void> fetchTeamMembers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://67d4edaed2c7857431eee28f.mockapi.io/team'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _teamMembers = data.map((json) => TeamMember.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load team members';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    if (!_animationTriggered.containsKey(index)) {
      _animationTriggered[index] = true;
    }
    _currentIndex = index;
    notifyListeners();
  }
}