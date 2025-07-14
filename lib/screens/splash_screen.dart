import 'package:flutter/material.dart';
import 'package:sportzstar/screens/authScreens/login_screen.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/started_screen.dart';

import 'home_screen.dart';

// SplashScreen with 3-second delayimport 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _moveUp = false;

  @override
  void initState() {
    super.initState();

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _moveUp = true;
      });
    });

    // Navigate to next screen after animation
    Future.delayed(const Duration(seconds: 3), () {
      print('first 00000000000');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            alignment: _moveUp ? Alignment.topCenter : Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Image.asset(
                'assets/images/start.png',
                height: 200,
                width: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
