import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/palette.dart';
import '../../helper/basic_enum.dart';

Future<void> alertNotification({
  required BuildContext context,
  required String message,
  Curve? curve,
  required AlertMessageType messageType,
  Color backgroundColor = Colors.grey,
  int seconds = 5,
  mobileSnackBarPosition = MobileSnackBarPosition.bottom,
}) async {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  return AnimatedSnackBar(
    animationCurve: Curves.decelerate,
    builder: (context) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 2,
            color: Colors.black12,
          )
        ],
        color: AlertMessageType.error == messageType
            // ? Theme.of(context).colorScheme.error || Colors.red
            ? Colors.red
            : AlertMessageType.success == messageType
                ? Colors.green.shade400
                : AlertMessageType.warning == messageType
                    ? Palette.orangeColor
                    : AlertMessageType.info == messageType
                        ? Colors.blue
                        : backgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            AlertMessageType.error == messageType
                ? FontAwesomeIcons.circleXmark
                : AlertMessageType.success == messageType
                    ? FontAwesomeIcons.circleCheck
                    : AlertMessageType.warning == messageType
                        ? FontAwesomeIcons.triangleExclamation
                        : AlertMessageType.info == messageType
                            ? FontAwesomeIcons.circleInfo
                            : FontAwesomeIcons.circleCheck,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 08),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    ),
    mobileSnackBarPosition: mobileSnackBarPosition,
    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
    duration: Duration(seconds: seconds),
    snackBarStrategy: const ColumnSnackBarStrategy(gap: 0),
  ).show(context);
}
