import 'package:flutter/material.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/widgets/custom_button.dart';

class StartedScreen extends StatelessWidget {
  const StartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/start.png'),
              const SizedBox(height: 20),

              const Text(
                'Best Social App to Make\nNew Friends',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'With pipel you will find new friends from various\ncountries and regions of the world',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // Get Started Button
              CustomButton(
                onPressed: () {
                  // Navigate to SignUp screen
                  pushNamedNavigate(
                    context: context,
                    pageName: signupScreenRoute,
                  );
                },
              ),

              const SizedBox(height: 20),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to Login screen
                    pushNamedNavigate(
                      context: context,
                      pageName: loginScreenRoute,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
