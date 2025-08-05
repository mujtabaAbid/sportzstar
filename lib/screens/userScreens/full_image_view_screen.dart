

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
      body: Center(
        child: InteractiveViewer(
          child: Image(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
