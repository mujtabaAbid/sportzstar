import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:video_player/video_player.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  File? _selectedVideo;
  VideoPlayerController? _videoController;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedVideo = null;
        _videoController?.dispose();
        _videoController = null;
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(File(pickedFile.path))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });

      setState(() {
        _selectedVideo = File(pickedFile.path);
        _selectedImage = null;
      });
    }
  }

  void _postContent() {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedImage == null && _selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add text, image or video")),
      );
      return;
    }

    // Simulate post upload
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post uploaded successfully!")),
    );

    setState(() {
      _textController.clear();
      _selectedImage = null;
      _selectedVideo = null;
      _videoController?.dispose();
      _videoController = null;
    });
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
      isLoading: false,
      appBar: AppBar(
        title: const Text("Add Post", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _textController,
              maxLines: 4,
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

            // Post Button above icons

            // Icon Row (centered)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(115, 53, 53, 53),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image, color: Colors.white, size: 28),
                  ),
                ),
                SizedBox(width: 8),
                //   children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(115, 53, 53, 53),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: IconButton(
                    onPressed: _pickVideo,
                    icon: Icon(Icons.videocam, color: Colors.white, size: 28),
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.image, color: Colors.green, size: 34),
                //   onPressed: _pickImage,
                //   tooltip: 'Pick Image',
                // ),
                // IconButton(
                //   icon: const Icon(Icons.videocam, color: Colors.red, size: 34),
                //   onPressed: _pickVideo,
                //   tooltip: 'Pick Video',
                // ),
              ],
            ),

            // ElevatedButton.icon(

            //   style:  ElevatedButton.styleFrom(
            //     padding: EdgeInsets.all(12),
            //             backgroundColor: Palette.facebookColor,
            //           ),
            //   onPressed: _postContent,
            //   icon: const Icon(Icons.publish, color: Colors.white, size: 18,),
            //   label: const Text("Post", style: TextStyle(color: Colors.white, fontSize: 18),),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        color: Colors.transparent,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            backgroundColor: Palette.facebookColor,
          ),
          onPressed: _postContent,
          icon: const Icon(Icons.publish, color: Colors.white, size: 18),
          label: const Text(
            "Post",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
