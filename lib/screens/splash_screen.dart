import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    /*
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/EAlogo.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Text(
              "الإيهاب",
              style: TextStyle(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const Text(
              "لخدمات الاتصال",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 30,
                letterSpacing: 1.2,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: Color(0xFF5EC401),
            ),
          ],
        ),
      ),
    );
  }
}