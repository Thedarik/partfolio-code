import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/section_title.dart';
import '../viewmodels/services_viewmodel.dart';

class ServicesPage extends StatefulWidget {
  final bool isDarkMode;

  const ServicesPage({super.key, required this.isDarkMode});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> with SingleTickerProviderStateMixin {
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
      create: (_) => ServicesViewModel(),
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
                const SectionTitle(title: 'Xizmatlar'),
                const SizedBox(height: 40),
                Consumer<ServicesViewModel>(
                  builder: (context, viewModel, child) => _buildServicesGrid(isMobile, viewModel.services),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesGrid(bool isMobile, List services) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildServiceCard(service, index, services.length),
        );
      },
    );
  }

  Widget _buildServiceCard(dynamic service, int index, int totalItems) {
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
          offset: Offset(0, (1 - animation.value) * 50), // Sahifa yuklanganda pastdan yuqoriga
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(0, _hoveredIndex == null || _hoveredIndex == index ? 0 : 10, 1 // Hover bo'lmagan kartalar tepaga ko'tariladi
              ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            // border: Border.all(color: const Color(0xFF252525), width: 2), // BlueAccent border
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  service.icon,
                  size: _hoveredIndex == index ? 45 : 40,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 15),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: _hoveredIndex == index ? 22 : 20,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                ),
                child: Text(service.title),
              ),
              const SizedBox(height: 10),
              Text(
                service.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
