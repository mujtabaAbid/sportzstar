import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/video_player_widget.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  const PostDetailScreen({super.key, required this.post});

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final List comments = post['comments_list'] ?? [];

    String formatDate(String isoDateString) {
      DateTime utcDate = DateTime.parse(isoDateString);
      DateTime localDate = utcDate.toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(localDate);
    }

    return MainLayoutWidget(
      isLoading: _isLoading,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(post['user_profile'] ?? ''),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['user_name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      post['created_at'] != null && post['created_at'] != ''
                          ? formatDate(post['created_at'])
                          : '',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === VIDEO ===
            if (post['video_url'] != null &&
                post['video_url'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: VideoPlayerWidget(videoUrl: post['video_url']),
              ),

            const SizedBox(height: 16),

            // === IMAGE ===
            if (post['image_url'] != null &&
                post['image_url'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post['image_url'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 450,
                ),
              ),

            const SizedBox(height: 16),

            // === TEXT ===
            if (post['post_description'] != null &&
                post['post_description'].toString().isNotEmpty)
              (post['image_url'] == null ||
                          post['image_url'].toString().isEmpty) &&
                      (post['video_url'] == null ||
                          post['video_url'].toString().isEmpty)
                  ? Center(
                    child: Container(
                  height: 450, 
                  width: double.infinity,
                    
                   decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), 
                     color: Colors.grey.shade100,
                   ),
                     
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${post['user_name']} : ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: post['post_description'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  : RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: '${post['user_name']} : ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: post['post_description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),

            const SizedBox(height: 16),

            // Likes & Comments Info
            Text('Likes: ${post['total_likes'] ?? 0}'),
            const SizedBox(height: 8),
            Text('Comments: ${comments.length}'),

            const SizedBox(height: 8),

            // === Comments List ===
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        (comment['user_profile'] != null &&
                                comment['user_profile'].toString().isNotEmpty)
                            ? NetworkImage(comment['user_profile'])
                            : const AssetImage('assets/profile/user.png')
                                as ImageProvider,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['user_name'],
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment['comment'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  subtitle: Text(formatDate(comment['created_at'])),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
 