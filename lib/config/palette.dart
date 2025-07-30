import 'package:flutter/material.dart';

class Palette {
  static Color basicColor = const Color.fromARGB(255, 35, 42, 86);
  static Color basicDark = const Color.fromARGB(255, 18, 21, 43);
  static Color basicgray = const Color.fromARGB(255, 224, 224, 224);
  static Color darkgray = const Color.fromARGB(255, 190, 190, 190);
  static Color basicgreen = const Color.fromARGB(255, 109, 185, 112);
  static Color darkgreen = const Color.fromRGBO(27, 104, 52, 1);

  // static Color subtextColor = const Color.fromRGBO(115, 115, 115, 1);
  static Color basicSecondaryColor = const Color.fromARGB(255, 15, 15, 15);

  static MaterialColor primaryColor = const MaterialColor(
    0xffF6FAF9,
    <int, Color>{
      50: Color.fromRGBO(246, 250, 249, 0.1), // 10%
      100: Color.fromRGBO(246, 250, 249, 0.2), // 20%
      200: Color.fromRGBO(246, 250, 249, 0.3), // 30%
      300: Color.fromRGBO(246, 250, 249, 0.4), // 40%
      400: Color.fromRGBO(246, 250, 249, 0.5), // 50%
      500: Color.fromRGBO(246, 250, 249, 0.6), // 60%
      600: Color.fromRGBO(246, 250, 249, 0.7), // 70%
      700: Color.fromRGBO(246, 250, 249, 0.8), // 80%
      800: Color.fromRGBO(246, 250, 249, 0.9), // 90%
      900: Color.fromRGBO(246, 250, 249, 1), // 100%
    },
  );

  static MaterialColor grayColor = const MaterialColor(0xffF5F5F5, <int, Color>{
    50: Color.fromRGBO(245, 245, 245, 0.1), //10%
    100: Color.fromRGBO(245, 245, 245, 0.2), //20%
    200: Color.fromRGBO(245, 245, 245, 0.3), //30%
    300: Color.fromRGBO(245, 245, 245, 0.4), //40%
    400: Color.fromRGBO(245, 245, 245, 0.5), //50%
    500: Color.fromRGBO(245, 245, 245, 0.6), //60%
    600: Color.fromRGBO(245, 245, 245, 0.7), //70%
    700: Color.fromRGBO(245, 245, 245, 0.8), //80%
    800: Color.fromRGBO(245, 245, 245, 0.9), //90%
    900: Color.fromRGBO(245, 245, 245, 1), //100%
  });
  static const facebookColor = Color.fromRGBO(28, 72, 159, 1);
  static const orangeColor = Color.fromRGBO(255, 144, 0, 1);
  static const bodyColor = Colors.white;
  static const textHeadingColor = Color.fromRGBO(48, 48, 48, 1);
  static const greyTextColor = Color.fromRGBO(115, 115, 115, 1);
  static const textColor = Color.fromRGBO(110, 128, 176, 1);
  static const lightGreenColor = Color.fromRGBO(212, 247, 234, 1);
  static const lightGreyColor = Color.fromRGBO(232, 232, 232, 0.34);
  static const lightGreyTextColor = Color.fromRGBO(150, 150, 150, 1);

  static const primaryGradient = LinearGradient(
    colors: [
      Color.fromRGBO(75, 91, 195, 0.996),
      Color.fromARGB(255, 28, 26, 49),
    ],
  );
  static const lightGreenGradient = LinearGradient(
    colors: [Color.fromRGBO(241, 255, 41, 1), Color.fromRGBO(205, 251, 68, 1)],
  );

  static const secondaryGradient = LinearGradient(
    colors: [Color.fromRGBO(143, 139, 16, 1), Color.fromRGBO(145, 179, 58, 1)],
  );
}
