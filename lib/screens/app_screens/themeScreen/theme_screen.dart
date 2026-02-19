import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';

import '../../../constants/images_path.dart';
import '../../../widgets/header.dart';
import '../../../widgets/submit_button.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1(
          "Chat",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20),
        child: Column(
          children: [
            SizedBox(height: 100,),
            SubmitButton(
              icon: Image.asset(ImagesPath.themeIcon,height: 30,),
              title: "Theme", press: () {

            },),
          ],
        ),
      ),
    );
  }
}
