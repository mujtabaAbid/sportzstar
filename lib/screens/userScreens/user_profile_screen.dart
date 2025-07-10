import 'package:flutter/material.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
                                    // padding: const EdgeInsets.symmetric(
                                    //   horizontal: 24,
                                    //   vertical: 10,
                                    // ),
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

                      // Tabs
                      // const Divider(),
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            const TabBar(
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.black,
                              tabs: [
                                Tab(icon: Icon(Icons.grid_on)),
                                Tab(
                                  icon: Icon(Icons.video_collection_outlined),
                                ),
                                Tab(icon: Icon(Icons.bookmark_border)),
                              ],
                            ),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                children: [
                                  // Grid Posts
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 3,
                                      childAspectRatio: 0.6,
                                      children: const [
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/twoImage.jpeg',
                                          likes: '95K',
                                        ),
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/threeImage.jpeg',
                                          likes: '99K',
                                        ),
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/fourImage.jpeg',
                                          likes: '126K',
                                        ),
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/twoImage.jpeg',
                                          likes: '95K',
                                        ),
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/threeImage.jpeg',
                                          likes: '99K',
                                        ),
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/fourImage.jpeg',
                                          likes: '126K',
                                        ),
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/twoImage.jpeg',
                                          likes: '95K',
                                        ),
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/threeImage.jpeg',
                                          likes: '99K',
                                        ),
                                        _PostTile(
                                          imgPath:
                                              'assets/profile/fourImage.jpeg',
                                          likes: '126K',
                                        ),

                                        // Add more as needed
                                      ],
                                    ),
                                  ),
                                  Center(child: Text("Reels")),
                                  Center(child: Text("Saved")),
                                ],
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

class _PostTile extends StatelessWidget {
  final String imgPath;
  final String likes;

  const _PostTile({required this.imgPath, required this.likes});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imgPath),
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
              const Icon(Icons.favorite, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                likes,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
