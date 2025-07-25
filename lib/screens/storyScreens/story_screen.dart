import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/provider/stories_provider.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

import '../../helper/basic_enum.dart';
import '../../helper/close_keyboard.dart';
import '../../provider/home_provider.dart';
import '../../widgets/alerts/alert_notification_widget.dart';
import '../../widgets/video_player_widget.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List<dynamic> stories = [];
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isLoading = false;
  File? selectedFile;
  String? mediaType; // image or video
  bool isImage(String url) {
    return url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif');
  }

  Future<void> getAllStories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await Provider.of<StoriesProvider>(
            context,
            listen: false,
          ).getStories();
      stories.addAll(response['stories']);
      print('all stories get success ------->>>>>${stories.toList()}');
    } catch (e) {
      print('all stories get error    e ------->>>>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  Future<void> handleSubmit(StateSetter setModalState) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      closeKeyboard(context: context);

      try {
        final response = await Provider.of<StoriesProvider>(
          context,
          listen: false,
        ).addStory(formData: _formData);
        print('story added successfully------------>>>$response');
      } catch (e) {
        alertNotification(
          context: context,
          message: 'Something went wrong, try again later.',
          messageType: AlertMessageType.error,
        );
        print('Error saving comment: $e');
      }
    } else {
      alertNotification(
        context: context,
        message: 'Please enter a valid comment.',
        messageType: AlertMessageType.error,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllStories();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return GestureDetector(
                    onTap: () {
                      print(
                        'here we will open the post details----${story['post_type']}',
                      );
                    },
                    child: Stack(
                      children: [
                        // Text('data'),
                        Container(
                          // height: 150,
                          // width: 150,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                const Color.fromARGB(221, 28, 28, 28),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),

                            //  NetworkImage(story['video_url']),
                            // AssetImage(
                            //   post['image_url'],
                            // ),
                            // fit: BoxFit.cover,
                          ),

                          child:
                              isImage(story['video_url'])
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      story['video_url'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      children: [
                                        // Show a placeholder or thumbnail
                                        Stack(
                                          children: [
                                            // Positioned(
                                            //   child: Container(
                                            //     color: Colors.black26,
                                            //     child: Center(
                                            //       child: Icon(
                                            //         Icons.play_circle_fill,
                                            //         size: 50,
                                            //         color: Colors.white,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: VideoPlayerWidget(
                                                stopPlaying: true,
                                                iconsize: 18,
                                                videoUrl: story['video_url'],
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Optionally add VideoPlayer here
                                        // Example: VideoPlayer(videoController)
                                      ],
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
                                color: Color.fromARGB(255, 199, 70, 70),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                story['user_name'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,

                    minLines: 1,
                    onSaved: (value) {
                      handleSave('title', value!);
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,

                    minLines: 1,
                    onSaved: (value) {
                      handleSave('post_description', value!);
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'post_description',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
