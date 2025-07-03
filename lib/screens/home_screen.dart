import 'package:flutter/material.dart';

import '../widgets/Layout/main_layout_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: false,
      body: Container(
        color: const Color.fromARGB(255, 91, 157, 150),
        child: Center(
          child: Text(
            'Home Screen for SportzStar',
            style: TextStyle(color: Colors.brown),
          ),
        ),
      ),
    );
  }
}
