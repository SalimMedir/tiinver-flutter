import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    this.image = "images/person_icon.png",
    this.title = "",
    this.onTap,
  });
  final String image;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: onTap,
        title: TextWidget1(
            text: title, fontSize: 16.dp,
            fontWeight: FontWeight.w600,
            isTextCenter: false,
            textColor: textColor),
        trailing: Container(
          height: 25,
          width: 25,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: themeColor,
            shape: BoxShape.circle
          ),
          child: Center(child: Icon(Icons.arrow_forward_ios_rounded,color: bgColor,size: 15,)),
        ),
        leading: Container(
          padding: EdgeInsets.all(10),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: themeColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Image.asset(image,color: bgColor,),
        ),
      ),
    );
  }
}
