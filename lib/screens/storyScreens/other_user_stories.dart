import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/provider/stories_provider.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class OtherUserStoryDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> story;

  const OtherUserStoryDetailScreen({super.key, required this.story});

  @override
  State<OtherUserStoryDetailScreen> createState() =>
      _OtherUserStoryDetailScreenState();
}

class _OtherUserStoryDetailScreenState
    extends State<OtherUserStoryDetailScreen> {
  // final PageController _pageController = PageController();
  int currentIndex = 0;

  VideoPlayerController? _videoController;
  Timer? _timer;
  double progress = 0;

  bool get isVideo {
    final url = widget.story[currentIndex]['video_url'] ?? '';
    return !(url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif'));
  }

  @override
  void initState() {
    super.initState();
    _loadStory();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(134, 0, 0, 0),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color.fromARGB(138, 0, 0, 0),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
  void _loadStory() async {
  _videoController?.dispose();
  _timer?.cancel();
  progress = 0;

  final url = widget.story[currentIndex]['video_url'] ?? '';

  if (isVideo) {
    try {
      // Download video to cache
      final file = await DefaultCacheManager().getSingleFile(url);

      // Initialize controller with local file
      _videoController = VideoPlayerController.file(file);
      await _videoController!.initialize();

      setState(() {});

      _videoController!.play();

      _videoController!.addListener(() {
        final controller = _videoController!;
        final total = controller.value.duration;
        final current = controller.value.position;

        if (mounted) {
          setState(() {
            progress = current.inMilliseconds / total.inMilliseconds;
          });
        }

        if (controller.value.position >= total &&
            !controller.value.isPlaying) {
          _goToNextStory();
        }
      });
    } catch (e) {
      print('❌ OtherUserStoryDetailScreen video init error: $e');
    }
  } else {
    _startImageTimer();
  }
}

  // void _loadStory() {
  //   _videoController?.dispose();
  //   _timer?.cancel();
  //   progress = 0;

  //   final url = widget.story[currentIndex]['video_url'] ?? '';

  //   if (isVideo) {
  //     _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
  //       ..initialize().then((_) {
  //         setState(() {});
  //         _videoController?.play();

  //         _videoController?.addListener(() {
  //           final controller = _videoController!;
  //           final total = controller.value.duration;
  //           final current = controller.value.position;

  //           if (mounted) {
  //             setState(() {
  //               progress = current.inMilliseconds / total.inMilliseconds;
  //             });
  //           }

  //           if (controller.value.position >= total &&
  //               !controller.value.isPlaying) {
  //             _goToNextStory();
  //           }
  //         });
  //       });
  //   } else {
  //     _startImageTimer();
  //   }
  // }
  

  void _startImageTimer() {
    // const duration = Duration(seconds: 1);
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 01.0 / (50);
        if (progress >= 1.0) {
          timer.cancel();
          _goToNextStory();
        }
      });
    });
  }

  void _goToNextStory() {
    if (currentIndex < widget.story.length - 1) {
      setState(() {
        currentIndex++;
      });
      _loadStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _goToPreviousStory() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _loadStory();
    } else {
      Navigator.pop(context);
    }
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
      } else {
        alertNotification(
          context: context,
          message: message['message'],
          messageType: AlertMessageType.error,
        );
      }
    } catch (e) {
      print('Error deleting story: $e');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _timer?.cancel();
    // _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        // for bottom bar color
        systemNavigationBarColor: const Color.fromARGB(255, 28, 26, 49),
        // .fromARGB(
        //   255,
        //   247,
        //   247,
        //   247,
        // ), // light background
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final story = widget.story[currentIndex];

    final isCurrentVideo = !(story['video_url']?.endsWith('.jpg') ?? true);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) {
              final width = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < width / 2) {
                _goToPreviousStory();
              } else {
                _goToNextStory();
              }
            },
            child: Center(
              child:
                  isCurrentVideo
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

          // Progress bar (multi-segment)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 10,
            right: 10,
            child: _buildProgressBars(),
          ),

          // User info and menu
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

                // PopupMenuButton<String>(
                //   padding: EdgeInsets.zero,
                //   offset: Offset(0, 30),
                //   icon: Container(
                //     padding: EdgeInsets.all(6),
                //     decoration: BoxDecoration(
                //       color: Colors.grey.shade300,
                //       shape: BoxShape.circle,
                //     ),
                //     child: Icon(Icons.more_vert, size: 20, color: Colors.black),
                //   ),
                //   onSelected: (String value) {
                //     if (value == 'delete') {
                //       deleteStory(storyId: story['story_id']);
                //     } else if (value == 'close') {
                //       Navigator.pop(context);
                //     }
                //   },
                //   itemBuilder:
                //       (BuildContext context) => [
                //         PopupMenuItem<String>(
                //           value: 'delete',
                //           child: Row(
                //             children: [
                //               Icon(Icons.delete, color: Colors.red),
                //               SizedBox(width: 8),
                //               Text('Delete'),
                //             ],
                //           ),
                //         ),
                //         PopupMenuItem<String>(
                //           value: 'close',
                //           child: Row(
                //             children: [
                //               Icon(Icons.close, color: Colors.grey),
                //               SizedBox(width: 8),
                //               Text('Close'),
                //             ],
                //           ),
                //         ),
                //       ],
                // ),
              ],
            ),
          ),

          // Story description at bottom
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(139, 0, 0, 0),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                story['description'] ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBars() {
    return Row(
      children: List.generate(widget.story.length, (index) {
        double value;
        if (index < currentIndex) {
          value = 1.0; // already seen
        } else if (index == currentIndex) {
          value = progress; // current story in progress
        } else {
          value = 0.0; // upcoming
        }

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 4,
            ),
          ),
        );
      }),
    );
  }
}
