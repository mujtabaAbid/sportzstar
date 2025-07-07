


import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? text;

  const CustomButton({
    super.key,
    required this.onPressed,
     this.text ,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: Palette.primaryGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            alignment: Alignment.center,
            child: text
          ),
        ),
      ),
    );
  }
}