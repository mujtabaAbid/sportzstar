

import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String? imageUrl;

  const FullScreenImageViewer({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final imageProvider = (imageUrl != null && imageUrl!.isNotEmpty)
        ? NetworkImage(imageUrl!)
        : const AssetImage('assets/profile/dummy.png') as ImageProvider;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: InteractiveViewer(
        panEnabled: true, // drag karne ke liye
        minScale: 1.0,
        maxScale: 5.0, // zyada zoom ke liye adjust kar sakte ho
        child: SizedBox.expand(
          child: Image(
            image: imageProvider,
            fit: BoxFit.contain, // ya BoxFit.cover use karo agar full fill chahiye
          ),
        ),
      ),
    );
  }
}

