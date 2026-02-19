import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/widgets/header.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

import '../../../constants/images_path.dart';

class EarnCoinScreen extends StatelessWidget {
  const EarnCoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isIconShow: true),
      body: Center(
        child: Column(
          children: [
            TextWidget1(text: "Earn Coins Game", fontSize: 24.dp, fontWeight: FontWeight.w700,
                isTextCenter: false, textColor: textColor),
            TextWidget1(text: "Ads not Loaded", fontSize: 14.dp, fontWeight: FontWeight.w500,
                isTextCenter: false, textColor: textColor),
            SizedBox(height: 20,),
            ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(ImagesPath.earnImage,width: 80.w,)),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget1(text: "Seconds Remaining", fontSize: 14.dp, fontWeight: FontWeight.w500,
                    isTextCenter: false, textColor: themeColor),
                SizedBox(width: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: TextWidget1(text: "0", fontSize: 16.dp, fontWeight: FontWeight.w500,
                      isTextCenter: false, textColor: bgColor),
                )
              ],
            ),
            SizedBox(height: 20,),
            SubmitButton(
              radius: 50,
              width: 80.w,
                title: "Retry",
                press: (){}
            )
            
          ],
        ),
      ),
    );
  }
}
