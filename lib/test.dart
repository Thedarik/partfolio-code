// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

// // Portfolio ilovasining asosiy widgeti
// class PortfolioApp extends StatefulWidget {
//   const PortfolioApp({super.key});

//   @override
//   State<PortfolioApp> createState() => _PortfolioAppState();
// }

// class _PortfolioAppState extends State<PortfolioApp> {
//   bool isDarkMode = true; // Qorong'u rejim holati

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Samandar Eshpulatov | Portfolio',
//       theme: ThemeData(
//         brightness: isDarkMode ? Brightness.dark : Brightness.light,
//         primarySwatch: Colors.blue,
//         fontFamily: GoogleFonts.poppins().fontFamily,
//         scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
//       ),
//       home: HomePage(
//         toggleTheme: () {
//           setState(() {
//             isDarkMode = !isDarkMode; // Rejimni almashtirish
//           });
//         },
//         isDarkMode: isDarkMode,
//       ),
//     );
//   }
// }

// // Asosiy sahifa widgeti
// class HomePage extends StatefulWidget {
//   final Function toggleTheme;
//   final bool isDarkMode;

//   const HomePage({
//     super.key,
//     required this.toggleTheme,
//     required this.isDarkMode,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final ScrollController _scrollController = ScrollController();
//   final GlobalKey _homeKey = GlobalKey();
//   final GlobalKey _aboutKey = GlobalKey();
//   final GlobalKey _portfolioKey = GlobalKey();
//   final GlobalKey _servicesKey = GlobalKey();
//   final GlobalKey _blogKey = GlobalKey();
//   final GlobalKey _contactKey = GlobalKey();

//   int _currentIndex = 0; // Joriy bo'lim indeksi
//   bool _isScrolling = false; // Skroll holati

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener); // Skroll tinglovchisini qo'shish
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollListener() {
//     if (_isScrolling) return;

//     double homePos = _getPositionOfKey(_homeKey);
//     double aboutPos = _getPositionOfKey(_aboutKey);
//     double portfolioPos = _getPositionOfKey(_portfolioKey);
//     double servicesPos = _getPositionOfKey(_servicesKey);
//     double blogPos = _getPositionOfKey(_blogKey);
//     double contactPos = _getPositionOfKey(_contactKey);

//     double currentScroll = _scrollController.position.pixels;

//     if (currentScroll < aboutPos - 100) {
//       _updateIndex(0);
//     } else if (currentScroll < portfolioPos - 100) {
//       _updateIndex(1);
//     } else if (currentScroll < servicesPos - 100) {
//       _updateIndex(2);
//     } else if (currentScroll < blogPos - 100) {
//       _updateIndex(3);
//     } else if (currentScroll < contactPos - 100) {
//       _updateIndex(4);
//     } else {
//       _updateIndex(5);
//     }
//   }

//   void _updateIndex(int index) {
//     if (_currentIndex != index) {
//       setState(() {
//         _currentIndex = index;
//       });
//     }
//   }

//   double _getPositionOfKey(GlobalKey key) {
//     final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox == null) return 0;
//     return renderBox.localToGlobal(Offset.zero).dy;
//   }

//   void _scrollToSection(GlobalKey key) {
//     final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox == null) return;

//     _isScrolling = true;
//     double position = renderBox.localToGlobal(Offset.zero).dy;
//     _scrollController
//         .animateTo(
//       position - 80, // AppBar uchun offset
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     )
//         .then((_) {
//       _isScrolling = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isMobile = screenSize.width < 800;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
//         elevation: 0,
//         title: isMobile
//             ? const Text('Samandar Eshpulatov')
//             : Row(
//                 children: [
//                   const CircleAvatar(
//                     backgroundImage: AssetImage('assets/images/IMG_1256.JPG'),
//                     radius: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     'Samandar Eshpulatov',
//                     style: TextStyle(
//                       color: widget.isDarkMode ? Colors.white : Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//         actions: [
//           if (!isMobile) ...[
//             _buildNavItem('Bosh sahifa', 0, _homeKey),
//             _buildNavItem('Men haqimda', 1, _aboutKey),
//             _buildNavItem('Portfolio', 2, _portfolioKey),
//             _buildNavItem('Xizmatlar', 3, _servicesKey),
//             _buildNavItem('Blog', 4, _blogKey),
//             _buildNavItem('Aloqa', 5, _contactKey),
//           ],
//           IconButton(
//             icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () => widget.toggleTheme(),
//           ),
//           const SizedBox(width: 10),
//         ],
//       ),
//       drawer: isMobile ? _buildDrawer() : null,
//       body: SingleChildScrollView(
//         controller: _scrollController,
//         child: Column(
//           children: [
//             // Bosh sahifa bo'limi
//             Container(
//               key: _homeKey,
//               height: screenSize.height * 0.9,
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
//                   child: isMobile ? _buildMobileHomeContent() : _buildDesktopHomeContent(),
//                 ),
//               ),
//             ),

//             // Men haqimda bo'limi
//             Container(
//               key: _aboutKey,
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               color: widget.isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SectionTitle(title: 'Men Haqimda'),
//                       const SizedBox(height: 30),
//                       isMobile ? _buildMobileAboutContent() : _buildDesktopAboutContent(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Portfolio bo'limi
//             Container(
//               key: _portfolioKey,
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SectionTitle(title: 'Portfolio'),
//                       const SizedBox(height: 30),
//                       _buildPortfolioGrid(isMobile),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Xizmatlar bo'limi
//             Container(
//               key: _servicesKey,
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               color: widget.isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SectionTitle(title: 'Xizmatlar'),
//                       const SizedBox(height: 30),
//                       _buildServicesGrid(isMobile),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Blog bo'limi
//             Container(
//               key: _blogKey,
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SectionTitle(title: 'Blog'),
//                       const SizedBox(height: 30),
//                       _buildBlogGrid(isMobile),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Aloqa bo'limi
//             Container(
//               key: _contactKey,
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               color: widget.isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: screenSize.width > 1200 ? 1200 : double.infinity),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SectionTitle(title: 'Aloqa'),
//                       const SizedBox(height: 30),
//                       isMobile ? _buildMobileContactContent() : _buildDesktopContactContent(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Footer
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               color: widget.isDarkMode ? const Color(0xFF121212) : Colors.white,
//               child: Center(
//                 child: Text(
//                   '© ${DateTime.now().year} Samandar Eshpulatov. Barcha huquqlar himoyalangan.',
//                   style: TextStyle(
//                     color: widget.isDarkMode ? Colors.white70 : Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.arrow_upward),
//         onPressed: () {
//           _scrollController.animateTo(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildNavItem(String title, int index, GlobalKey key) {
//     return TextButton(
//       onPressed: () => _scrollToSection(key),
//       style: TextButton.styleFrom(
//         foregroundColor: _currentIndex == index ? Colors.blue : (widget.isDarkMode ? Colors.white70 : Colors.black54),
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//       ),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const CircleAvatar(
//                   backgroundImage: AssetImage('assets/images/IMG_1256.JPG'),
//                   radius: 40,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Samandar Eshpulatov',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Flutter Developer & Instructor',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Bosh sahifa'),
//             selected: _currentIndex == 0,
//             onTap: () {
//               _scrollToSection(_homeKey);
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Men haqimda'),
//             selected: _currentIndex == 1,
//             onTap: () {
//               _scrollToSection(_aboutKey);
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.work),
//             title: const Text('Portfolio'),
//             selected: _currentIndex == 2,
//             onTap: () {
//               _scrollToSection(_portfolioKey);
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.design_services),
//             title: const Text('Xizmatlar'),
//             selected: _currentIndex == 3,
//             onTap: () {
//               _scrollToSection(_servicesKey);
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.article),
//             title: const Text('Blog'),
//             selected: _currentIndex == 4,
//             onTap: () {
//               _scrollToSection(_blogKey);
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.contact_mail),
//             title: const Text('Aloqa'),
//             selected: _currentIndex == 5,
//             onTap: () {
//               _scrollToSection(_contactKey);
//               Navigator.pop(context);
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             title: Text(widget.isDarkMode ? 'Yorug\' rejim' : 'Qorong\'u rejim'),
//             onTap: () {
//               widget.toggleTheme();
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDesktopHomeContent() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Salom, men',
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: widget.isDarkMode ? Colors.white70 : Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Samandar\nEshpulatov',
//                 style: TextStyle(
//                   fontSize: 60,
//                   fontWeight: FontWeight.bold,
//                   height: 1.1,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 height: 50,
//                 child: AnimatedTextKit(
//                   animatedTexts: [
//                     TypewriterAnimatedText(
//                       'Flutter Dasturchi',
//                       textStyle: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.blue,
//                       ),
//                       speed: const Duration(milliseconds: 100),
//                     ),
//                     TypewriterAnimatedText(
//                       'Instruktor',
//                       textStyle: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.blue,
//                       ),
//                       speed: const Duration(milliseconds: 100),
//                     ),
//                     TypewriterAnimatedText(
//                       'Innovator',
//                       textStyle: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.blue,
//                       ),
//                       speed: const Duration(milliseconds: 100),
//                     ),
//                   ],
//                   repeatForever: true,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _scrollToSection(_contactKey),
//                     icon: const Icon(Icons.work),
//                     label: const Text('Meni Ishlarim'),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                       textStyle: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   OutlinedButton.icon(
//                     onPressed: () => _scrollToSection(_portfolioKey),
//                     icon: const Icon(Icons.visibility),
//                     label: const Text('Mening Ishlarim'),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                       textStyle: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 children: [
//                   _buildSocialButton(FontAwesomeIcons.telegram, 'https://t.me/samandar_eshpulatov'),
//                   _buildSocialButton(FontAwesomeIcons.linkedin, 'https://linkedin.com/in/samandar-eshpulatov'),
//                   _buildSocialButton(FontAwesomeIcons.github, 'https://github.com/Thedarik'),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 40),
//         Container(
//           width: 400,
//           height: 400,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.blue.withOpacity(0.1),
//             border: Border.all(
//               color: Colors.blue.withOpacity(0.3),
//               width: 4,
//             ),
//             image: const DecorationImage(
//               image: AssetImage('assets/images/IMG_1256.JPG'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileHomeContent() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: 200,
//           height: 200,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.blue.withOpacity(0.1),
//             border: Border.all(
//               color: Colors.blue.withOpacity(0.3),
//               width: 4,
//             ),
//             image: const DecorationImage(
//               image: AssetImage('assets/profile.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//         Text(
//           'Salom, men',
//           style: TextStyle(
//             fontSize: 18,
//             color: widget.isDarkMode ? Colors.white70 : Colors.black54,
//           ),
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           'Samandar Eshpulatov',
//           style: TextStyle(
//             fontSize: 36,
//             fontWeight: FontWeight.bold,
//             height: 1.1,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         SizedBox(
//           height: 40,
//           child: AnimatedTextKit(
//             animatedTexts: [
//               TypewriterAnimatedText(
//                 'Flutter Dasturchi',
//                 textStyle: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.blue,
//                 ),
//                 speed: const Duration(milliseconds: 100),
//               ),
//               TypewriterAnimatedText(
//                 'Instruktor',
//                 textStyle: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.blue,
//                 ),
//                 speed: const Duration(milliseconds: 100),
//               ),
//               TypewriterAnimatedText(
//                 'Innovator',
//                 textStyle: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.blue,
//                 ),
//                 speed: const Duration(milliseconds: 100),
//               ),
//             ],
//             repeatForever: true,
//           ),
//         ),
//         const SizedBox(height: 30),
//         Column(
//           children: [
//             ElevatedButton.icon(
//               onPressed: () => _scrollToSection(_contactKey),
//               icon: const Icon(Icons.work),
//               label: const Text('Meni Ishga Oling'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 textStyle: const TextStyle(fontSize: 16),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//             const SizedBox(height: 15),
//             OutlinedButton.icon(
//               onPressed: () => _scrollToSection(_portfolioKey),
//               icon: const Icon(Icons.visibility),
//               label: const Text('Mening Ishlarim'),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 textStyle: const TextStyle(fontSize: 16),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 30),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildSocialButton(FontAwesomeIcons.telegram, 'https://t.me/samandar_eshpulatov'),
//             _buildSocialButton(FontAwesomeIcons.linkedin, 'https://linkedin.com/in/samandar-eshpulatov'),
//             _buildSocialButton(FontAwesomeIcons.github, 'https://github.com/samandar-eshpulatov'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildSocialButton(IconData icon, String url) {
//     return IconButton(
//       icon: FaIcon(icon),
//       onPressed: () => _launchUrl(url),
//       iconSize: 24,
//       color: Colors.blue,
//     );
//   }

//   Widget _buildDesktopAboutContent() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Men Flutter dasturlashda 3,5 yillik tajribaga egaman',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Mobil dasturlash sohasida chuqur bilim va ko\'nikmalarga egaman. Men Flutter va Dart texnologiyalarini maqsadli ravishda o\'zlashtirganman va ulardan foydalanib bir qancha mobil ilovalarni ishlab chiqqanman. Java backend bilan ishlash tajribam ham bor, shuningdek DevOps sohasiga ham qiziqaman.',
//                 style: TextStyle(
//                   fontSize: 16,
//                   height: 1.6,
//                   color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Ko\'rsata oladigan kuchli tomonlarim:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: widget.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               _buildSkillsList(),
//             ],
//           ),
//         ),
//         const SizedBox(width: 40),
//         Expanded(
//           flex: 3,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildExperienceCard(
//                 icon: Icons.work,
//                 title: 'Ish tajriba',
//                 items: ['Flutter Dasturchi - 3.5 yil', 'Flutter Instruktor', 'Java Backend tajriba', 'DevOps qiziqish'],
//               ),
//               const SizedBox(height: 30),
//               _buildExperienceCard(
//                 icon: Icons.lightbulb,
//                 title: 'Kelajak maqsadlarim',
//                 items: ['O\'z IT kompaniyasini yaratish', 'Global innovatsion loyihalar', 'O\'qitish va mentorliq', 'DevOps ko\'nikmalarini rivojlantirish'],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileAboutContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Men Flutter dasturlashda 3,5 yillik tajribaga egaman',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Mobil dasturlash sohasida chuqur bilim va ko\'nikmalarga egaman. Men Flutter va Dart texnologiyalarini maqsadli ravishda o\'zlashtirganman va ulardan foydalanib bir qancha mobil ilovalarni ishlab chiqqanman. Java backend bilan ishlash tajribam ham bor, shuningdek DevOps sohasiga ham qiziqaman.',
//           style: TextStyle(
//             fontSize: 16,
//             height: 1.6,
//             color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Ko\'rsata oladigan kuchli tomonlarim:',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: widget.isDarkMode ? Colors.white : Colors.black,
//           ),
//         ),
//         const SizedBox(height: 15),
//         _buildSkillsList(),
//         const SizedBox(height: 30),
//         _buildExperienceCard(
//           icon: Icons.work,
//           title: 'Ish tajriba',
//           items: ['Flutter Dasturchi - 3.5 yil', 'Flutter Instruktor', 'Java Backend tajriba', 'DevOps qiziqish'],
//         ),
//         const SizedBox(height: 30),
//         _buildExperienceCard(
//           icon: Icons.lightbulb,
//           title: 'Kelajak maqsadlarim',
//           items: ['O\'z IT kompaniyasini yaratish', 'Global innovatsion loyihalar', 'O\'qitish va mentorliq', 'DevOps ko\'nikmalarini rivojlantirish'],
//         ),
//       ],
//     );
//   }

//   Widget _buildSkillsList() {
//     final skills = [
//       {'name': 'Flutter/Dart', 'level': 0.9},
//       {'name': 'UI/UX Design', 'level': 0.7},
//       {'name': 'Java', 'level': 0.8},
//       {'name': 'Backend', 'level': 0.75},
//       {'name': 'DevOps', 'level': 0.6},
//     ];

//     return Column(
//       children: skills.map((skill) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 15), // Ko'nikmalar orasidagi masofa
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     skill['name'] as String,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     '${((skill['level'] as double) * 100).toInt()}%',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: widget.isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               LinearProgressIndicator(
//                 value: skill['level'] as double,
//                 backgroundColor: Colors.blue.withOpacity(0.2),
//                 color: Colors.blue,
//                 minHeight: 6,
//                 borderRadius: BorderRadius.circular(3),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildExperienceCard({
//     required IconData icon,
//     required String title,
//     required List<String> items,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: widget.isDarkMode ? const Color(0xFF252525) : Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 icon,
//                 color: Colors.blue,
//                 size: 24,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: widget.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           ...items.map((item) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(
//                     Icons.circle,
//                     size: 8,
//                     color: Colors.blue,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       item,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildServicesGrid(bool isMobile) {
//     final services = [
//       {
//         'icon': Icons.mobile_friendly,
//         'title': 'Mobil Ilovalar',
//         'description': 'Flutter yordamida yuqori sifatli mobil ilovalar yaratish.',
//       },
//       {
//         'icon': Icons.design_services,
//         'title': 'UI/UX Dizayn',
//         'description': 'Zamonaviy va foydalanuvchi uchun qulay interfeyslar yaratish.',
//       },
//       {
//         'icon': Icons.code,
//         'title': 'Backend Rivojlantirish',
//         'description': 'Java va boshqa texnologiyalar yordamida backend yechimlari.',
//       },
//     ];

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isMobile ? 1 : 3,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         childAspectRatio: 1.2,
//       ),
//       itemCount: services.length,
//       itemBuilder: (context, index) {
//         final service = services[index];
//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: widget.isDarkMode ? const Color(0xFF252525) : Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(
//                 service['icon'] as IconData,
//                 size: 40,
//                 color: Colors.blue,
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 service['title'] as String, // Tuzatilgan
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: widget.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 service['description'] as String, // Tuzatilgan
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPortfolioGrid(bool isMobile) {
//     final projects = [
//       {
//         'title': 'E-commerce App',
//         'description': 'Flutter bilan yaratilgan to\'liq funksionallikdagi e-commerce ilovasi.',
//         'image': 'assets/project1.jpg',
//         'link': 'https://example.com/ecommerce',
//       },
//       {
//         'title': 'Social Media App',
//         'description': 'Foydalanuvchilar uchun interfeysi sodda ijtimoiy tarmoq ilovasi.',
//         'image': 'assets/project2.jpg',
//         'link': 'https://example.com/socialmedia',
//       },
//       {
//         'title': 'Task Manager',
//         'description': 'Vazifalarni boshqarish uchun qulay ilova.',
//         'image': 'assets/project3.jpg',
//         'link': 'https://example.com/taskmanager',
//       },
//     ];

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isMobile ? 1 : 3,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         childAspectRatio: 1.2,
//       ),
//       itemCount: projects.length,
//       itemBuilder: (context, index) {
//         final project = projects[index];
//         return GestureDetector(
//           onTap: () => _launchUrl(project['link'] as String),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: widget.isDarkMode ? const Color(0xFF252525) : Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//                     child: Image.asset(
//                       project['image'] as String,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         project['title'] as String,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: widget.isDarkMode ? Colors.white : Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         project['description'] as String,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBlogGrid(bool isMobile) {
//     final blogs = [
//       {
//         'title': 'Flutterda State Management',
//         'description': 'Flutterda state managementni tushunish va qo\'llash.',
//         'link': 'https://example.com/flutter-state-management',
//       },
//       {
//         'title': 'UI/UX Dizayn Prinsiplari',
//         'description': 'Zamonaviy UI/UX dizayn prinsiplari va ularni qo\'llash.',
//         'link': 'https://example.com/ui-ux-principles',
//       },
//       {
//         'title': 'DevOps Asoslari',
//         'description': 'DevOps asoslari va ularni loyihalarga qo\'llash.',
//         'link': 'https://example.com/devops-basics',
//       },
//     ];

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isMobile ? 1 : 3,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         childAspectRatio: 1.5,
//       ),
//       itemCount: blogs.length,
//       itemBuilder: (context, index) {
//         final blog = blogs[index];
//         return GestureDetector(
//           onTap: () => _launchUrl(blog['link'] as String),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: widget.isDarkMode ? const Color(0xFF252525) : Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   blog['title'] as String,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: widget.isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   blog['description'] as String,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDesktopContactContent() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Aloqa uchun ma\'lumotlar',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Agar sizda savollar yoki takliflar bo\'lsa, menga quyidagi ma\'lumotlar orqali murojaat qilishingiz mumkin:',
//                 style: TextStyle(
//                   fontSize: 16,
//                   height: 1.6,
//                   color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               _buildContactInfo(),
//             ],
//           ),
//         ),
//         const SizedBox(width: 40),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Xabar yuborish',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildContactForm(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileContactContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Aloqa uchun ma\'lumotlar',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Agar sizda savollar yoki takliflar bo\'lsa, menga quyidagi ma\'lumotlar orqali murojaat qilishingiz mumkin:',
//           style: TextStyle(
//             fontSize: 16,
//             height: 1.6,
//             color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 30),
//         _buildContactInfo(),
//         const SizedBox(height: 30),
//         const Text(
//           'Xabar yuborish',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 20),
//         _buildContactForm(),
//       ],
//     );
//   }

//   Widget _buildContactInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildContactItem(
//           icon: Icons.email,
//           title: 'Email',
//           value: 'samandar.eshpulatov@gmail.com',
//           onTap: () => _launchUrl('mailto:samandar.eshpulatov@gmail.com'),
//         ),
//         const SizedBox(height: 20),
//         _buildContactItem(
//           icon: Icons.phone,
//           title: 'Telefon',
//           value: '+998 99 999 99 99',
//           onTap: () => _launchUrl('tel:+998999999999'),
//         ),
//         const SizedBox(height: 20),
//         _buildContactItem(
//           icon: Icons.location_on,
//           title: 'Manzil',
//           value: 'Toshkent, O\'zbekiston',
//           onTap: () => _launchUrl('https://maps.google.com/?q=Tashkent,Uzbekistan'),
//         ),
//       ],
//     );
//   }

//   Widget _buildContactItem({
//     required IconData icon,
//     required String title,
//     required String value,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             icon,
//             size: 24,
//             color: Colors.blue,
//           ),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: widget.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContactForm() {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(
//             labelText: 'Ismingiz',
//             labelStyle: TextStyle(
//               color: widget.isDarkMode ? Colors.white70 : Colors.black54,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         TextField(
//           decoration: InputDecoration(
//             labelText: 'Email',
//             labelStyle: TextStyle(
//               color: widget.isDarkMode ? Colors.white70 : Colors.black54,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         TextField(
//           decoration: InputDecoration(
//             labelText: 'Xabar',
//             labelStyle: TextStyle(
//               color: widget.isDarkMode ? Colors.white70 : Colors.black54,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           maxLines: 5,
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             // Xabar yuborish logikasi keyinchalik qo'shilishi mumkin
//           },
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//             textStyle: const TextStyle(fontSize: 16),
//           ),
//           child: const Text('Xabarni Yuborish'),
//         ),
//       ],
//     );
//   }

//   // URL ni ochish uchun yangilangan funksiya
//   Future<void> _launchUrl(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }

// // Bo'lim sarlavhalari uchun widget
// class SectionTitle extends StatelessWidget {
//   final String title;

//   const SectionTitle({
//     super.key,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 32,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }
