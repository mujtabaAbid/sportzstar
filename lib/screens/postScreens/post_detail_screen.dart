import 'package:flutter/material.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(isLoading: _isLoading);
  }
}
