import 'package:flutter/material.dart';
import '../models/contact_model.dart';

class ContactViewModel with ChangeNotifier {
  final List<ContactModel> _contacts = [
    ContactModel(
      icon: Icons.email,
      title: 'Email',
      value: 'samandar.eshpulatov@gmail.com',
      url: 'mailto:samandar.eshpulatov@gmail.com',
    ),
    ContactModel(
      icon: Icons.phone,
      title: 'Telefon',
      value: '+998 99 999 99 99',
      url: 'tel:+998999999999',
    ),
    ContactModel(
      icon: Icons.location_on,
      title: 'Manzil',
      value: 'Toshkent, O\'zbekiston',
      url: 'https://maps.google.com/?q=Tashkent,Uzbekistan',
    ),
  ];

  List<ContactModel> get contacts => _contacts;

  String _name = '';
  String _email = '';
  String _message = '';

  String get name => _name;
  String get email => _email;
  String get message => _message;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void submitForm() {
    // Xabar yuborish logikasi bu yerga qo'shiladi
    print('Name: $_name, Email: $_email, Message: $_message');
  }
}