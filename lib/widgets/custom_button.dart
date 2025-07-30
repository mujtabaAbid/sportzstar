import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final Color? color;
  final Color? background;
  final Gradient? gradient;
  final double? textsize;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.text,
    this.color,
    this.textsize,
    this.width,
    this.height,
    this.background,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 55,
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
            color: background,

            gradient:
                background == null ? gradient ?? Palette.primaryGradient : null,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text ?? '',
              style: TextStyle(
                color: color ?? const Color.fromRGBO(234, 238, 239, 1),
                fontSize: textsize ?? 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
