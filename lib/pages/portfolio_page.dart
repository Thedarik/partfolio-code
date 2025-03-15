import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/section_title.dart';
import '../viewmodels/portfolio_viewmodel.dart';

class PortfolioPage extends StatefulWidget {
  final bool isDarkMode;

  const PortfolioPage({super.key, required this.isDarkMode});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int? _hoveredIndex; // Hover qilingan karta indeksi

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 800;

    return ChangeNotifierProvider(
      create: (_) => PortfolioViewModel(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDarkMode ? [const Color(0xFF1A1A1A), const Color(0xFF2D2D2D)] : [const Color(0xFFF5F5F5), Colors.white],
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
                const SectionTitle(title: 'Portfolio'),
                const SizedBox(height: 40),
                Consumer<PortfolioViewModel>(
                  builder: (context, viewModel, child) => _buildPortfolioGrid(isMobile, viewModel.projects),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioGrid(bool isMobile, List projects) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.3,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildPortfolioCard(project, index, projects.length),
        );
      },
    );
  }

  Widget _buildPortfolioCard(dynamic project, int index, int totalItems) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = Duration(milliseconds: 300 * index);
        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              delay.inMilliseconds / 1500,
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        );

        return Transform.translate(
          offset: Offset(0, (1 - animation.value) * 50),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = null),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _launchUrl(project.link),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform:
                Matrix4.translationValues(0, _hoveredIndex == null || _hoveredIndex == index ? 0 : 10, 1 // Hover bo'lganda boshqa kartalar tepaga ko'tariladi
                    ),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: widget.isDarkMode ? [const Color(0xFF252525), const Color(0xFF3A3A3A)] : [Colors.white, const Color(0xFFF0F0F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_hoveredIndex == index ? 0.3 : 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Stack(
                      children: [
                        Image.asset(
                          project.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(_hoveredIndex == index ? 0.5 : 0.3),
                                  Colors.black.withOpacity(_hoveredIndex == index ? 0.2 : 0.1),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: _hoveredIndex == index ? 22 : 20,
                          fontWeight: FontWeight.bold,
                          color: widget.isDarkMode ? Colors.white : Colors.black87,
                        ),
                        child: Text(project.title),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.blueAccent,
                            size: _hoveredIndex == index ? 22 : 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
