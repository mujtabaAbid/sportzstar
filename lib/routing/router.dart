import 'package:flutter/material.dart';
import 'package:sportzstar/chats/chat_list_screen.dart';
import 'package:sportzstar/explore/event_/tabbar_screen.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/started_screen.dart';
import '../screens/orderScreens/order_confirmation_screen.dart';
import '../screens/orderScreens/order_details_screen.dart';
import '../screens/orderScreens/order_review_screen.dart';
import '../screens/orderScreens/orders_history_screen.dart';
import '../screens/paymentMethodScreens/payment_gatway_screren.dart';
import '../screens/paymentMethodScreens/payment_method_screen.dart';
import '../screens/promotionScreens/promotions_screen.dart';
import '../screens/riderScreens/rider_details_screen.dart';
import '../screens/riderScreens/rider_tracking_screen.dart';
import '../screens/userScreens/edit_profile_screen.dart';
import '../screens/userScreens/settings_screen.dart';
import '../screens/userScreens/user_profile_screen.dart';
import '../screens/authScreens/forget_password_screen.dart';
import '../screens/checkoutScreens/checkout_screen.dart';
import '../screens/generalScreens/about_us.dart';
import '../screens/generalScreens/feedback_screen.dart';
import '../screens/home_screen.dart';
import '../screens/menuScreens/category_screen.dart';
import '../screens/menuScreens/item_details_screen.dart';
import '../screens/menuScreens/item_review_screen.dart';
import '../screens/menuScreens/menu_screen.dart';

import '../screens/authScreens/login_screen.dart';
import '../screens/authScreens/reset_password_screen.dart';
import '../screens/authScreens/signup_screen.dart';
import '../screens/generalScreens/contact_us.dart';
import '../screens/generalScreens/privacy_policy.dart';
import '../screens/generalScreens/terms_and_conditions_screen.dart';
import '../screens/notificationScreens/notifications_screen.dart';
import '../screens/orderScreens/cart_screen.dart';
import '../screens/splash_screen.dart';
import 'routing_constrants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreeenRoute:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case homeScreenRoute:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
      case bottomNavigationBarRoute:
      return MaterialPageRoute(builder: (_) =>  BottomNavigationBarScreen());

    // authScreens
    case forgetPasswordScreenRoute:
      return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
    case loginScreenRoute:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case resetPasswordScreenRoute:
      return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
    case signupScreenRoute:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());

    // checkoutScreens
    case checkoutScreenRoute:
      return MaterialPageRoute(builder: (_) => const CheckoutScreen());

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

    // menuScreens
    case categoryScreenRoute:
      return MaterialPageRoute(builder: (_) => const CategoryScreen());
    case itemDetailsScreenRoute:
      return MaterialPageRoute(builder: (_) => const ItemDetailsScreen());
    case itemReviewScreenRoute:
      return MaterialPageRoute(builder: (_) => const ItemReviewScreen());
    case menuScreenRoute:
      return MaterialPageRoute(builder: (_) => const MenuScreen());

    //notifications
    case notificationScreenRoute:
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());

    //orderScreens
    case cartScreenRoute:
      return MaterialPageRoute(builder: (_) => const CartScreen());
    case orderConfirmationScreenRoute:
      return MaterialPageRoute(builder: (_) => const OrderConfirmationScreen());
    case orderDetailsScreenRoute:
      return MaterialPageRoute(builder: (_) => const OrderDetailsScreen());
    case orderReviewScreenRoute:
      return MaterialPageRoute(builder: (_) => const OrderReviewScreen());
    case orderhistoryScreenRoute:
      return MaterialPageRoute(builder: (_) => const OrdersHistoryScreen());

    //paymentMethod
    case paymentGatewayScreenRoute:
      return MaterialPageRoute(builder: (_) => const PaymentGatwayScreren());
    case paymentMethodScreenRoute:
      return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());

    // promotionsScreen
    case promotionsScreenRoute:
      return MaterialPageRoute(builder: (_) => const PromotionsScreen());

    //riderScreens
    case riderDetailsScreenRoute:
      return MaterialPageRoute(builder: (_) => const RiderDetailsScreen());
    case riderTrackingScreenRoute:
      return MaterialPageRoute(builder: (_) => const RiderTrackingScreen());

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
    // case otpOptionScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (_) => const OtpOptionScreen(),
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
