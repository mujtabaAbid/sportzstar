import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/widgets/custom_button.dart';

import 'package:flutter/material.dart';

class StartedScreen extends StatefulWidget {
  const StartedScreen({super.key});

  @override
  State<StartedScreen> createState() => _StartedScreenState();
}

class _StartedScreenState extends State<StartedScreen>
    with SingleTickerProviderStateMixin {
  bool _moveUp = false;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _whereToGo();
  }

  Future<void> _whereToGo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final aaa = prefs.getString('access');
    print('shared preferences==access token==>>>>$aaa');

    if (aaa != null) {
      pushNamedAndRemoveUntilNavigate(
        pageName: homeScreenRoute,
        context: context,
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _moveUp = true);

      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => _showContent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Animated Image
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              top:
                  _moveUp
                      ? MediaQuery.of(context).size.height * 0.1
                      : MediaQuery.of(context).size.height * 0.38,
              left: (MediaQuery.of(context).size.width / 2) / 8,
              child: Image.asset(
                'assets/images/start.png',
                height: MediaQuery.of(context).size.height * 0.36,
                // width: 260,
              ),
            ),

            // Animated Content
            AnimatedOpacity(
              opacity: _showContent ? 1 : 0,
              duration: const Duration(milliseconds: 810),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const SizedBox(height: 300),
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
                      text: 'Get Started',
                      onPressed: () async {
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
