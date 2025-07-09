import 'package:flutter/material.dart';
import 'package:sportzstar/chats/chat_list_screen.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/screens/home_screen.dart';
import 'userScreens/user_profile_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int selectedIndex = 0;

  List<Widget> pages = const [
    HomeScreen(),
    // Center(child: Text('Home')),
    Center(child: Text('Star')),
    Center(child: Text('wow')),
    ChatListScreen(),
    UserProfileScreen()
    // Center(child: Text('Profile')),
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
            selectedColor: Palette.basicgreen,
          ),
          BottomBarItem(
            icon: const Icon(Icons.star_border),
            title: const Text('Star'),
            selectedColor: Palette.darkgreen,
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
            selectedColor: Palette.basicgray,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            selectedColor: Palette.darkgray,
          ),
        ],
      ),
    );
  }
}
