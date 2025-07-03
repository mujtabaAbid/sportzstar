import 'package:flutter/material.dart';

Object pushNamedAndRemoveUntilNavigate({
  required String pageName,
  required BuildContext context,
  Object? argument,
}) {
  return Navigator.of(context).pushNamedAndRemoveUntil(
    pageName,
    (route) => false,
    arguments: argument,
  );
}

Object pushNamedNavigate({
  required BuildContext context,
  required String pageName,
  Object? argument,
}) {
  print("Navigating to-----> $pageName with arguments: $argument");
  return Navigator.of(context).pushNamed(pageName, arguments: argument);
}

void popNavigator({required BuildContext context}) {
  return Navigator.pop(context);
}
