import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key, this.bgColor = Colors.black, this.height});

  final Color bgColor;
  final String? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          height != null
              ? double.parse(height!)
              : MediaQuery.of(context).size.height + kBottomNavigationBarHeight,
      color: bgColor.withOpacity(.7),
      child: Center(
        child: Image.asset(
          'assets/images/loading.gif',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
        //     CircularProgressIndicator(
        //   color: Colors.white.withOpacity(.8),
        //   strokeWidth: 2.5,
        //   backgroundColor: Theme.of(context).primaryColor,
        // ),
      ),
    );
  }
}
