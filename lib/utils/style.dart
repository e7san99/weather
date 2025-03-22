import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color blueColor = Colors.blue;
Color whiteColor = Colors.white;
Color blackColor = Colors.black;


// TextStyle textStyle(BuildContext context, Color color, double? fontSize) {
//   if (context.locale.languageCode == 'ar') {
//     return GoogleFonts.notoKufiArabic(
//       textStyle: TextStyle(color: color, fontSize: 14),
//     );
//   } else {
//     return GoogleFonts.amaranth(
//       textStyle: TextStyle(color: color, fontSize: fontSize),
//     );
//   }
// }


TextStyle textStyle(Color color,double? fontSize) {
return  GoogleFonts.amaranth(
  textStyle: TextStyle(
    color: color,
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

