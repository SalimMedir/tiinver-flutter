import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

class EditProfileTile extends StatelessWidget {
  const EditProfileTile({
    super.key,
    this.text,
    this.image,
    this.hint = "",
    this.controller,
  });

  final String? text;
  final String? image;
  final String? hint;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(image!,height: 3.h,),
            SizedBox(width: 10,),
            TextWidget1(text: text!, fontSize: 16.dp, fontWeight: FontWeight.w500,
                isTextCenter: false, textColor: themeColor),
          ],
        ),
        TextFormField(
          controller: controller,
          decoration:  InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            fillColor: bgColor,
            filled: true,
            alignLabelWithHint: true,
            border: const UnderlineInputBorder(
              borderSide:  BorderSide(
                color: themeColor,
                width: 1.5,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide:  BorderSide(
                color: themeColor,
                width: 1.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 20,)
      ],
    );
  }
}
