import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:tiinver_project/screens/app_screens/aboutScreen/privacy_policy_screen.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../widgets/header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key,required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1(
          "About",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              TextWidget1(
                  text: "Tiinver for Android",
                  fontSize: 32.dp,
                  fontWeight: FontWeight.w700,
                  isTextCenter: false,
                  textColor: themeColor),
              SizedBox(height: 20,),
              TextWidget1(
                  text: "Version",
                  fontSize: 16.dp,
                  fontWeight: FontWeight.w500,
                  isTextCenter: false,
                  textColor: textColor),
              TextWidget1(
                  text: version,
                  fontSize: 16.dp,
                  fontWeight: FontWeight.w500,
                  isTextCenter: false,
                  textColor: textColor),
              SizedBox(height: 20,),
              TextWidget1(
                  text: "term of use",
                  fontSize: 16.dp,
                  fontWeight: FontWeight.w500,
                  isTextCenter: false,
                  decorationColor: themeColor,
                  decoration: TextDecoration.underline,
                  textColor: themeColor),
              SizedBox(height: 20,),
              InkWell(
                onTap: () {
                  Get.to(()=>PrivacyPolicyScreen());
                },
                child: TextWidget1(
                    text: "privacy policies",
                    fontSize: 16.dp,
                    fontWeight: FontWeight.w500,
                    isTextCenter: false,
                    decorationColor: themeColor,
                    decoration: TextDecoration.underline,
                    textColor: themeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
