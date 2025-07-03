import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
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
