import 'package:flutter/material.dart';
import 'package:estor_alihab/screens/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' الإيهاب لخدمات الاتصال',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: const Color(0xFF0052B4),
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),

        fontFamily: 'Cairo',

        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0052B4)),
          titleTextStyle: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xFF0052B4),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}