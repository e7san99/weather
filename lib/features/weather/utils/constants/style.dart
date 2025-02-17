import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textStyle(double? fontSize) {
return  GoogleFonts.amaranth(
  textStyle: TextStyle(
    color: Colors.white,
    fontSize: fontSize,
  ),
);
}

ShaderMask shadeMask({required Widget widget}) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        colors: [
          Colors.white,
          Colors.white,
          Colors.grey,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
      ).createShader(bounds);
    },
    child: widget,
  );
}

