import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleCards extends StatelessWidget {
  final String title;
  const TitleCards({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.amaranth(
              textStyle: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
