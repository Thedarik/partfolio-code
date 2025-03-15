import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../providers/team_provider.dart';
import '../widgets/section_title.dart';

class TeamPage extends StatelessWidget {
  final bool isDarkMode;

  const TeamPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamProvider(),
      child: Consumer<TeamProvider>(
        builder: (context, teamProvider, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode ? [const Color(0xFF1A1A1A), const Color(0xFF2D2D2D)] : [const Color(0xFFF5F5F5), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'My Team'),
                    const SizedBox(height: 40),
                    _buildTeamContent(context, teamProvider),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamContent(BuildContext context, TeamProvider teamProvider) {
    if (teamProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (teamProvider.error != null) {
      return Center(child: Text('Error: ${teamProvider.error}'));
    } else if (teamProvider.teamMembers.isEmpty) {
      return const Center(child: Text('No team members found'));
    }

    return Column(
      children: [
        _buildTeamCarousel(context, teamProvider),
        const SizedBox(height: 20),
        _buildCarouselDots(teamProvider),
      ],
    );
  }

  Widget _buildTeamCarousel(BuildContext context, TeamProvider teamProvider) {
    final teamMembers = teamProvider.teamMembers;
    return CarouselSlider.builder(
      itemCount: teamMembers.length,
      itemBuilder: (context, index, realIndex) {
        final member = teamMembers[index];
        final isCenter = teamProvider.currentIndex == index;
        return _buildTeamCard(context, member, index, isCenter);
      },
      options: CarouselOptions(
        height: 450,
        viewportFraction: 0.35,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        onPageChanged: (index, reason) {
          teamProvider.setCurrentIndex(index);
        },
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, TeamMember member, int index, bool isCenter) {
    return _TeamCard(
      isDarkMode: isDarkMode,
      member: member,
      index: index,
      isCenter: isCenter,
    );
  }

  Widget _buildCarouselDots(TeamProvider teamProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        teamProvider.teamMembers.length,
        (index) => Container(
          width: teamProvider.currentIndex == index ? 12 : 8,
          height: teamProvider.currentIndex == index ? 12 : 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: teamProvider.currentIndex == index ? Colors.blueAccent : Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatefulWidget {
  final bool isDarkMode;
  final TeamMember member;
  final int index;
  final bool isCenter;

  const _TeamCard({
    required this.isDarkMode,
    required this.member,
    required this.index,
    required this.isCenter,
  });

  @override
  State<_TeamCard> createState() => __TeamCardState();
}

class __TeamCardState extends State<_TeamCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int? _hoveredIndex;

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
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = Duration(milliseconds: 300 * widget.index);
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
        onEnter: (_) => setState(() => _hoveredIndex = widget.index),
        onExit: (_) => setState(() => _hoveredIndex = null),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 300,
          height: 450,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          transform: Matrix4.translationValues(
            0,
            (_hoveredIndex == widget.index || widget.isCenter) ? -10 : 0,
            0,
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
                color: Colors.black.withOpacity((_hoveredIndex == widget.index || widget.isCenter) ? 0.3 : 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.member.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: (_hoveredIndex == widget.index || widget.isCenter) ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                  ),
                  child: Text(widget.member.name),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.member.position,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.member.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Skills:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ...widget.member.skills.map<Widget>((skill) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              skill.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: teamProvider.animationTriggered[widget.index] == true && widget.isCenter ? 0 : skill.level * 100,
                                end: teamProvider.animationTriggered[widget.index] == true && widget.isCenter ? skill.level * 100 : 0,
                              ),
                              duration: const Duration(seconds: 2),
                              builder: (context, value, child) {
                                return Text(
                                  '${value.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: teamProvider.animationTriggered[widget.index] == true && widget.isCenter ? 0 : skill.level,
                            end: teamProvider.animationTriggered[widget.index] == true && widget.isCenter ? skill.level : 0,
                          ),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: widget.isDarkMode ? Colors.grey[700] : Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(5),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
