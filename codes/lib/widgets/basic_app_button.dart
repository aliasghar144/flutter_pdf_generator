import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;
  final String? title;
  final Color? backGroundColor;
  final Widget? icon;
  final BorderSide? borderSide;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? fontSize;
  final double? height;

  const BasicAppButton(
      {this.loading = false,
      this.onPressed,
      this.title,
      this.fontWeight,
      this.borderSide,
      this.icon,
      this.textColor,
      this.fontSize,
      this.backGroundColor,
      this.height,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: loading ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          side: borderSide,
          disabledBackgroundColor: const Color(0xffBFC7D5),
          backgroundColor: borderSide != null ? Colors.transparent : (backGroundColor ?? const Color(0xff4D7771)),
          minimumSize: Size.fromHeight(height ?? 60),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: ui.TextDirection.ltr,
          children: [
            if (icon != null && loading != true) ...[

              Opacity(
                opacity: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0.0,left: 0),
                  child: icon!,
                ),
              ),
            ],
            loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    title ?? 'Continue',
                    textAlign: TextAlign.center,
                    textDirection: ui.TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Lahzeh',
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.w500,
                      color: textColor ?? Colors.white,
                    ),
                  ),
            if (icon != null && loading != true) ...[
              Padding(
                padding: const EdgeInsets.only(left: 2.0,right: 15),
                child: icon!,
              ),
            ],
          ],
        ));
  }
}
