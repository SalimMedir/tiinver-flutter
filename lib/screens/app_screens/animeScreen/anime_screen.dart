import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

class AnimeScreen extends StatelessWidget {
  const AnimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget1(
            text: "Frame duration very fast",
            fontSize: 14.dp,
            fontWeight: FontWeight.w500,
            isTextCenter: false,
            textColor: textColor
        ),
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
      ),
    );
  }
}
