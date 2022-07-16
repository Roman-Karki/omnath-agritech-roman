import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutoText extends StatelessWidget {
  final height;
  final width;
  final text;
  final style;
  final showcolor;
  final maxline;
  final centered;

  AutoText({
    this.height,
    this.width,
    this.text,
    this.style,
    this.maxline,
    this.showcolor,
    this.centered,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: showcolor == false ? Colors.transparent : showcolor,
      width: width,
      height: height,
      child: centered == true
          ? Center(
              child: AutoSizeText(
                '$text',
                style: GoogleFonts.poppins(textStyle: style),
                maxLines: maxline,
              ),
            )
          : AutoSizeText(
              '$text',
              style: GoogleFonts.poppins(textStyle: style),
              maxLines: maxline,
            ),
    );
  }
}
