import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/text_widget.dart';

import '../../../../constants/colors.dart';

class ProfileEditorButton extends StatelessWidget {
  const ProfileEditorButton({
    super.key,
    this.image,
    this.text,
    this.boxColor,
    this.onTap,
  });

  final String? image;
  final String? text;
  final Color? boxColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Image.asset(image!,height: 3.h,),
          ),
        ),
        SizedBox(height: 5,),
        TextWidget1(text: text!, fontSize: 10.dp, fontWeight: FontWeight.w400, isTextCenter: false, textColor: textColor)
      ],
    );
  }
}
