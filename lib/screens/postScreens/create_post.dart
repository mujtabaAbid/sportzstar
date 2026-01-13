import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/close_keyboard.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/post_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';
import 'package:sportzstar/widgets/input_widget.dart';
import 'package:video_player/video_player.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _mediaFile;
  String _postType = ''; // "image" or "video"
  File? _selectedImage;
  File? _selectedVideo;
  VideoPlayerController? _videoController;

  bool _isLoading = false;

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      alertNotification(
        context: context,
        message: 'Please enter a valid comment.',
        messageType: AlertMessageType.error,
      );
      return;
    }

    _formKey.currentState?.save();
    closeKeyboard(context: context);

    setState(() => _isLoading = true);

    try {
      final response = await Provider.of<PostProvider>(
        context,
        listen: false,
      ).createPost(
        formData:
            _formData..addAll({
              'post_type': _postType.isEmpty ? 'text' : _postType,
              'created_at': DateTime.now().toString(),
            }),
        file: _mediaFile,
        // postType: _postType.isEmpty ? 'text' : _postType,
      );

      print('Post added: $response');

      if (response.statusCode == 201) {
        alertNotification(
          context: context,
          message: 'Post Saved',
          messageType: AlertMessageType.success,
        );
        pushNamedAndRemoveUntilNavigate(
          pageName: bottomNavigationBarRoute,
          context: context,
        );
      } else {
        alertNotification(
          context: context,
          message: 'Something wrong. Try again later.',
          messageType: AlertMessageType.error,
        );
      }
    } catch (e) {
      alertNotification(
        context: context,
        message: 'Something went wrong.\nTry again later.',
        messageType: AlertMessageType.error,
      );
      print('Error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    // Navigator.pop(context); // Optional: only if from modal

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      _videoController?.dispose();
      _videoController = null;

      setState(() {
        _mediaFile = imageFile;
        _postType = 'video'; // ✅ this is correct
        _selectedImage = imageFile;
        _selectedVideo = null;
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);

      _videoController?.dispose();
      _videoController = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });

      setState(() {
        _mediaFile = videoFile;
        _postType = 'video'; // ✅ this is correct
        _selectedVideo = videoFile;
        _selectedImage = null;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      resizeToAvoidBottomInset: true,
      isLoading: _isLoading,
      appBar: AppBar(
        title: const Text("Create Post", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  20, // 👈 keyboard space adjust
              top: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TextFormField(
                //   keyboardType: TextInputType.text,
                //   onSaved: (value) => handleSave('title', value ?? ''),
                //   decoration: const InputDecoration(hintText: 'Title'),
                // ),
                // const SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: _textController,
                  maxLines: 4,
                  onSaved: (value) {
                    handleSave('title', '');
                    handleSave('post_description', value ?? '');
                  },
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Image Preview
                if (_selectedImage != null)
                  SizedBox(
                    height: 400,
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),

                // Video Preview
                if (_selectedVideo != null &&
                    _videoController != null &&
                    _videoController!.value.isInitialized)
                  SizedBox(
                    height: 400,
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _MediaButton(icon: Icons.image, onTap: _pickImage),
                    const SizedBox(width: 8),
                    _MediaButton(icon: Icons.videocam, onTap: _pickVideo),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            // bottom: MediaQuery.of(context).viewInsets.bottom + 50, // 👈 keyboard ke hisaab se adjust
            top: 12,
          ),
          child: SizedBox(
            width: double.infinity, // Full width
            height: 50, // Fixed height for responsiveness
            child: ElevatedButton.icon(
              onPressed: handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.facebookColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // Rounded corners
                ),
              ),
              icon: const Icon(Icons.publish, color: Colors.white),
              label: const Text(
                "Post",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MediaButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(115, 53, 53, 53),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onTap,
      ),
    );
  }
}


// class CreatePostScreen extends StatefulWidget {
//   const CreatePostScreen({super.key});

//   @override
//   State<CreatePostScreen> createState() => _CreatePostScreenState();
// }

// class _CreatePostScreenState extends State<CreatePostScreen> {
//    List<dynamic> posts = [];
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, String> _formData = {};
//   bool _isLoading = false;
//   int totalStories = 0;
//   File? selectedFile;
//   String? mediaType;
//   bool isImage(String url) {
//     return url.endsWith('.jpg') ||
//         url.endsWith('.jpeg') ||
//         url.endsWith('.png') ||
//         url.endsWith('.gif');
//   }

//   File? _mediaFile;
//   String _postType = ''; // "image" or "video"

//   bool isLocal(String path) {
//     return !path.startsWith('http');
//   }


//   String handleSave(String type, String value) {
//     return _formData[type] = value;
//   }

//   Future<void> handleSubmit() async {
//     setState(() {
//       _isLoading = true;
//     });
//     if (_formKey.currentState?.validate() ?? false) {
//       _formKey.currentState?.save();
//       closeKeyboard(context: context);
//         print('This is form data ===>>> $_formData');
//       try {
//         final response = await Provider.of<PostProvider>(
//           context,
//           listen: false,
//         ).createPost(
//           formData:
//               _formData..addAll({
//                 'post_type': 'video', //_postType,
//                 // 'user_id': userId.toString(),
//                 'created_at': DateTime.now().toString(),
//               }),
//           file: _mediaFile,
//           postType: _postType, // either "image" or "video"
//         );
//         print('story added successfully------------>>>$response');
//       } catch (e) {
//         alertNotification(
//           context: context,
//           message: 'Something went wrong, try again later.',
//           messageType: AlertMessageType.error,
//         );
//         print('Error saving posts  e:------ $e');
//       }
//     } else {
//       alertNotification(
//         context: context,
//         message: 'Please enter a valid comment.',
//         messageType: AlertMessageType.error,
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//   }
//   final TextEditingController _textController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();

//   File? _selectedImage;
//   File? _selectedVideo;
//   VideoPlayerController? _videoController;

// Future<void> _pickImage() async {
//   // Navigator.pop(context); // Close the modal or bottom sheet

//   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     File imageFile = File(pickedFile.path);

//     setState(() {
//       _mediaFile = imageFile;
//       _postType = 'image';
//       _selectedImage = imageFile;
//       _selectedVideo = null;
//       _videoController?.dispose();
//       _videoController = null;
//     });
//   }
// }


// Future<void> _pickVideo() async {
//   final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     File videoFile = File(pickedFile.path);

//     _videoController?.dispose();

//     _videoController = VideoPlayerController.file(videoFile)
//       ..initialize().then((_) {
//         setState(() {});
//         _videoController?.play();
//       });

//     setState(() {
//       _mediaFile = videoFile;
//       _postType = 'video';
//       _selectedVideo = videoFile;
//       _selectedImage = null;
//     });
//   }
// }

//   @override
//   void dispose() {
  
//     _textController.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MainLayoutWidget(
//       isLoading: _isLoading,
//       appBar: AppBar(
//         title: const Text("Add Post", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                                 keyboardType: TextInputType.multiline,
//                                 maxLines: null,
//                                 minLines: 1,
//                                 onSaved: (value) {
//                                   handleSave('title', value!);
//                                 },
//                                 style: const TextStyle(color: Colors.black),
//                                 decoration: InputDecoration(
//                                   hintText: 'Title',
                                
//                                 ),
//                               ),
//                  TextFormField(
//                   onSaved: (newValue) => handleSave('post_description', newValue!),
//                   controller: _textController,
//                   maxLines: 4,
//                   decoration: const InputDecoration(
//                     hintText: "What's on your mind?",
//                     border: OutlineInputBorder(),
//                   ),
                  
          
//               ),
              
//               const SizedBox(height: 16),
          
//               // Image Preview
//               if (_selectedImage != null)
//                 SizedBox(
//                   height: 400,
//                   child: Image.file(_selectedImage!, fit: BoxFit.cover),
//                 ),
          
//               // Video Preview
//               if (_selectedVideo != null &&
//                   _videoController != null &&
//                   _videoController!.value.isInitialized)
//                 SizedBox(
//                   height: 400,
//                   child: AspectRatio(
//                     aspectRatio: _videoController!.value.aspectRatio,
//                     child: VideoPlayer(_videoController!),
//                   ),
//                 ),
          
//               const SizedBox(height: 20),
          
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(115, 53, 53, 53),
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                     ),
//                     child: IconButton(
//                       onPressed: _pickImage,
//                       icon: Icon(Icons.image, color: Colors.white, size: 28),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(115, 53, 53, 53),
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                     ),
//                     child: IconButton(
//                       onPressed: _pickVideo,
//                       icon: Icon(Icons.videocam, color: Colors.white, size: 28),
//                     ),
//                   ),
                 
//                 ],
//               ),
          
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//         color: Colors.transparent,
//         child: ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.all(12),
//             backgroundColor: Palette.facebookColor,
//           ),
//           onPressed: handleSubmit,
//           icon: const Icon(Icons.publish, color: Colors.white, size: 18),
//           label: const Text(
//             "Post",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//         ),
//       ),
//     );
//   }
// }
