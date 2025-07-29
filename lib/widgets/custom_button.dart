import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final Color? color;
  final double? textsize;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.text,
    this.color,
    this.textsize,
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
          backgroundColor: Colors.blueAccent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            // gradient: Palette.primaryGradient,
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
