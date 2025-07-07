import 'package:flutter/material.dart';
import 'package:sportzstar/widgets/post_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of sports categories
  final List<String> sportsCategories = [
    'Badminton',
    'Baseball',
    'Cricket',
    'Beach handball',
    'Boxing',
    'Cycling',
    'Football',
    'Golf',
    'Hockey',
    'NetBall',
  ];
  final List<Map<String, dynamic>> posts = [
    {
      'username': 'zaheer',
      'time': '16 Apr 2025, 06:25 am',
      'text': 'hi everyone',
      'image':
          'https://yourdomain.com/zaheer_image.jpg', // Replace with real URL or Asset
      'likes': 2,
      'comments': 2,
      'profileImage': 'https://yourdomain.com/profile1.jpg', // optional
    },
    {
      'username': 'deemi testing',
      'time': '07 Apr 2025, 05:21 pm',
      'text': '',
      'image':
          'https://yourdomain.com/deemi_image.jpg', // Replace with real URL or Asset
      'likes': 0,
      'comments': 0,
      'profileImage': 'https://yourdomain.com/profile2.jpg', // optional
    },
  ];
  // Set default selected category to "Badminton"
  String selectedCategory = 'Badminton';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Column(
        children: [
          // Horizontal list
          Container(
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
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Display selected content
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            ),
          ),
        ],
      ),
    );
  }
}
