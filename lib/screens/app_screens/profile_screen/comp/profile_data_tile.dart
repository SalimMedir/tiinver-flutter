import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

class ProfileDataTile extends StatelessWidget {
  const ProfileDataTile({
    super.key,
    required this.icon,
    this.title,
  });

  final String icon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: ListTile(
        leading: Image.asset(icon,height: 3.h,color: themeColor,),
        title: TextWidget1(text: title!, fontSize: 16.dp, fontWeight: FontWeight.w400,
            isTextCenter: false, textColor: textColor),
      ),
    );
  }
}
