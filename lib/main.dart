import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/provider/event_provider.dart';
import 'package:sportzstar/provider/friends_provider.dart';
import 'package:sportzstar/provider/home_provider.dart';
import 'package:sportzstar/provider/other_provider.dart';
import 'package:sportzstar/provider/post_provider.dart';
import 'package:sportzstar/provider/stories_provider.dart';
import 'package:sportzstar/provider/user_provider.dart';
import 'package:sportzstar/started_screen.dart';

import '../config/palette.dart';
import '../provider/main_provider.dart';
import '../screens/splash_screen.dart';

import 'helper/form_field_border_style.dart';
import 'routing/router.dart' as router;
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]).then((_) {
  //   runApp(const MyApp());
  // });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      // for bottom bar color
      systemNavigationBarColor: Color.fromARGB(
        255,
        247,
        247,
        247,
      ), // light background
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => FriendsProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => OtherProvider()),
        ChangeNotifierProvider(create: (context) => StoriesProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: Consumer<MainProvider>(
        builder:
            (_, auth, __) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SportzStar',
              theme: ThemeData(
                primarySwatch: Palette.primaryColor,

                scaffoldBackgroundColor: Colors.white,
                // const Color.fromARGB(
                //   255,
                //   243,
                //   243,
                //   243,
                // ),
                fontFamily: 'Poppins',

                // appBarTheme: const AppBarTheme(
                //   systemOverlayStyle: SystemUiOverlayStyle(
                //     statusBarColor: Color.fromARGB(255, 249, 249, 249),
                //     statusBarIconBrightness: Brightness.dark,
                //     statusBarBrightness: Brightness.light,
                //     systemNavigationBarColor: Color.fromARGB(
                //       255,
                //       249,
                //       249,
                //       249,
                //     ), // ✅ ADDED
                //     systemNavigationBarIconBrightness:
                //         Brightness.dark, // ✅ UPDATED to dark
                //   ),
                //   backgroundColor: Color.fromARGB(198, 242, 241, 241),
                // ),
                textTheme: const TextTheme(
                  displayLarge: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 72,
                    color: Palette.textHeadingColor,
                    height: 1,
                  ),
                  displayMedium: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  displaySmall: TextStyle(fontSize: 14, color: Colors.white),
                  headlineLarge: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  headlineMedium: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: Palette.bodyColor,
                  ),
                  headlineSmall: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Palette.bodyColor,
                  ),
                  bodyLarge: TextStyle(color: Palette.bodyColor),
                  bodyMedium: TextStyle(
                    color: Color.fromRGBO(133, 133, 133, 1),
                    fontSize: 12,
                  ),
                ),
                elevatedButtonTheme: const ElevatedButtonThemeData(
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  border: formFieldBorderStyle(context: context),
                  enabledBorder: formFieldBorderStyle(context: context),
                  focusedBorder: formFieldBorderStyle(
                    context: context,
                    isFocusState: true,
                  ),
                  errorBorder: formFieldBorderStyle(
                    context: context,
                    isError: true,
                  ),
                  focusedErrorBorder: formFieldBorderStyle(
                    context: context,
                    isError: true,
                    isFocusState: true,
                  ),
                  labelStyle: const TextStyle(fontSize: 14),
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                  alignLabelWithHint: true,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  showUnselectedLabels: true,
                  showSelectedLabels: true,
                  unselectedIconTheme: const IconThemeData(size: 22),
                  unselectedItemColor: const Color.fromARGB(
                    255,
                    0,
                    0,
                    0,
                  ).withOpacity(.5),
                  selectedItemColor: Colors.white,
                  selectedIconTheme: const IconThemeData(
                    color: Colors.white,
                    size: 22,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  selectedLabelStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              // initialRoute: splashScreeenRoute,
              home: const StartedScreen(),
              onGenerateRoute: router.generateRoute,
              onUnknownRoute:
                  (settings) =>
                      MaterialPageRoute(builder: (context) => HomeScreen()),
            ),
      ),
    );
  }
}
