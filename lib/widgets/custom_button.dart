import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor, // optional
    this.textColor,       // optional
    this.borderColor,
    this.isLoading = false,// optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9; // 90% width
    final Color effectiveTextColor = textColor ?? Colors.white;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      width: buttonWidth,
      height: 45,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: borderColor ?? Colors.yellowAccent, // border optional
              width: borderColor != null ? 1 : 0, // only show if given
            ),
          ),
          elevation: 2, // optional shadow
        ),
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
            : Text(
          text,
          style: TextStyle(color: effectiveTextColor),
        ),
      ),
    );
  }
}

