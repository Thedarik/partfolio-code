import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:me_partfolio/pages/team_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // http paketini import qilamiz
import '../widgets/nav_item.dart';
import '../pages/about_page.dart';
import '../pages/portfolio_page.dart';
import '../pages/services_page.dart';
import '../pages/blog_page.dart';
import '../pages/contact_page.dart';
import '../viewmodels/home_viewmodel.dart';

class HomePage extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _blogKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _teamKey = GlobalKey();

  int _currentIndex = 0;
  bool _isScrolling = false;
  int _visitorCount = 0; // Hisoblagich uchun o‘zgaruvchi

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchAndUpdateVisitorCount(); // API-dan hisoblagichni olish va yangilash
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // API-dan hisoblagichni olish va yangilash
  Future<void> _fetchAndUpdateVisitorCount() async {
    try {
      // API-dan joriy hisoblagichni olish
      final response = await http.get(Uri.parse('https://67d4edaed2c7857431eee28f.mockapi.io/web_view'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _visitorCount = int.parse(data[0]['number'].toString());
          });

          // Hisoblagichni 1 ga oshirish va API-ga qayta yuborish
          final updatedCount = _visitorCount + 1;
          await http.put(
            Uri.parse('https://67d4edaed2c7857431eee28f.mockapi.io/web_view/1'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'number': updatedCount}),
          );

          // Yangilangan qiymatni UI-da ko‘rsatish
          setState(() {
            _visitorCount = updatedCount;
          });
        }
      } else {
        print('Error fetching visitor count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _scrollListener() {
    if (_isScrolling) return;

    double homePos = _getPositionOfKey(_homeKey);
    double aboutPos = _getPositionOfKey(_aboutKey);
    double portfolioPos = _getPositionOfKey(_portfolioKey);
    double servicesPos = _getPositionOfKey(_servicesKey);
    double blogPos = _getPositionOfKey(_blogKey);
    double contactPos = _getPositionOfKey(_contactKey);
    double teamPos = _getPositionOfKey(_teamKey);

    double currentScroll = _scrollController.position.pixels;

    if (currentScroll < aboutPos - 100) {
      _updateIndex(0);
    } else if (currentScroll < portfolioPos - 100) {
      _updateIndex(1);
    } else if (currentScroll < servicesPos - 100) {
      _updateIndex(2);
    } else if (currentScroll < blogPos - 100) {
      _updateIndex(3);
    } else if (currentScroll < contactPos - 100) {
      _updateIndex(4);
    } else if (currentScroll < teamPos - 100) {
      _updateIndex(5);
    } else {
      _updateIndex(6);
    }
  }

  void _updateIndex(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  double _getPositionOfKey(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0;
    return renderBox.localToGlobal(Offset.zero).dy;
  }

  void _scrollToSection(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _isScrolling = true;
    double position = renderBox.localToGlobal(Offset.zero).dy;
    _scrollController
        .animateTo(
      position - 80,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    )
        .then((_) {
      _isScrolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        title: isMobile
            ? const Text('Samandar Eshpulatov')
            : Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/IMG_1256.JPG'),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Samandar Eshpulatov',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        actions: [
          if (!isMobile) ...[
            NavItem(title: 'Bosh sahifa', index: 0, currentIndex: _currentIndex, keyl: _homeKey, onTap: _scrollToSection, isDarkMode: widget.isDarkMode),
            NavItem(title: 'Men haqimda', index: 1, currentIndex: _currentIndex, keyl: _aboutKey, onTap: _scrollToSection, isDarkMode: widget.isDarkMode),
            NavItem(title: 'Portfolio', index: 2, currentIndex: _currentIndex, keyl: _portfolioKey, onTap: _scrollToSection, isDarkMode: widget.isDarkMode),
            NavItem(title: 'Xizmatlar', index: 3, currentIndex: _currentIndex, keyl: _servicesKey, onTap: _scrollToSection, isDarkMode: widget.isDarkMode),
            NavItem(title: 'Blog', index: 4, currentIndex: _currentIndex, keyl: _blogKey, onTap: _scrollToSection, isDarkMode: widget.isDarkMode),
            NavItem(title: 'Team', index: 5, currentIndex: _currentIndex, keyl: _teamKey, onTap: _scrollToSection, isDarkMode: widget.isDarkMode),
            NavItem(title: 'Aloqa', index: 6, currentIndex: _currentIndex, keyl: _contactKey, onTap: _scrollToSection, isDarkMode: widget.isDarkMode),
          ],
          // Hisoblagichni AppBar ichida ko‘rsatish
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility,
                    size: 18,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_visitorCount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<HomeViewModel>(
            builder: (context, viewModel, child) => IconButton(
              icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => widget.toggleTheme(),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: isMobile ? _buildDrawer() : null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/background_images.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.2),
            ],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                key: _homeKey,
                height: screenSize.height * 0.9,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
                    child: isMobile ? _buildMobileHomeContent() : _buildDesktopHomeContent(),
                  ),
                ),
              ),
              AboutPage(key: _aboutKey, isDarkMode: widget.isDarkMode),
              PortfolioPage(key: _portfolioKey, isDarkMode: widget.isDarkMode),
              ServicesPage(key: _servicesKey, isDarkMode: widget.isDarkMode),
              BlogPage(key: _blogKey, isDarkMode: widget.isDarkMode),
              TeamPage(key: _teamKey, isDarkMode: widget.isDarkMode),
              ContactPage(key: _contactKey, isDarkMode: widget.isDarkMode),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: widget.isDarkMode ? const Color(0xFF121212) : Colors.white,
                child: Center(
                  child: Text(
                    '© ${DateTime.now().year} Samandar Eshpulatov. Barcha huquqlar himoyalangan.',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.arrow_upward),
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/IMG_1256.JPG'),
                  radius: 40,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Samandar Eshpulatov',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Flutter Developer & Instructor',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Bosh sahifa'),
            selected: _currentIndex == 0,
            onTap: () {
              _scrollToSection(_homeKey);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Men haqimda'),
            selected: _currentIndex == 1,
            onTap: () {
              _scrollToSection(_aboutKey);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Portfolio'),
            selected: _currentIndex == 2,
            onTap: () {
              _scrollToSection(_portfolioKey);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.design_services),
            title: const Text('Xizmatlar'),
            selected: _currentIndex == 3,
            onTap: () {
              _scrollToSection(_servicesKey);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Blog'),
            selected: _currentIndex == 4,
            onTap: () {
              _scrollToSection(_blogKey);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Team'),
            selected: _currentIndex == 5,
            onTap: () {
              _scrollToSection(_teamKey);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Aloqa'),
            selected: _currentIndex == 6,
            onTap: () {
              _scrollToSection(_contactKey);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          Consumer<HomeViewModel>(
            builder: (context, viewModel, child) => ListTile(
              leading: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              title: Text(widget.isDarkMode ? 'Yorug\' rejim' : 'Qorong\'u rejim'),
              onTap: () {
                widget.toggleTheme();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHomeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Salom, men',
                style: TextStyle(
                  fontSize: 24,
                  color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Samandar\nEshpulatov',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flutter Dasturchi',
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Instruktor',
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Innovator',
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  repeatForever: true,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _scrollToSection(_contactKey),
                    icon: const Icon(Icons.work),
                    label: const Text('Meni Ishga Oling'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton.icon(
                    onPressed: () => _scrollToSection(_portfolioKey),
                    icon: const Icon(Icons.visibility),
                    label: const Text('Mening Ishlarim'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  _buildSocialButton(FontAwesomeIcons.telegram, 'https://t.me/samandar_eshpulatov'),
                  _buildSocialButton(FontAwesomeIcons.linkedin, 'https://linkedin.com/in/samandar-eshpulatov'),
                  _buildSocialButton(FontAwesomeIcons.github, 'https://github.com/Thedarik'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.1),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
              width: 4,
            ),
            image: const DecorationImage(
              image: AssetImage('assets/images/IMG_1256.JPG'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.1),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
              width: 4,
            ),
            image: const DecorationImage(
              image: AssetImage('assets/profile.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Salom, men',
          style: TextStyle(
            fontSize: 18,
            color: widget.isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Samandar Eshpulatov',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 40,
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Flutter Dasturchi',
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Instruktor',
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Innovator',
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            repeatForever: true,
          ),
        ),
        const SizedBox(height: 30),
        Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => _scrollToSection(_contactKey),
              icon: const Icon(Icons.work),
              label: const Text('Meni Ishga Oling'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () => _scrollToSection(_portfolioKey),
              icon: const Icon(Icons.visibility),
              label: const Text('Mening Ishlarim'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(FontAwesomeIcons.telegram, 'https://t.me/samandar_eshpulatov'),
            _buildSocialButton(FontAwesomeIcons.linkedin, 'https://linkedin.com/in/samandar-eshpulatov'),
            _buildSocialButton(FontAwesomeIcons.github, 'https://github.com/Thedarik'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String url) {
    return IconButton(
      icon: FaIcon(icon),
      onPressed: () => _launchUrl(url),
      iconSize: 24,
      color: Colors.blue,
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
