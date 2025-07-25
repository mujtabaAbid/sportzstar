
import 'package:flutter/material.dart';
import 'package:sportzstar/widgets/video_player_widget.dart';


class StoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> story;

  const StoryDetailScreen({super.key, required this.story});

  bool isImage(String url) {
    return url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story['title'] ?? 'Story Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isImage(story['video_url'])
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        story['video_url'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    )
                  : SizedBox(
                      height: 440,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: VideoPlayerWidget(
                          videoUrl: story['video_url'],
                          stopPlaying: false,
                          iconsize: 24,
                        ),
                      ),
                    ),
              Text(
                story['title'] ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                story['post_description'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'Posted by: ${story['user_name']}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
