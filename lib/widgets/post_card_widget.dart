import 'package:flutter/material.dart';


class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post['profileImage'] ??
                  'https://via.placeholder.com/150'), // fallback
            ),
            title: Text(post['username']),
            subtitle: Text(post['time']),
          ),

          // Post Text
          if (post['text'] != null && post['text'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(post['text']),
            ),

          // Post Image
          if (post['image'] != null && post['image'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post['image'],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),

          const SizedBox(height: 8),

          // Likes & Comments count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text('${post['likes']}'),
                const SizedBox(width: 16),
                Icon(Icons.comment, size: 20),
                const SizedBox(width: 4),
                Text('${post['comments']}'),
              ],
            ),
          ),

          const Divider(),

          // Like and Comment buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                  label: const Text('Like'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined),
                  label: const Text('Comment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}