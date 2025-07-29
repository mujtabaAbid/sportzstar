import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/provider/stories_provider.dart';
import 'package:sportzstar/screens/storyScreens/story_details_screen.dart';
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
  int totalStories = 0;
  File? selectedFile;
  String? mediaType;
  bool isImage(String url) {
    return url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif');
  }

  File? _mediaFile;
  String _postType = ''; // "image" or "video"

  bool isLocal(String path) {
    return !path.startsWith('http');
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
      setState(() {
        totalStories = response['total_stories'];
      });

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
        ).addStory(
          formData:
              _formData..addAll({
                'post_type': 'video', //_postType,
                // 'user_id': userId.toString(),
                'created_at': DateTime.now().toString(),
              }),
          file: _mediaFile,
          postType: _postType, // either "image" or "video"
        );
        print('story added successfully------------>>>$response');
      } catch (e) {
        alertNotification(
          context: context,
          message: 'Something went wrong, try again later.',
          messageType: AlertMessageType.error,
        );
        print('Error saving stories  e:------ $e');
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

  Future<void> pickMedia() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Pick Image'),
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
                leading: Icon(Icons.videocam),
                title: Text('Pick Video'),
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
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(
        title: Text('Stories', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: Palette.lightGreenGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FloatingActionButton(
          elevation: 0, // 🔄 Remove default shadow
          highlightElevation: 0,
          backgroundColor: Colors.transparent,

          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // final titleController = TextEditingController();
                // final descriptionController = TextEditingController();

                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Add Story Item',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                              const SizedBox(height: 10),

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
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  print('open galery');
                                  pickMedia();
                                },
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.photo_library,
                                      size: 50,
                                      color: Colors.green,
                                    ),
                                    SizedBox(height: 8),
                                    Text('Pick from Gallery'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Use titleController.text and descriptionController.text
                            // to handle data input
                            // Navigator.of(context).pop();
                            handleSubmit(setModalState);
                          },
                          child: const Text('Add'),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //       colors: [Colors.blue, Colors.purple],
                        //     ),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.transparent,
                        //       shadowColor: Colors.transparent,
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 24,
                        //         vertical: 12,
                        //       ),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       'Add',
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //   ),
                        // ),
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

      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            totalStories == 0
                ? Column(
                  spacing: 16,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Image.asset('assets/images/nostories.png', scale: 2),

                    Text(
                      'No Stories Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
                : Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
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
                              builder:
                                  (context) => StoryDetailScreen(story: story),
                            ),
                          );
                          print(
                            'here we will open the post details----${story['post_type']}',
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              // Media content (Image or Video)
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

                              // Gradient overlay (always on top of media)
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

                              // Bottom info (icon + text)
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
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
