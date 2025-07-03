import 'package:flutter/material.dart';

import './loader.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.bgColor = Colors.transparent,
  });

  final Widget child;
  final bool isLoading;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) LoaderWidget(bgColor: bgColor),
      ],
    );
  }
}
