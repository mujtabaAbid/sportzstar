import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/stories_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';
import 'package:video_player/video_player.dart';

import '../../config/palette.dart';

class StoryDetailScreen extends StatefulWidget {
  final Map<String, dynamic> story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late bool isVideo;
  late VideoPlayerController? _videoController;
  Timer? _timer;
  bool isClosing = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    // print('jkkjkjjoi--------->>>>>${widget.story}');

    final url = widget.story['video_url'] ?? '';
    isVideo =
        !(url.endsWith('.jpg') ||
            url.endsWith('.jpeg') ||
            url.endsWith('.png') ||
            url.endsWith('.gif'));

    if (isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();

          _videoController?.addListener(() {
            final controller = _videoController!;
            final total = controller.value.duration;
            final current = controller.value.position;

            if (mounted) {
              setState(() {
                progress = current.inMilliseconds / total.inMilliseconds;
              });
            }

            // ✅ Close screen when video ends
            if (controller.value.position >= controller.value.duration &&
                !controller.value.isPlaying) {
              Navigator.pop(context);
            }
          });
        });
    } else {
      _startTimer();
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(134, 0, 0, 0),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        // for bottom bar color
        systemNavigationBarColor: Color.fromARGB(138, 0, 0, 0),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _startTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 0.05 / (duration.inMilliseconds / 50);
        if (progress >= 1.0) {
          progress = 1.0;
          timer.cancel();
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> deleteStory({required int storyId}) async {
    try {
      final response = await Provider.of<StoriesProvider>(
        context,
        listen: false,
      ).deleteStoryFun(storyId);

      final message = json.decode(response.body);
      if (response.statusCode == 200) {
        alertNotification(
          context: context,
          message: message['message'],
          messageType: AlertMessageType.success,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarScreen(pageIndex: 1),
          ),
        );
        // pushNamedAndRemoveUntilNavigate(
        //   pageName: BottomNavigationBarScreen(storyId),
        //   context: context,
        // );
      } else {
        alertNotification(
          context: context,
          message: message['message'],
          messageType: AlertMessageType.error,
        );
      }
    } catch (e) {
      print('error in deleting story------.>>>>>$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) {
              final width = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < width / 2) {
                Navigator.pop(context); // Tap left to exit (or go back)
              } else {
                Navigator.pop(context); // Tap right to exit (or go next)
              }
            },
            child: Center(
              child:
                  isVideo
                      ? (_videoController != null &&
                              _videoController!.value.isInitialized)
                          ? SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            ),
                          )
                          : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                      : Image.network(
                        story['video_url'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
            ),
          ),

          // Top progress bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 10,
            right: 10,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          // Top info row
          Positioned(
            top: MediaQuery.of(context).padding.top + 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  story['user_name'] ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  offset: Offset(0, 30),

                  icon: Container(
                    padding: EdgeInsets.all(6), // inner spacing
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300, // background color
                      shape: BoxShape.circle, // makes it round
                    ),
                    child: Icon(Icons.more_vert, size: 20, color: Colors.black),
                  ), // icon size adjust as needed
                  onSelected: (String value) {
                    if (value == 'delete') {
                      print('Delete pressed');
                      deleteStory(storyId: story['story_id']);
                    } else if (value == 'close') {
                      print('Close pressed');
                      Navigator.pop(context);
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'close',
                          child: Row(
                            children: [
                              Icon(Icons.close, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Close'),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            // left: 16,
            // right: 16,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(139, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  story['description'] ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
