import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contact_viewmodel.dart';

class ContactForm extends StatelessWidget {
  final bool isDarkMode;

  const ContactForm({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ContactViewModel>(context);

    return Column(
      children: [
        TextField(
          onChanged: (value) => viewModel.setName(value),
          decoration: InputDecoration(
            labelText: 'Ismingiz',
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) => viewModel.setEmail(value),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) => viewModel.setMessage(value),
          decoration: InputDecoration(
            labelText: 'Xabar',
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => viewModel.submitForm(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text('Xabarni Yuborish'),
        ),
      ],
    );
  }
}