import 'package:flutter/material.dart';

void closeKeyboard({required BuildContext context}) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}