import 'package:flutter/material.dart';
import 'package:sportzstar/chats/chat_list_screen.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/explore/tabbar_screen.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/home_screen.dart';
import 'package:sportzstar/screens/testing.dart';
import 'storyScreens/story_screen.dart';
import 'userScreens/user_profile_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key, this.pageIndex});
  final int? pageIndex;

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.pageIndex ?? 0;
  }

  final List<Widget> pages = const [
    HomeScreen(),
    StoryScreen(),
    EventScreen(),
    ChatListScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Testing(),
        Scaffold(
          extendBody: true, // So the nav bar floats above the body
          body: pages[selectedIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                selectedIndex = 2;
              });
            },
            backgroundColor: Colors.blueAccent,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 32),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 6,
            elevation: 10,
            color: Colors.white,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(35),
                //   topRight: Radius.circular(35),
                // ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side icons
                  Row(
                    children: [
                      _buildNavIcon(Icons.home_outlined, 0),
                      const SizedBox(width: 30),
                      _buildNavIcon(Icons.star_border, 1),
                    ],
                  ),
                  // Right side icons
                  Row(
                    children: [
                      _buildNavIcon(Icons.chat_bubble_outline, 3),
                      const SizedBox(width: 30),
                      _buildNavIcon(Icons.person_outline, 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Icon(
        icon,
        color: selectedIndex == index ? Colors.white : Colors.white54,
        size: 28,
      ),
    );
  }
}
