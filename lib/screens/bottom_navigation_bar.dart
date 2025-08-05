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
  const BottomNavigationBarScreen({super.key, this.pageIndex, this.selectCat});
  final int? pageIndex;
  final String? selectCat;

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

  List<Widget> get pages => [
    HomeScreen(selectCat: widget.selectCat),
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
          floatingActionButton: Transform.translate(
            offset: const Offset(0, 20),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
              backgroundColor: Palette.facebookColor,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 32, color: Colors.white),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 0,
            elevation: 10,
            color: Colors.transparent,
            child: Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Palette.basicDark,
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
