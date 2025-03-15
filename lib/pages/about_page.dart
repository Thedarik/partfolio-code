import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/section_title.dart';
import '../widgets/skills_list.dart';
import '../widgets/experience_card.dart';
import '../viewmodels/about_viewmodel.dart';

class AboutPage extends StatelessWidget {
  final bool isDarkMode;

  const AboutPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 800;

    return ChangeNotifierProvider(
      create: (_) => AboutViewModel(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode ? [const Color(0xFF1A1A1A), const Color(0xFF2D2D2D)] : [const Color(0xFFF5F5F5), const Color(0x00ffffff)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Men Haqimda'),
                const SizedBox(height: 40),
                isMobile ? _buildMobileAboutContent(context) : _buildDesktopAboutContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopAboutContent(BuildContext context) {
    final viewModel = Provider.of<AboutViewModel>(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Men Flutter dasturlashda 3,5 yillik tajribaga egaman',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Mobil dasturlash sohasida chuqur bilim va ko\'nikmalarga egaman. Men Flutter va Dart texnologiyalarini maqsadli ravishda o\'zlashtirganman va ulardan foydalanib bir qancha mobil ilovalarni ishlab chiqqanman. Java backend bilan ishlash tajribam ham bor, shuningdek DevOps sohasiga ham qiziqaman.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Ko\'rsata oladigan kuchli tomonlarim:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              SkillsList(isDarkMode: isDarkMode, skills: viewModel.skills),
            ],
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExperienceCard(
                icon: Icons.work,
                title: 'Ish tajriba',
                items: viewModel.experience,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 40),
              ExperienceCard(
                icon: Icons.lightbulb,
                title: 'Kelajak maqsadlarim',
                items: viewModel.goals,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileAboutContent(BuildContext context) {
    final viewModel = Provider.of<AboutViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Men Flutter dasturlashda 3,5 yillik tajribaga egaman',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'Mobil dasturlash sohasida chuqur bilim va ko\'nikmalarga egaman. Men Flutter va Dart texnologiyalarini maqsadli ravishda o\'zlashtirganman va ulardan foydalanib bir qancha mobil ilovalarni ishlab chiqqanman. Java backend bilan ishlash tajribam ham bor, shuningdek DevOps sohasiga ham qiziqaman.',
          style: TextStyle(
            fontSize: 16,
            height: 1.8,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'Ko\'rsata oladigan kuchli tomonlarim:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        SkillsList(isDarkMode: isDarkMode, skills: viewModel.skills),
        const SizedBox(height: 40),
        ExperienceCard(
          icon: Icons.work,
          title: 'Ish tajriba',
          items: viewModel.experience,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 40),
        ExperienceCard(
          icon: Icons.lightbulb,
          title: 'Kelajak maqsadlarim',
          items: viewModel.goals,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
}
