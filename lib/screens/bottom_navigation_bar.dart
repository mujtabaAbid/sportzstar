import 'package:flutter/material.dart';
import 'package:sportzstar/screens/chats/chat_list_screen.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/screens/eventScreens/tabbar_screen.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/home_screen.dart';
import 'package:sportzstar/screens/testing.dart';
import 'sportsReports/sports_list.dart';
import 'storyScreens/story_screen.dart';
import 'userScreens/user_profile_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({
    super.key,
    this.pageIndex,
    this.selectCat,
    this.eventIndex,
  });
  final int? pageIndex;
  final String? selectCat;
  final int? eventIndex;

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
    EventScreen(eventIndex: widget.eventIndex),
    ChatListScreen(),
    UserProfileScreen(),
    SportsList(),

    // Center(child: Text('jhyfgudsyfgk')),
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
            offset: const Offset(-30, 20), // thoda left aur neeche shift
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
              backgroundColor: Palette.facebookColor,
              elevation: 4,
              shape: const CircleBorder(),
              child: Icon(
                Icons.emoji_events_outlined,
                size: 28,
                color: selectedIndex == 2 ? Colors.white : Colors.grey,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          // floatingActionButton: Transform.translate(
          //   offset: const Offset(0, 20),
          //   child:
          //   FloatingActionButton(
          //     onPressed: () {
          //       setState(() {
          //         selectedIndex = 2;
          //       });
          //     },
          //     backgroundColor: Palette.facebookColor,
          //     elevation: 4,
          //     shape: const CircleBorder(),
          //     child: Icon(
          //       Icons.emoji_events_outlined,
          //       size: 28,
          //       color: selectedIndex == 2 ? Colors.white : Colors.grey,
          //     ),
          //   ),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 0,
            elevation: 10,
            color: Colors.transparent,
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Palette.basicDark,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Left icons
                  _buildNavIcon(Icons.home_outlined, 0),
                  _buildNavIcon(Icons.star_border, 1),

                  // Spacer for FAB (center wali jagah)
                  const SizedBox(
                    width: 40,
                  ), // yeh FAB ka notch ke liye empty jagah banayega
                  // Right icons
                  _buildNavIcon(Icons.chat_bubble_outline, 3),
                  _buildNavIcon(Icons.gamepad_outlined, 3),
                  _buildNavIcon(Icons.person_outline, 4),
                ],
              ),
            ),
          ),

          // bottomNavigationBar: BottomAppBar(
          //   shape: const CircularNotchedRectangle(),
          //   notchMargin: 0,
          //   elevation: 10,
          //   color: Colors.transparent,
          //   child: Container(
          //     height: 150,
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     decoration: BoxDecoration(
          //       color: Palette.basicDark,
          //       borderRadius: BorderRadius.circular(30),
          //       // borderRadius: const BorderRadius.only(
          //       //   topLeft: Radius.circular(35),
          //       //   topRight: Radius.circular(35),
          //       // ),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         // Left side icons
          //         Row(
          //           children: [
          //             _buildNavIcon(Icons.home_outlined, 0),
          //             const SizedBox(width: 30),
          //             _buildNavIcon(Icons.star_border, 1),
          //           ],
          //         ),
          //         // Right side icons
          //         Row(
          //           children: [
          //             _buildNavIcon(Icons.chat_bubble_outline, 3),
          //             const SizedBox(width: 30),
          //             _buildNavIcon(Icons.gamepad_outlined, 3),
          //             const SizedBox(width: 30),
          //             _buildNavIcon(Icons.person_outline, 4),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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
