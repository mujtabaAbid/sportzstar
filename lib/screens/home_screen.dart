import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';

import '../widgets/Layout/main_layout_widget.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
=======
import 'package:sportzstar/config/palette.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
>>>>>>> 00a8c8e7d205e0c005569570f0147ebfce6aa7be
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Widget> pages = const [
    Center(child: Column(children: [Text('Home')])),
    Center(child: Text('Star')),
    Center(child: Text('wow')),
    Center(child: Text('Style')),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    pushNamedNavigate(context: context, pageName: signupScreenRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: const EdgeInsets.all(0),
                    backgroundColor: const Color.fromARGB(255, 223, 255, 43), // Start of gradient
                  ).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        return null; // Use decoration instead
                      },
                    ),
                    elevation: WidgetStateProperty.all(0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(255, 223, 255, 43), Color.fromARGB(255, 223, 255, 43)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    pushNamedNavigate(context: context, pageName: loginScreenRoute);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
=======
      body: pages[selectedIndex],
      floatingActionButton: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              selectedIndex != 2
                  ? Palette.primaryGradient
                  : Palette.secondaryGradient,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
>>>>>>> 00a8c8e7d205e0c005569570f0147ebfce6aa7be
        ),
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            setState(() {
              selectedIndex = 2;
            });
          },
          backgroundColor: const Color.fromARGB(52, 255, 255, 255),
          elevation: 0,
          child: const Icon(Icons.emoji_events_outlined, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 28,
          barAnimation: BarAnimation.transform3D,
          iconStyle: IconStyle.Default,
        ),
        fabLocation: StylishBarFabLocation.center,
        hasNotch: false,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selectedColor: Colors.pink,
          ),
          BottomBarItem(
            icon: const Icon(Icons.star_border),
            title: const Text('Star'),
            selectedColor: Colors.pink,
          ),
          BottomBarItem(
            icon: const Icon(Icons.add),
            title: const Text('heart'),
            unSelectedColor: Colors.transparent,
            selectedColor: Colors.transparent,
          ),
          BottomBarItem(
            icon: const Icon(Icons.style_outlined),
            title: const Text('Style'),
            selectedColor: Colors.pink,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            selectedColor: Colors.pink,
          ),
        ],
      ),
    );
  }
}

