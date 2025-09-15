import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/provider/stories_provider.dart';
import 'package:sportzstar/screens/storyScreens/story_details_screen.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

import '../../helper/basic_enum.dart';
import '../../helper/close_keyboard.dart';
import '../../widgets/alerts/alert_notification_widget.dart';
import '../../widgets/video_player_widget.dart';
import '../bottom_navigation_bar.dart';

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
  int totalStories = 0;
  File? _mediaFile;
  String _postType = '';

  bool isImage(String url) {
    return url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif');
  }

  bool isLocal(String path) {
    return !path.startsWith('http');
  }

  Future<void> getUserStories() async {
    setState(() => _isLoading = true);
    try {
      final response =
          await Provider.of<StoriesProvider>(
            context,
            listen: false,
          ).getStories();

      stories = response['stories'];
      totalStories = response['total_stories'];
    } catch (e) {
      debugPrint('Error fetching stories: $e');
    }
    setState(() => _isLoading = false);
  }

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  Future<void> handleSubmit(StateSetter setModalState) async {
    setState(() => _isLoading = true);

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      closeKeyboard(context: context);
      try {
        final response = await Provider.of<StoriesProvider>(
          context,
          listen: false,
        ).addStory(
          formData:
              _formData..addAll({
                'post_type': _postType,
                'created_at': DateTime.now().toString(),
              }),
          file: _mediaFile,
          postType: _postType,
        );

        debugPrint('Story added: $response');
        if (_mediaFile != null) {
          _mediaFile = null;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BottomNavigationBarScreen(pageIndex: 1),
          ),
        );
      } catch (e) {
        alertNotification(
          context: context,
          message: 'Something went wrong, try again later.',
          messageType: AlertMessageType.error,
        );
      }
    } else {
      alertNotification(
        context: context,
        message: 'Please enter a valid comment.',
        messageType: AlertMessageType.error,
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> pickMedia() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Pick Image'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _mediaFile = File(pickedFile.path);
                      _postType = 'image';
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Pick Video'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickVideo(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _mediaFile = File(pickedFile.path);
                      _postType = 'video';
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserStories();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MainLayoutWidget(
      noDefaultBackground: true,
      isLoading: _isLoading,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Stories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        decoration: BoxDecoration(
          gradient: Palette.lightGreenGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FloatingActionButton(
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 123, 123, 123),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Add Story Item',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                onSaved:
                                    (value) => handleSave('title', value ?? ''),
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                  filled: true,
                                  fillColor: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                onSaved:
                                    (value) => handleSave(
                                      'post_description',
                                      value ?? '',
                                    ),
                                decoration: const InputDecoration(
                                  hintText: 'Post Description',
                                  filled: true,
                                  fillColor: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: pickMedia,
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.photo_library,
                                      size: 50,
                                      color: Colors.green,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Pick from Gallery',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed:
                              () =>
                                  _mediaFile != null
                                      ? handleSubmit(setModalState)
                                      : alertNotification(
                                        context: context,
                                        message: 'Please Upload Image or Video',
                                        messageType: AlertMessageType.warning,
                                      ),
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            totalStories == 0
                ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/nostories.png', scale: 2),
                      const SizedBox(height: 12),
                      const Text(
                        'No Stories Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.1),
                    ],
                  ),
                )
                : LayoutBuilder(
                  builder: (context, constraints) {
                    // dynamically calculate grid crossAxisCount
                    int crossAxisCount = (constraints.maxWidth / 120)
                        .floor()
                        .clamp(2, 6);

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        final story = stories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StoryDetailScreen(story: story),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child:
                                      isImage(story['video_url'])
                                          ? isLocal(story['video_url'])
                                              ? Image.file(
                                                File(story['video_url']),
                                                fit: BoxFit.cover,
                                              )
                                              : Image.network(
                                                story['video_url'],
                                                fit: BoxFit.cover,
                                              )
                                          : VideoPlayerWidget(
                                            videoUrl: story['video_url'],
                                          ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.transparent,
                                          Color.fromARGB(221, 28, 28, 28),
                                        ],
                                        center: Alignment.center,
                                        radius: 0.85,
                                      ),
                                    ),
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
                          ),
                        );
                      },
                    );
                  },
                ),
      ),
    );
  }
}
