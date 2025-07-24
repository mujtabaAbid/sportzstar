import 'package:flutter/material.dart';
import 'package:sportzstar/chats/chat_list_screen.dart';
import 'package:sportzstar/explore/add_event_screen.dart' show AddEventScreen;
import 'package:sportzstar/explore/tabbar_screen.dart';
import 'package:sportzstar/screens/authScreens/otp_verify_screen.dart';
import 'package:sportzstar/screens/authScreens/verify_email_screen.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/screens/postScreens/post_detail_screen.dart';
import 'package:sportzstar/started_screen.dart';

import '../screens/userScreens/edit_profile_screen.dart';
import '../screens/userScreens/settings_screen.dart';
import '../screens/userScreens/user_profile_screen.dart';
import '../screens/authScreens/forget_password_screen.dart';
import '../screens/generalScreens/about_us.dart';
import '../screens/generalScreens/feedback_screen.dart';
import '../screens/home_screen.dart';


import '../screens/authScreens/login_screen.dart';
import '../screens/authScreens/reset_password_screen.dart';
import '../screens/authScreens/signup_screen.dart';
import '../screens/generalScreens/contact_us.dart';
import '../screens/generalScreens/privacy_policy.dart';
import '../screens/generalScreens/terms_and_conditions_screen.dart';
import '../screens/notificationScreens/notifications_screen.dart';

import '../screens/splash_screen.dart';
import 'routing_constrants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreeenRoute:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case homeScreenRoute:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case bottomNavigationBarRoute:
      return MaterialPageRoute(builder: (_) => BottomNavigationBarScreen());

    // authScreens
    case forgetPasswordScreenRoute:
      return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
    case loginScreenRoute:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case otpScreenRoute:
      return MaterialPageRoute(
        builder: (_) => const OTPScreen(),
        settings: RouteSettings(arguments: settings.arguments),
      );
    case resetPasswordScreenRoute:
      return MaterialPageRoute(
        builder: (_) => const ResetPasswordScreen(),
        settings: RouteSettings(arguments: settings.arguments),
      );
    case signupScreenRoute:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());
    case verifyEmailScreenRoute:
      return MaterialPageRoute(
        builder: (_) => const VerifyEmailScreen(),
        settings: RouteSettings(arguments: settings.arguments),
      );


    // generalScreens
    case aboutUsScreenRoute:
      return MaterialPageRoute(builder: (_) => const AboutUs());
    case contactUsScreenRoute:
      return MaterialPageRoute(builder: (_) => const ContactUs());
    case feedbackScreenRoute:
      return MaterialPageRoute(builder: (_) => const FeedbackScreen());
    case privacyPolicyRoute:
      return MaterialPageRoute(builder: (_) => const PrivacyPolicy());
    case termAndConditionsScreenRoute:
      return MaterialPageRoute(
        builder: (_) => const TermsAndConditionsScreen(),
      );

   

    //notifications
    case notificationScreenRoute:
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());

    //postScreens
    // case postDetailScreenRoute:
    //   return MaterialPageRoute(builder: (_) => const PostDetailScreen());
    

    //userScreens
    case editProfileScreenRoute:
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());
    case userProfileScreenRoute:
      return MaterialPageRoute(builder: (_) => const UserProfileScreen());
    case settingsScreenRoute:
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    case startedScreenRoute:
      return MaterialPageRoute(builder: (_) => const StartedScreen());
    case chatListScreenRoute:
      return MaterialPageRoute(builder: (_) => const ChatListScreen());
    case eventScreenRoute:
      return MaterialPageRoute(builder: (_) => const EventScreen());
    case addEventScreenRoute:
      return MaterialPageRoute(builder: (_) => const AddEventScreen());
    // case confirmEmailScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (_) => const ConfirmEmailScreen(),
    //       settings: RouteSettings(arguments: settings.arguments));

    // case reviewScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (_) => const ReviewScreen(),
    //   );

    //-----------------------------------------------------------------------
    //-----------------------------------------------------------------------
    // ----------------------Page Arguments Routes---------------------------
    // ----------------------Page Arguments Routes---------------------------
    // ----------------------Page Arguments Routes---------------------------
    // ----------------------Page Arguments Routes---------------------------
    // ----------------------Page Arguments Routes---------------------------
    //-----------------------------------------------------------------------
    //-----------------------------------------------------------------------
    //-----------------------------------------------------------------------
    //-----------------------------------------------------------------------

    // case changePasswordScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (_) => const ChangePasswordScreen(),
    //       settings: RouteSettings(arguments: settings.arguments));

    // case messageScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (_) => const MessageScreen(),
    //       settings: RouteSettings(arguments: settings.arguments));
    // case secondUserDisplayMultipleImagesScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (_) => const SeondUserDisplayMultipleImages(),
    //       settings: RouteSettings(arguments: settings.arguments));

    default:
      return MaterialPageRoute(builder: (context) => HomeScreen());
  }
}
