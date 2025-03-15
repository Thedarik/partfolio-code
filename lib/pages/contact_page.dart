import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/section_title.dart';
import '../widgets/contact_info.dart';
import '../widgets/contact_form.dart';
import '../viewmodels/contact_viewmodel.dart';

class ContactPage extends StatelessWidget {
  final bool isDarkMode;

  const ContactPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 800;

    return ChangeNotifierProvider(
      create: (_) => ContactViewModel(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Aloqa'),
                const SizedBox(height: 30),
                isMobile ? _buildMobileContactContent() : _buildDesktopContactContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopContactContent() {
    return Consumer<ContactViewModel>(
      builder: (context, viewModel, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aloqa uchun ma\'lumotlar',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Agar sizda savollar yoki takliflar bo\'lsa, menga quyidagi ma\'lumotlar orqali murojaat qilishingiz mumkin:',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                ContactInfo(isDarkMode: isDarkMode, contacts: viewModel.contacts),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xabar yuborish',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ContactForm(isDarkMode: isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileContactContent() {
    return Consumer<ContactViewModel>(
      builder: (context, viewModel, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aloqa uchun ma\'lumotlar',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Agar sizda savollar yoki takliflar bo\'lsa, menga quyidagi ma\'lumotlar orqali murojaat qilishingiz mumkin:',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          ContactInfo(isDarkMode: isDarkMode, contacts: viewModel.contacts),
          const SizedBox(height: 30),
          const Text(
            'Xabar yuborish',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ContactForm(isDarkMode: isDarkMode),
        ],
      ),
    );
  }
}