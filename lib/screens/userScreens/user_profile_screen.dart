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

import '../../helper/local_storage.dart';
import '../postScreens/post_detail_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String selectedCategory = 'image'; // 👈 default selected is 'Grid'
  Map<String, dynamic> userData = {};
  Map<String, dynamic> secondUser = {};
  List<dynamic> allUserPosts = [];
  bool _isLoading = false;
  String postsCount = '';
  String totalLikes = '';
  String totalcomments = '';
  // List<dynamic> filteredPosts = [];

  final List<Map<String, dynamic>> myPostsGrid = [
    {'name': 'image', 'icon': Icons.grid_on},
    {'name': 'video', 'icon': Icons.video_collection_outlined},
    {'name': 'text', 'icon': Icons.bookmark_border},
  ];

  // final List<Map<String, dynamic>> posts = [
  //   {
  //     'post_type': 'image',
  //     'data': 'assets/profile/twoImage.jpeg', // Replace with real URL or Asset
  //     'total_likes': '96k',
  //   },
  //   {
  //     'post_type': 'Videos',
  //     'data': 'assets/profile/oneImage.jpeg', // Replace with real URL or Asset
  //     'total_likes': '66k',
  //   },
  //   {
  //     'post_type': 'text',
  //     'data':
  //         'assets/profile/threeImage.jpeg', // Replace with real URL or Asset
  //     'total_likes': '100k',
  //   },
  // ];

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pref = await getDataFromLocalStorage(name: 'userData');
      userData = json.decode(pref);
      print('userData ===----==>>>$userData');
      // _selectedGender = userData['gender'];
    } catch (e) {
      print('error in getting user data------>>>>>>>$e');
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  Future<void> getUserPosts() async {
    try {
      final response =
          await Provider.of<PostProvider>(
            context,
            listen: false,
          ).getAllUserPosts();
      allUserPosts = response;
      print('userData ===----==>>>$allUserPosts');

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
      // backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            expandedHeight: 200,
            backgroundColor: const Color.fromARGB(255, 250, 248, 248),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    // height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/profile/cover.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Transform.translate(
                offset: const Offset(0, 50), // pushes down half image
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 47,
                              backgroundImage:
                                  userData['profile_picture'] != null &&
                                          userData['profile_picture'] != ''
                                      ? NetworkImage(
                                        userData['profile_picture'],
                                      )
                                      : AssetImage('assets/profile/dummy.png'),
                            ),
                          ),

                          const SizedBox(width: 20),
                          userData['id'] == secondUser['id']
                              ? Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {},
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFCBFE15,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Follow',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 30),
                height: 30,

                child: PopupMenuButton<String>(
                  color: Colors.transparent,
                  icon: Icon(Icons.more_horiz_rounded, size: 24),
                  onSelected: (String value) {
                    if (value == 'edit') {
                      pushNamedNavigate(
                        context: context,
                        pageName: editProfileScreenRoute,
                      );

                      print('---edit post function call button--------');
                    } else if (value == 'logout') {
                      logoutFunction();
                      print('---logout function call button--------');
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
                              Icon(Icons.edit, color: Palette.basicgreen),
                              SizedBox(width: 8),
                              Text('Edit Profile'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: Palette.basicgreen,
                              ),
                              SizedBox(width: 8),
                              Text('Logout'),
                            ],
                          ),
                        ),
                      ],
                ),
                // const Icon(
                //   Icons.more_horiz,
                //   size: 14,
                //   color: Colors.black,
                // ),
              ),
              // ),
            ],
          ),
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
                      const SizedBox(height: 60), // Adjust height as needed
                      // Rest of your profile content
                      Container(
                        // padding: EdgeInsets.only(left: 18),
                        // color: Colors.amber,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['full_name'] != null &&
                                      userData['full_name'] != ''
                                  ? capitalize(userData['full_name'])
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            // const SizedBox(height: 2),
                            Text(
                              userData['username'] != null &&
                                      userData['username'] != ''
                                  ? userData['username']
                                  : '',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              userData['player_category'] != null
                                  ? '🏆 ${userData['player_category']}'
                                  : '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '📩 ${userData['email']}',
                              style: TextStyle(color: Colors.black),
                            ),
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
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: Icon(
                                            category['icon'],
                                            color:
                                                isSelected
                                                    ? Colors.black
                                                    : Colors.grey,
                                            size: 28,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),

                          selectedCategory == 'text'
                              ? ListView.builder(
                                shrinkWrap: true,
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
                                              (_) =>
                                                  PostDetailScreen(post: post),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          218,
                                          218,
                                          218,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        spacing: 6,

                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${post['post_description']}',
                                            style: const TextStyle(
                                              fontSize: 14,
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
                                                post['total_likes'].toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Icon(
                                                Icons.comment_outlined,
                                                size: 16,
                                                color:
                                                    post['total_comments'] == 0
                                                        ? Palette.darkgray
                                                        : Palette.basicgreen,
                                              ),
                                              Text(
                                                post['total_comments']
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                              : GridView.builder(
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
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
                                              (_) =>
                                                  PostDetailScreen(post: post),
                                        ),
                                      );
                                      print(
                                        'here we will open the post details----${post['post_type']}',
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        post['post_type'] == 'text'
                                            ? Text(post['post_description'])
                                            : post['post_type'] == 'video'
                                            ? Text(post['video_url'])
                                            : Container(
                                              // height: 150,
                                              // width: 150,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    post['image_url'],
                                                  ),
                                                  // AssetImage(
                                                  //   post['image_url'],
                                                  // ),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                post['total_likes'].toString(),
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
            color: Colors.black,
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
