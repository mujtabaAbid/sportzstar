import 'package:flutter/material.dart';
import 'package:sportzstar/screens/testing.dart';

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
    this.floatingActionButton,
    this.noDefaultBackground,
  });
  final Widget? body;
  final Widget? drawer;
  final bool isLoading;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color? bottomNavigationColor;
  final Widget? floatingActionButton;
  final bool? noDefaultBackground;

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: isLoading,
      child: Stack(
        children: [
          if (noDefaultBackground != true) Testing(),
          Scaffold(
            floatingActionButton: floatingActionButton,
            appBar: appBar,
            drawer: drawer,
            body: GestureDetector(
              onTap: () => closeKeyboard(context: context),
              child: body,
            ),
            bottomNavigationBar: bottomNavigationBar,
          ),
        ],
      ),
    );
  }
}
