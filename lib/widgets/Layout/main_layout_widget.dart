import 'package:flutter/material.dart';

import '../../helper/close_keyboard.dart';
import '../Loader/loading_widget.dart';

class MainLayoutWidget extends StatelessWidget {
  const MainLayoutWidget({
    super.key,
    this.body,
    this.drawer,
    this.appBar,
    this.bottomNavigationBar,
    required this.isLoading,
    this.bottomNavigationColor,
  });
  final Widget? body;
  final Widget? drawer;
  final bool isLoading;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color? bottomNavigationColor;

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        appBar: appBar,
        drawer: drawer,
        body: GestureDetector(
          onTap: () => closeKeyboard(context: context),
          child: body,
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
