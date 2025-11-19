import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/home_provider.dart';
import 'package:sportzstar/provider/stories_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/screens/sportsReports/sports_list.dart';
import 'package:sportzstar/screens/storyScreens/other_user_stories.dart';
import 'package:sportzstar/screens/testing.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/post_card_widget.dart';

import '../helper/local_storage.dart';
import 'sportsReports/baseball_report.dart';
import 'sportsReports/reports_html.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.selectCat});
  final String? selectCat;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getNotifications();
    getSports();
    getStoryUsers();
    getPosts();
    selectedCategory = widget.selectCat ?? '';
  }

  // String selectedCategory = '';
  String selectedCategory = '';
  List<Map<String, dynamic>> allUsersList = [];
  List<Map<String, dynamic>> posts = [];
  List<String> sportsCategories = [];
  int notificationCount = 0;
  // int storyCount = 0;
  bool _isLoading = false;

  Future<void> getNotifications() async {
    try {
      final response =
          await Provider.of<HomeProvider>(
            context,
            listen: false,
          ).getAllNotifications();

      notificationCount = response['unread'];

      print(
        '✅ All getNotifications count:-------------------> $notificationCount',
      );
    } catch (e) {
      print('❌ Error getNotifications:--------e---------> $e');
    }
  }

  Future<void> getSports() async {
    try {
      final response =
          await Provider.of<HomeProvider>(
            context,
            listen: false,
          ).getAllSports();
      sportsCategories.clear();
      for (var item in response) {
        sportsCategories.add(item['game_name']);
      }
      print('✅ All getSports:-------------------> $sportsCategories');
    } catch (e) {
      print('❌ Error getSports:--------e---------> $e');
    }
  }

  Future<void> getStoryUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await getDataFromLocalStorage(name: 'userData');
      final logedInUser = json.decode(data);
      final loggedInUserId = logedInUser['id'];

      final usersData =
          await Provider.of<StoriesProvider>(
            context,
            listen: false,
          ).getAllStories();

      print('API Response:---- $usersData');

      allUsersList.clear();
      int totalStories = 0;

      Map<String, dynamic>? loggedInUserMapFromResponse;

      for (var user in usersData) {
        final userId = user['user_id'];

        // Count stories
        int storyCount = 0;
        if (user['stories'] != null && user['stories'] is List) {
          storyCount = user['stories'].length;
          totalStories += storyCount;
        }

        // Add story_count to user object
        user['story_count'] = storyCount;

        // If it's the logged-in user, store it separately
        if (userId == loggedInUserId) {
          loggedInUserMapFromResponse = user;
          continue; // skip adding now
        }

        allUsersList.add(user); // Add others
      }

      // Add logged-in user at index 0
      if (loggedInUserMapFromResponse != null) {
        allUsersList.insert(0, loggedInUserMapFromResponse);
      } else {
        final loggedInUserMap = Map<String, dynamic>.from(logedInUser);
        loggedInUserMap['stories'] = [];
        loggedInUserMap['story_count'] = 0;
        allUsersList.insert(0, loggedInUserMap);
      }

      print('Total stories count: $totalStories');
      print('Total users with stories: ${allUsersList.length}');
    } catch (e) {
      print('story users list------->>>>>> Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> getPosts() async {
  //   try {
  //     final response =
  //         await Provider.of<HomeProvider>(context, listen: false).getAllPosts();

  //     print('type=====>>> ${response.runtimeType}');

  //     if (response is Map<String, dynamic>) {
  //       if (response['detail'] ==
  //           'Authentication credentials were not provided or are invalid.') {
  //         logoutFunction();
  //       }
  //       alertNotification(
  //         context: context,
  //         message: response['detail'],
  //         messageType: AlertMessageType.error,
  //       );
  //     }

  //     final postsList = List<Map<String, dynamic>>.from(response);

  //     setState(() {
  //       posts.clear(); // clear previous data if any
  //       posts.addAll(postsList);
  //     });
  //     print('✅ All posts:-------------------> $posts');
  //   } catch (e) {
  //     print('❌ Error parsing posts:-----------------> $e');
  //   }
  // }
  Future<void> getPosts() async {
    try {
      final response =
          await Provider.of<HomeProvider>(context, listen: false).getAllPosts();

      print('type=====>>> ${response.runtimeType}');

      if (response is Map<String, dynamic>) {
        if (response['detail'] ==
            'Authentication credentials were not provided or are invalid.') {
          logoutFunction();
        }
        alertNotification(
          context: context,
          message: response['detail'],
          messageType: AlertMessageType.error,
        );
      }

      final postsList = List<Map<String, dynamic>>.from(response);
      // ✅ Filter only if a category is selected
      List<Map<String, dynamic>> filteredPosts =
          selectedCategory.isEmpty
              ? postsList
              : postsList
                  .where(
                    (post) => post['category']?.toString() == selectedCategory,
                  )
                  .toList();

      setState(() {
        posts
          ..clear()
          ..addAll(filteredPosts);
      });

      print('✅ Filtered posts:-------------------> $posts');
    } catch (e) {
      print('❌ Error parsing posts:-----------------> $e');
    }
  }

  void logoutFunction() async {
    try {
      final preference = await SharedPreferences.getInstance();
      await preference.clear();
      pushNamedAndRemoveUntilNavigate(
        pageName: loginScreenRoute,
        context: context,
      );
      // alertNotification(
      //   context: context,
      //   message: 'User Logout, Please login Again.',
      //   messageType: AlertMessageType.success,
      // );
    } catch (e) {
      print('error in logut function ---->>>$e');
      alertNotification(
        context: context,
        message: 'User Not logout, Try again Later',
        messageType: AlertMessageType.error,
      );
    }
  }

  Future<void> getUserStories(int userId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Provider.of<StoriesProvider>(
        context,
        listen: false,
      ).getStories(userId);

      print(
        'allll sstroies from hokme==========>>>> ${response['total_stories']}',
      );

      if (response['total_stories'] == 0) {
        // alertNotification(
        //   context: context,
        //   message: 'No stories Posted',
        //   messageType: AlertMessageType.warning,
        // );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarScreen(pageIndex: 1),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => OtherUserStoryDetailScreen(
                  story:
                      (response['stories'] as List)
                          .cast<Map<String, dynamic>>(),
                ),
          ),
        );
      }
      print(
        'allll sstroies from hokme==========>>>> ${response['total_stories']}',
      );
    } catch (e) {
      print('allll sstroies from hokme====e======>>>> $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  final List<dynamic> postsss = [
    {
      "post_id": 2,
      "user_id": 2,
      'user_name': 'zaheer',
      'player_category': 'Badminton',
      'user_profile':
          'https://plus.unsplash.com/premium_photo-1664203067979-47448934fd97?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHx8fDA%3D', // optional
      'image_url':
          'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGh1bWFufGVufDB8fDB8fHww', // Replace with real URL or Asset
      'post_description':
          'When life gives you limes, arrange them in a zesty flatlay and create a \'lime-light\' masterpiece!,When life gives you limes, arrange them in a zesty flatlay and create a \'lime-light\' masterpiece!, When life gives you limes, arrange them in a zesty flatlay and create, When life gives you limes, arrange them in a zesty flatlay and create',
      'total_likes': 2,
      'total_comments': 2,
      'created_at': '16 Apr 2025, 06:25 am',
    },
    {
      'player_category': 'Badminton',
      'user_name': 'deemi testing',
      'created_at': '07 Apr 2025, 05:21 pm',
      'post_description': '',
      'image_url':
          'https://images.unsplash.com/photo-1520694478166-daaaaec95b69?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8aHVtYW58ZW58MHx8MHx8fDA%3D', // Replace with real URL or Asset
      'total_likes': 0,
      'total_comments': 0,
      'user_profile':
          'https://plus.unsplash.com/premium_photo-1671656349218-5218444643d8?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // optional
    },
    {
      'player_category': 'Baseball',
      'user_name': 'deemi testing',
      'created_at': '07 Apr 2025, 05:21 pm',
      'post_description':
          'When life gives you limes, arrange them in a zesty flatlay and create a \'lime-light\' masterpiece!, wow',
      'image_url':
          'https://images.unsplash.com/photo-1505243542579-da5adfe8338f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGh1bWFufGVufDB8fDB8fHww', // Replace with real URL or Asset
      'total_likes': 0,
      'total_comments': 0,
      'user_profile':
          'https://plus.unsplash.com/premium_photo-1671656349218-5218444643d8?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // optional
    },
  ];

  final List<Map<String, dynamic>> stories = [
    {
      'name': 'Your story',
      'image': 'assets/profile/img1.jpg',
      'isLive': false,
      'isOwn': true,
    },
    {
      'name': 'calire.gd',
      'image': 'assets/profile/img2.jpeg',
      'isLive': true,
      'isOwn': false,
    },
    {
      'name': 'calista33',
      'image': 'assets/profile/img3.jpeg',
      'isLive': false,
      'isOwn': false,
    },
    {
      'name': 'azizahrn',
      'image': 'assets/profile/img4.jpg',
      'isLive': false,
      'isOwn': false,
    },
    {
      'name': 'adamsuseno',
      'image': 'assets/profile/img5.jpg',
      'isLive': false,
      'isOwn': false,
    },
    {
      'name': 'adelina',
      'image': 'assets/profile/img6.jpg',
      'isLive': false,
      'isOwn': false,
    },
  ];
  // Set default selected category to "Badminton"

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: const Color.fromARGB(255, 28, 26, 49),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MainLayoutWidget(
      isLoading: _isLoading,
      noDefaultBackground: true,

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 4, top: 60),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(width: 20),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    '',
                    // 'SportzStar',
                    style: TextStyle(color: Colors.white, fontSize: 36),
                  ),
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(115, 53, 53, 53),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              pushNamedNavigate(
                                context: context,
                                pageName: notificationScreenRoute,
                              );
                            },
                            icon: Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              notificationCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Stack(
                    SizedBox(width: 8),
                    //   children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: const Color.fromARGB(115, 53, 53, 53),
                    //     borderRadius: BorderRadius.all(Radius.circular(30)),
                    //   ),
                    //   child: IconButton(
                    //     onPressed: () {
                    //       // pushNamedNavigate(
                    //       //   context: context,
                    //       //   pageName: addFriendListScreenRoute,
                    //       // );
                    //       Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //           builder: (context) => SportsList(),
                    //           //  BaseballGamesScreen(),
                    //         ),
                    //       );
                    //     },
                    //     icon: Icon(
                    //       Icons.games_outlined,
                    //       color: Colors.white,
                    //       size: 28,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(115, 53, 53, 53),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          pushNamedNavigate(
                            context: context,
                            pageName: addFriendListScreenRoute,
                          );
                        },
                        icon: Icon(
                          Icons.person_add_alt_1_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    //   children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(115, 53, 53, 53),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          pushNamedNavigate(
                            context: context,
                            pageName: chatListScreenRoute,
                            // pageName: createPostScreenRoute,
                          );
                        },
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          // Icons.add_a_photo_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),

                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
          // SizedBox(height: 10),
          // all users list
          Container(
            color: Colors.transparent,
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allUsersList.length,
              itemBuilder: (context, index) {
                final story = allUsersList[index];
                return GestureDetector(
                  onTap: () {
                    getUserStories(story['user_id'] ?? story['id']);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: index == 0 ? 10 : 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CustomPaint(
                                painter: StoryBorderPainter(
                                  storyCount: story['story_count'],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    2,
                                  ), // space between border and image
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundImage:
                                        story['user_profile'] != null &&
                                                story['user_profile']
                                                    .toString()
                                                    .isNotEmpty
                                            ? NetworkImage(
                                              story['user_profile'] ??
                                                  story['profile_picture'] ??
                                                  'https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png',
                                            )
                                            : const AssetImage(
                                                  'assets/profile/user.png',
                                                )
                                                as ImageProvider,
                                  ),
                                ),
                              ),
                              if (story['story_count'] == 0)
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Color.fromARGB(
                                      221,
                                      32,
                                      32,
                                      31,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            story['full_name'] ?? story['user_name'],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // category selection
          Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sportsCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  String category = sportsCategories[index];
                  // bool isSelected = selectedCategory == category;

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      // vertical: 8,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = category;
                          print('selectedCategory ------>>>>$selectedCategory');
                        });
                        // getPosts();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            category == selectedCategory
                                ? Color.fromARGB(255, 13, 32, 70)
                                : Palette.facebookColor,
                      ),
                      child: Text(
                        category,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       selectedCategory = category;
                  //       print('kjfskdjfhsdjf---->>>>$selectedCategory');
                  //     });
                  //   },
                  //   child:

                  //    Container(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       // vertical: 8,
                  //     ),
                  //     // margin: EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //       border: Border(
                  //         bottom: BorderSide(
                  //           color:
                  //               isSelected
                  //                   ? Colors.black
                  //                   : const Color.fromARGB(192, 213, 213, 213),
                  //           width: 2,
                  //         ),
                  //       ),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         category,
                  //         style: TextStyle(
                  //           color: isSelected ? Colors.black : Palette.darkgray,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
              ),
            ),
          ),
          //post card widget call
          // Expanded(
          //   child: ListView.builder(
          //     padding: EdgeInsets.only(top: 10, bottom: 80),
          //     itemCount:
          //         posts
          //             .where(
          //               (post) => post['player_category'] == selectedCategory,
          //             )
          //             .length,
          //     itemBuilder: (context, index) {
          //       final filteredPosts =
          //           posts
          //               .where(
          //                 (post) => post['player_category'] == selectedCategory,
          //               )
          //               .toList();
          //       final post = filteredPosts[index];
          //       return PostCard(
          //         post: post,
          //         selectedCategory: selectedCategory,
          //         displayType: PostDisplayType.text,
          //       );

          //     },
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 80),
              itemCount:
                  posts
                      .where(
                        (post) =>
                            selectedCategory.isEmpty ||
                            post['player_category'] == selectedCategory,
                      )
                      .length,
              itemBuilder: (context, index) {
                final filteredPosts =
                    posts
                        .where(
                          (post) =>
                              selectedCategory.isEmpty ||
                              post['player_category'] == selectedCategory,
                        )
                        .toList();

                final post = filteredPosts[index];

                return PostCard(
                  post: post,
                  selectedCategory: selectedCategory,
                  displayType: PostDisplayType.text,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoryBorderPainter extends CustomPainter {
  final int storyCount;
  final double strokeWidth;
  final Color color;

  StoryBorderPainter({
    required this.storyCount,
    this.strokeWidth = 2,
    this.color = Colors.blueAccent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (storyCount <= 0) return;

    final radius = (size.width / 2);
    final center = Offset(size.width / 2, size.height / 2);
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    if (storyCount == 1) {
      // Full circle
      canvas.drawCircle(center, radius, paint);
    } else {
      final gapSize = 9; // degrees of gap between segments
      final sweepAngle = (360 - (storyCount * gapSize)) / storyCount;

      double startAngle = -90; // starting from top

      for (int i = 0; i < storyCount; i++) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          radians(startAngle),
          radians(sweepAngle),
          false,
          paint,
        );
        startAngle += sweepAngle + gapSize;
      }
    }
  }

  double radians(double degrees) => degrees * 3.1415926535 / 180;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
