import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/home_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/testing.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/post_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getNotifications();
    getSports();
    allUsers();
    getPosts();
  }

  List<Map<String, dynamic>> allUsersList = [];
  List<Map<String, dynamic>> posts = [];
  List<String> sportsCategories = [];
  int notificationCount = 0;
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

  Future<void> allUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final usersData =
          await Provider.of<HomeProvider>(context, listen: false).usersList();

      print('API Response: $usersData');

      // Clear previous data
      allUsersList.clear();

      // Merge all categories in order
      for (String key in [
        'friends',
        'send_requests_users',
        'recieved_request_users',
        'other_users',
      ]) {
        if (usersData[key] != null && usersData[key] is List) {
          allUsersList.addAll(List<Map<String, dynamic>>.from(usersData[key]));
        }
      }

      print('Final flattened list: ${allUsersList.length} users');
    } catch (e) {
      print('from screen use list------->>>>>> Error: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getPosts() async {
    try {
      final response =
          await Provider.of<HomeProvider>(context, listen: false).getAllPosts();

      final postsList = List<Map<String, dynamic>>.from(response);

      setState(() {
        posts.clear(); // clear previous data if any
        posts.addAll(postsList);
      });
      print('✅ All posts:-------------------> $posts');
    } catch (e) {
      print('❌ Error parsing posts:-----------------> $e');
    }
  }

  String selectedCategory = '';

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
    return MainLayoutWidget(
      isLoading: _isLoading,
      noDefaultBackground: true,
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20, top: 50),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Testing()),
                      );
                    },
                    child: Text('data'),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          pushNamedNavigate(
                            context: context,
                            pageName: notificationScreenRoute,
                          );
                        },
                        icon: Icon(Icons.notifications_none, size: 30),
                      ),
                      Positioned(
                        top: 6,
                        right: 8,
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
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Stack(
                  //   children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add_a_photo_outlined, size: 30),
                  ),

                  SizedBox(width: 20),
                ],
              ),
            ),

            Container(
              color: Colors.white,
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allUsersList.length,
                itemBuilder: (context, index) {
                  final story = allUsersList[index];
                  return Container(
                    padding: EdgeInsets.only(left: index == 0 ? 16 : 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.yellow, Colors.orange],
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundImage:
                                      story['profile_picture'] != null &&
                                              story['profile_picture']
                                                  .toString()
                                                  .isNotEmpty
                                          ? NetworkImage(
                                            story['profile_picture'] ??
                                                'https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png',
                                          )
                                          : AssetImage(
                                                'assets/profile/user.png',
                                              )
                                              as ImageProvider,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            story['full_name'],
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sportsCategories.length,
                  itemBuilder: (BuildContext context, int index) {
                    String category = sportsCategories[index];
                    bool isSelected = selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          print('kjfskdjfhsdjf---->>>>$selectedCategory');
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          // vertical: 8,
                        ),
                        // margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  isSelected
                                      ? Colors.black
                                      : const Color.fromARGB(
                                        192,
                                        213,
                                        213,
                                        213,
                                      ),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.black : Palette.darkgray,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount:
                      posts
                          .where(
                            (post) =>
                                post['player_category'] == selectedCategory,
                          )
                          .length,
                  itemBuilder: (context, index) {
                    final filteredPosts =
                        posts
                            .where(
                              (post) =>
                                  post['player_category'] == selectedCategory,
                            )
                            .toList();
                    final post = filteredPosts[index];

                    if (post['post_type'] == 'text') {
                      // Display post_description in PostCard
                      return PostCard(
                        post: post,
                        displayType: PostDisplayType.text,
                      );
                    } else if (post['post_type'] == 'image') {
                      // Display image_url and post_description in PostCard
                      return PostCard(
                        post: post,
                        displayType: PostDisplayType.image,
                      );
                    } else if (post['post_type'] == 'video') {
                      // Display video_url and post_description in PostCard
                      return PostCard(
                        post: post,
                        displayType: PostDisplayType.video,
                      );
                    } else {
                      // Handle any other cases here, though your provided examples cover text, image, and video scenarios
                      return SizedBox(); // Placeholder for other scenarios
                    }
                  },
                ),
              ),
            ),

            // CustomButton(
            //   onPressed: () {
            //     print('dlgfdhjjg');
            //     getNotifications();
            //   },
            //   text: 'ewfsefs',
            // ),
          ],
        ),
      ),
    );
  }
}
