import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/captaliza.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/post_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/userScreens/edit_profile_screen.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';
import 'package:sportzstar/widgets/post_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/local_storage.dart';
import '../../widgets/video_player_widget.dart';
import '../postScreens/post_detail_screen.dart';
import 'full_image_view_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String selectedCategory = 'profile'; // 👈 default selected is 'Grid'
  Map<String, dynamic> userData = {};
  Map<String, dynamic> secondUser = {};
  List<dynamic> allUserPosts = [];
  bool _isLoading = false;
  String postsCount = '';
  String totalLikes = '';
  String totalcomments = '';

  final List<Map<String, dynamic>> myPostsGrid = [
    {'name': 'profile', 'icon': Icons.person},
    {'name': 'video', 'icon': Icons.grid_on},
    {'name': 'text', 'icon': Icons.text_format_outlined},
  ];

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pref = await getDataFromLocalStorage(name: 'userData');
      userData = json.decode(pref);
      print('userData ===----==>>>$userData');
    } catch (e) {
      print('error in getting user data------>>>>>>>$e');
    }
  }

  Future<void> getUserPosts() async {
    try {
      final response =
          await Provider.of<PostProvider>(
            context,
            listen: false,
          ).getAllUserPosts();
      allUserPosts = response;
      print('userData Posts===----==>>>$allUserPosts');

      postsCount = allUserPosts.length.toString();
      // Calculate total likes
      int likes = 0;
      int comments = 0;
      for (var post in allUserPosts) {
        likes += int.tryParse(post['total_likes'].toString()) ?? 0;
        comments += int.tryParse(post['total_comments'].toString()) ?? 0;
      }

      totalLikes = likes.toString();
      totalcomments = comments.toString();
      print(
        'total likes--->>> $totalLikes = == $totalcomments and posts ===----==>>>$postsCount',
      );

      // _selectedGender = userData['gender'];
    } catch (e) {
      print('error in getting user data------>>>>>>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void logoutFunction() async {
    try {
      final preference = await SharedPreferences.getInstance();
      await preference.clear();
      pushNamedAndRemoveUntilNavigate(
        pageName: loginScreenRoute,
        context: context,
      );
      alertNotification(
        context: context,
        message: 'User Logout Successfully',
        messageType: AlertMessageType.success,
      );
    } catch (e) {
      print('error in logut function ---->>>$e');
      alertNotification(
        context: context,
        message: 'User Not logout, Try again Later',
        messageType: AlertMessageType.error,
      );
    }
  }

  Future<void> deletePost({required int postId}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Provider.of<PostProvider>(
        context,
        listen: false,
      ).deletePostFunction(postId: postId);
      print('deletePost response ===----==>>>$response');
    } catch (e) {
      print('error in deletePost --->>>>>>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getUserData();
    getUserPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      noDefaultBackground: true,
      // backgroundColor: Colors.white,
      body: CustomScrollView(
        // physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ), // adjust top spacing

              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40), // Adjust height as needed
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopupMenuButton<String>(
                                color: const Color.fromARGB(144, 28, 72, 159),
                                icon: Icon(
                                  Icons.more_vert_outlined,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                onSelected: (String value) {
                                  if (value == 'edit') {
                                    pushNamedNavigate(
                                      context: context,
                                      pageName: editProfileScreenRoute,
                                    );

                                    print(
                                      '---edit post function call button--------',
                                    );
                                  } else if (value == 'logout') {
                                    logoutFunction();
                                    print(
                                      '---logout function call button--------',
                                    );
                                  } else {
                                    print('---Nothing call--------');
                                  }
                                },
                                itemBuilder:
                                    (BuildContext context) => [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Edit Profile',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'logout',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.logout_outlined,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Logout',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                              ),
                            ],
                          ),
                          // ),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => FullScreenImageViewer(
                                                imageUrl:
                                                    userData['profile_picture'],
                                              ),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 47,
                                        backgroundImage:
                                            userData['profile_picture'] !=
                                                        null &&
                                                    userData['profile_picture'] !=
                                                        ''
                                                ? NetworkImage(
                                                  userData['profile_picture'],
                                                )
                                                : const AssetImage(
                                                      'assets/profile/dummy.png',
                                                    )
                                                    as ImageProvider,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    pushNamedNavigate(
                                      context: context,
                                      pageName: chatListScreenRoute,
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Palette.basicColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Message',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            userData['full_name'] != null &&
                                    userData['full_name'] != ''
                                ? capitalize(userData['full_name'])
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          // const SizedBox(height: 2),
                          Text(
                            userData['username'] != null &&
                                    userData['username'] != ''
                                ? userData['username']
                                : '',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      // Rest of your profile content
                      Container(
                        // padding: EdgeInsets.only(left: 18),
                        // color: Colors.amber,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   userData['full_name'] != null &&
                            //           userData['full_name'] != ''
                            //       ? capitalize(userData['full_name'])
                            //       : '',
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 18,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            // // const SizedBox(height: 2),
                            // Text(
                            //   userData['username'] != null &&
                            //           userData['username'] != ''
                            //       ? userData['username']
                            //       : '',
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            // const SizedBox(height: 8),
                            // Text(
                            //   userData['player_category'] != null
                            //       ? '🏆 ${userData['player_category']}'
                            //       : '',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            // Text(
                            //   '📩 ${userData['email']}',
                            //   style: TextStyle(color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                      // Buttons Row
                      const SizedBox(height: 20),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(count: postsCount, label: 'Posts'),
                          _StatItem(count: totalLikes, label: 'Likes'),
                          _StatItem(count: totalcomments, label: 'Comments'),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Container(
                            // color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              height: 70,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    myPostsGrid.map((category) {
                                      final isSelected =
                                          selectedCategory == category['name'];
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = category['name'];
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color:
                                                    isSelected
                                                        ? Colors.white
                                                        : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: Icon(
                                            category['icon'],
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : Colors.grey,
                                            size: 28,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),

                          selectedCategory == 'profile'
                              ? Container(
                                margin: EdgeInsets.only(bottom: 200),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Player Info',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        // color: const Color.fromARGB(
                                        //   54,
                                        //   96,
                                        //   125,
                                        //   139,
                                        // ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   'Name: ${userData['full_name'] ?? 'N/A'}',
                                          //   style: TextStyle(
                                          //     color: Colors.white,
                                          //     fontSize: 14,
                                          //   ),
                                          // ),
                                          // Text(
                                          //   'Username: @${userData['username'] ?? 'N/A'}',
                                          //   style: TextStyle(
                                          //     color: Colors.white,
                                          //     fontSize: 14,
                                          //   ),
                                          // ),
                                          // Text(
                                          //   'Email: ${userData['email'] ?? 'N/A'}',
                                          //   style: TextStyle(
                                          //     color: Colors.white,
                                          //     fontSize: 14,
                                          //   ),
                                          // ),
                                          if (userData['age'] != null)
                                            Text(
                                              'Age: ${userData['age']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),

                                          // if ((userData['gender'] ?? '')
                                          //     .toString()
                                          //     .isNotEmpty)
                                          //   Text(
                                          //     'Gender: ${userData['gender']}',
                                          //     style: TextStyle(
                                          //       color: Colors.white,
                                          //       fontSize: 14,
                                          //     ),
                                          //   ),
                                          if ((userData['player_category'] ??
                                                  '')
                                              .toString()
                                              .isNotEmpty)
                                            Text(
                                              'Player: ${userData['player_category']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          if ((userData['start_year'] ?? '')
                                              .toString()
                                              .isNotEmpty)
                                            Text(
                                              'Start Year: ${userData['start_year']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    if ((userData['bio'] ?? '')
                                        .toString()
                                        .isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bio',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              // color: const Color.fromARGB(
                                              //   54,
                                              //   96,
                                              //   125,
                                              //   139,
                                              // ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${userData['bio']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    SizedBox(height: 10),
                                    if (userData['social_links'] != null &&
                                        (userData['social_links'] as List)
                                            .isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Social Media',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              // color: const Color.fromARGB(
                                              //   54,
                                              //   96,
                                              //   125,
                                              //   139,
                                              // ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...List<Widget>.from(
                                                  (userData['social_links']
                                                          as List)
                                                      .map(
                                                        (linkData) => Text(
                                                          '${linkData['platform']}: ${linkData['link']}',
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                              ),
                                                        ),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    SizedBox(height: 10),

                                    if ((userData['medals'] ?? '')
                                        .toString()
                                        .isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Medals',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              // color: const Color.fromARGB(
                                              //   54,
                                              //   96,
                                              //   125,
                                              //   139,
                                              // ),
                                            ),
                                            child: Text(
                                              '${userData['medals']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    // Career History (List)
                                    if ((userData['career_history'] ?? [])
                                            is List &&
                                        (userData['career_history'] ?? [])
                                            .isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Career History:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          // color: const Color.fromARGB(
                                          //   54,
                                          //   96,
                                          //   125,
                                          //   139,
                                          // ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...List<Widget>.from(
                                              (userData['career_history'] as List).map(
                                                (career) => Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if ((career['title'] ?? '')
                                                        .toString()
                                                        .isNotEmpty)
                                                      Text(
                                                        '🔹 Title: ${career['title']}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    if ((career['clubName'] ??
                                                            '')
                                                        .toString()
                                                        .isNotEmpty)
                                                      Text(
                                                        '🏛 Club: ${career['clubName']}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    if ((career['description'] ??
                                                            '')
                                                        .toString()
                                                        .isNotEmpty)
                                                      Text(
                                                        '📄 Description: ${career['description']}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    if ((career['start_date'] ??
                                                            '')
                                                        .toString()
                                                        .isNotEmpty)
                                                      Text(
                                                        '📅 Start: ${career['start_date']}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    if ((career['end_date'] ??
                                                            '')
                                                        .toString()
                                                        .isNotEmpty)
                                                      Text(
                                                        '📅 End: ${career['end_date']}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    const SizedBox(height: 6),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                              : selectedCategory == 'text'
                              ? Container(
                                margin: EdgeInsets.only(bottom: 200),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                  ),
                                  itemCount:
                                      allUserPosts
                                          .where(
                                            (post) =>
                                                post['post_type'] ==
                                                selectedCategory,
                                          )
                                          .length,
                                  itemBuilder: (context, index) {
                                    final filteredPosts =
                                        allUserPosts
                                            .where(
                                              (post) =>
                                                  post['post_type'] ==
                                                  selectedCategory,
                                            )
                                            .toList();
                                    final post = filteredPosts[index];

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => PostDetailScreen(
                                                  post: post,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            218,
                                            218,
                                            218,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          spacing: 6,

                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //   Text(
                                            //   '${post['title']} deew',
                                            //   style: const TextStyle(
                                            //     fontSize: 12,
                                            //   ),
                                            // ),
                                            Text(
                                              '${post['post_description']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),

                                            Row(
                                              spacing: 6,
                                              children: [
                                                Icon(
                                                  Icons.thumb_up,
                                                  size: 16,
                                                  color:
                                                      post['total_likes'] == 0
                                                          ? Palette.basicgray
                                                          : Palette.basicgreen,
                                                ),
                                                Text(
                                                  post['total_likes']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Icon(
                                                  Icons.comment_outlined,
                                                  size: 16,
                                                  color:
                                                      post['total_comments'] ==
                                                              0
                                                          ? Palette.darkgray
                                                          : Palette.basicgreen,
                                                ),
                                                Text(
                                                  post['total_comments']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                              : Container(
                                margin: EdgeInsets.only(bottom: 200),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                  ),
                                  itemCount:
                                      allUserPosts
                                          .where(
                                            (post) =>
                                                post['post_type'] != 'text' &&
                                                    post['image_url'] != null ||
                                                post['video_url'] != null,
                                          )
                                          .length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 6,
                                        crossAxisSpacing: 6,
                                        childAspectRatio: 1,
                                      ),
                                  itemBuilder: (context, index) {
                                    final filteredPosts =
                                        allUserPosts
                                            .where(
                                              (post) =>
                                                  post['post_type'] != 'text' &&
                                                      post['image_url'] !=
                                                          null ||
                                                  post['video_url'] != null,
                                            )
                                            .toList();
                                    final post = filteredPosts[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => PostDetailScreen(
                                                  post: post,
                                                ),
                                          ),
                                        );
                                        print(
                                          'here we will open the post details----${post['post_type']}',
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          // post['post_type'] == 'text'
                                          //     ? Text(post['post_description'])
                                          //     : post['post_type'] == 'video'
                                          //     ? Text(post['video_url'])
                                          //     :
                                          (post['post_type'] == 'video' &&
                                                  post['video_url'] != null)
                                              //  ||
                                              //   (post['post_type'] == 'image' && post['image_url'] != null))
                                              ? (post['video_url'].endsWith(
                                                        '.mp4',
                                                      ) ||
                                                      post['video_url']
                                                          .endsWith('.mov') ||
                                                      post['video_url']
                                                          .endsWith('.avi') ||
                                                      post['video_url']
                                                          .endsWith('.mkv'))
                                                  ? VideoPlayerWidget(
                                                    iconsize: 20,
                                                    noFullScreenIcon: true,
                                                    stopPlaying: true,
                                                    fullWidth: true,
                                                    videoUrl: post['video_url'],
                                                  )
                                                  : Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          post['video_url'],
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      // : DecorationImage(
                                                      //   image: AssetImage(
                                                      //     'assets/images/nostories.png',
                                                      //   ),
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                      // borderRadius:
                                                      //     BorderRadius.circular(8),
                                                    ),
                                                  )
                                              : (post['post_type'] == 'image' &&
                                                  post['image_url'] != null)
                                              ? Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      post['image_url'],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  // : DecorationImage(
                                                  //   image: AssetImage(
                                                  //     'assets/images/nostories.png',
                                                  //   ),
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  // borderRadius:
                                                  //     BorderRadius.circular(8),
                                                ),
                                              )
                                              : Center(
                                                child: SizedBox(
                                                  child: Icon(
                                                    Icons
                                                        .image_not_supported_outlined,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),

                                          Positioned(
                                            bottom: 6,
                                            left: 6,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.favorite,
                                                  size: 14,
                                                  color:
                                                      post['total_likes'] == 0
                                                          ? const Color.fromARGB(
                                                            255,
                                                            155,
                                                            155,
                                                            155,
                                                          )
                                                          : Color.fromARGB(
                                                            255,
                                                            199,
                                                            70,
                                                            70,
                                                          ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  post['post_id'].toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Positioned(
                                          //   top: 0,
                                          //   right: 0,
                                          //   child: Container(
                                          //     height: 24,
                                          //     width: 30,
                                          //     color: Colors.red,
                                          //     child: PopupMenuButton<String>(
                                          //       padding: EdgeInsets.zero,
                                          //       constraints: BoxConstraints(),
                                          //       icon: Icon(
                                          //         Icons.more_horiz,
                                          //         color: Colors.white,
                                          //         size: 24,
                                          //       ),
                                          //       onSelected: (String value) {
                                          //         if (value == 'delete') {
                                          //           deletePost(
                                          //             postId: post['post_id'],
                                          //           );
                                          //           print(
                                          //             '---delete post function call button--------',
                                          //           );
                                          //         } else if (value == 'update') {
                                          //           print(
                                          //             '---update post function call button--------',
                                          //           );
                                          //         }
                                          //       },
                                          //       itemBuilder:
                                          //           (BuildContext context) => [
                                          //             PopupMenuItem<String>(
                                          //               value: 'delete',
                                          //               child: Row(
                                          //                 children: [
                                          //                   Icon(
                                          //                     Icons.delete,
                                          //                     color: Colors.red,
                                          //                   ),
                                          //                   SizedBox(width: 8),
                                          //                   Text('Delete Post'),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //             PopupMenuItem<String>(
                                          //               value: 'update',
                                          //               child: Row(
                                          //                 children: [
                                          //                   Icon(
                                          //                     Icons.edit,
                                          //                     color: Colors.blue,
                                          //                   ),
                                          //                   SizedBox(width: 8),
                                          //                   Text('Edit Post'),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           ],
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, letterSpacing: 2, color: Colors.grey),
        ),
      ],
    );
  }
}

// class _PostTile extends StatelessWidget {
//   final String imgPath;
//   final String likes;

//   const _PostTile({required this.imgPath, required this.likes});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(imgPath),
//               fit: BoxFit.cover,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         Positioned(
//           bottom: 6,
//           left: 6,
//           child: Row(
//             children: [
//               const Icon(Icons.favorite, size: 14, color: Colors.white),
//               const SizedBox(width: 4),
//               Text(
//                 likes,
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
