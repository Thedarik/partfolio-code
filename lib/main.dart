// import 'package:flutter/material.dart';
// import 'package:me_partfolio/test.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const PortfolioApp(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/about_viewmodel.dart';
import 'viewmodels/portfolio_viewmodel.dart';
import 'viewmodels/services_viewmodel.dart';
import 'viewmodels/blog_viewmodel.dart';
import 'viewmodels/contact_viewmodel.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => AboutViewModel()),
        ChangeNotifierProvider(create: (_) => PortfolioViewModel()),
        ChangeNotifierProvider(create: (_) => ServicesViewModel()),
        ChangeNotifierProvider(create: (_) => BlogViewModel()),
        ChangeNotifierProvider(create: (_) => ContactViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Samandar Eshpulatov | Portfolio',
        theme: ThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.poppins().fontFamily,
          scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
        ),
        home: HomePage(
          toggleTheme: () {
            setState(() {
              isDarkMode = !isDarkMode;
            });
          },
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}
