import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String selectedCategory = 'Grid'; // 👈 default selected is 'Grid'

  final List<Map<String, dynamic>> sportsCategories = [
    {'name': 'Grid', 'icon': Icons.grid_on},
    {'name': 'Videos', 'icon': Icons.video_collection_outlined},
    {'name': 'Bookmarks', 'icon': Icons.bookmark_border},
  ];

  final List<Map<String, dynamic>> posts = [
    {
      'category': 'Grid',

      'image': 'assets/profile/twoImage.jpeg', // Replace with real URL or Asset
      'likes': '96k',
    },
    {
      'category': 'Videos',

      'image': 'assets/profile/oneImage.jpeg', // Replace with real URL or Asset
      'likes': '66k',
    },
    {
      'category': 'Bookmarks',

      'image': 'assets/profile/threeImage.jpeg', // Replace with real URL or Asset
      'likes': '100k',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: const CircleAvatar(
                              radius: 47,
                              backgroundImage: AssetImage(
                                'assets/profile/profile.jpeg',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
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
                                    backgroundColor: const Color(0xFFCBFE15),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ), // adjust top spacing

              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60), // Adjust height as needed
                      // Rest of your profile content
                      const Text(
                        'Aditya Prasodjo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '@aditya_prasodjo',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '🎥 Content creator & Filmmaker',
                        style: TextStyle(fontSize: 14),
                      ),
                      const Text(
                        '📍 Surabaya, Indonesia',
                        style: TextStyle(color: Colors.grey),
                      ),

                      // Buttons Row
                      const SizedBox(height: 20),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _StatItem(count: '200', label: 'Posts'),
                          _StatItem(count: '97.5K', label: 'Followers'),
                          _StatItem(count: '121', label: 'Following'),
                          _StatItem(count: '3.25M', label: 'Likes'),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              height: 70,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    sportsCategories.map((category) {
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

                          GridView.builder(
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            itemCount:
                                posts
                                    .where(
                                      (post) =>
                                          post['category'] == selectedCategory,
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
                                  posts
                                      .where(
                                        (post) =>
                                            post['category'] ==
                                            selectedCategory,
                                      )
                                      .toList();
                              final post = filteredPosts[index];
                              return Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(post['image']),
                                        fit: BoxFit.cover,

                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    left: 6,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.favorite,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          post['likes'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
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
