import 'package:flutter/material.dart';

OutlineInputBorder formFieldBorderStyle({
  required BuildContext context,
  bool? isError,
  bool? isFocusState,
}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      width: isFocusState == true ? 1.5 : 1,
      color: isError == true
          ? Theme.of(context).colorScheme.error
          : const Color.fromRGBO(240, 240, 240, 1),
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(16),
    ),
  );
}
