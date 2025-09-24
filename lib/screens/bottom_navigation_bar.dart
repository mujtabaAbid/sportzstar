import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sportzstar/helper/local_storage.dart';
import 'package:sportzstar/screens/chats/chat_list_screen.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/screens/eventScreens/tabbar_screen.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/home_screen.dart';
import 'package:sportzstar/screens/postScreens/create_post.dart';
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
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Call async method separately
  }

  Future<void> _loadUserData() async {
    final data = await getDataFromLocalStorage(name: 'userData');
    if (data != null) {
      setState(() {
        userData = jsonDecode(data);
        print('iwehdfjoejoejakhd=====>>>$userData');
        selectedIndex = widget.pageIndex ?? 0;
      });
    }
  }

  List<Widget> get pages => [
    HomeScreen(selectCat: widget.selectCat),
    StoryScreen(),
    CreatePostScreen(),
    EventScreen(eventIndex: widget.eventIndex),
    // ChatListScreen(),
    // SportsList(),
    UserProfileScreen(),

    // Center(child: Text('jhyfgudsyfgk')),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Testing(),
        Scaffold(
          extendBody: true,
          body: pages[selectedIndex],

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
                  _buildNavIcon(Icons.home_outlined, 0, 'Home'),
                  _buildNavIcon(Icons.star_border, 1, 'Stories'),
                  _buildNavIcon(Icons.add_a_photo_outlined, 2, 'Posts'),
                  _buildNavIcon(Icons.emoji_events_outlined, 3, 'Events'),
                  // _buildNavIcon(Icons.gamepad_outlined, 4, ''),
                  _buildNavIcon(
                    Icons.person_outline,
                    4,
                    userData['full_name'],
                    profilePicture: userData['profile_picture'] as String?,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavIcon(
    IconData icon,
    int index,
    String label, {
    String? profilePicture,
  }) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          profilePicture != null && profilePicture.isNotEmpty
              ? CircleAvatar(
                radius: 14, // same as Icon size (28 / 2)
                backgroundImage: NetworkImage(profilePicture),
                backgroundColor: Colors.grey.shade300,
              )
              : Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white54,
                size: 28,
              ),
          // Icon(
          //   icon,
          //   color: isSelected ? Colors.white : Colors.white54,
          //   size: 28,
          // ),
          const SizedBox(height: 4), // spacing between icon and label
          if (isSelected) // show label only when selected
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
