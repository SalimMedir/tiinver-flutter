import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../widgets/header.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1(
          "Help",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50,),
          TextWidget1(
              text: "FAQS",
              fontSize: 24.dp,
              fontWeight: FontWeight.w700,
              isTextCenter: false,
              textColor: themeColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
            child: ListTile(
              tileColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              title: TextWidget1(
                  text: "If you have any question or feedback email us at:",
                  fontSize: 20.dp,
                  maxLines: 2,
                  fontWeight: FontWeight.w500,
                  isTextCenter: false,
                  textColor: bgColor),
              subtitle: TextWidget1(
                  text: "support@tiinver.com",
                  fontSize: 20.dp,
                  maxLines: 1,
                  decorationColor: textColor,
                  fontWeight: FontWeight.w500,
                  isTextCenter: false,
                  decoration: TextDecoration.underline,
                  textColor: textColor),
            ),
          )
        ],
      ),
    );
  }
}
