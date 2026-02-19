import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiinver_project/constants/text_widget.dart';

import '../constants/colors.dart';
import '../screens/auth_screens/onboarding_screen/comp/navigate_button.dart';

class Header {

  AppBar header1(
      String title,
      List<Widget> actionsList,
      {required bool isIconShow,
        bool isCenterTitle = false,
        double? toolbarHeight}){
    return AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        centerTitle: isCenterTitle,
        toolbarHeight: toolbarHeight,
        title: TextWidget1(text: title, fontSize: 24.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),
        actions: actionsList,
        leading: Visibility(
          visible: isIconShow,
          child: Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: NavigateButton(
                  icon: CupertinoIcons.back,
                  height: 30,
                  width: 30,
                  iconSize: 6.w,)),
          ),
        )
    );
  }

  AppBar header2(String title,List<Widget> actionsList){
    return AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: TextWidget1(text: title, fontSize: 24.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),
        actions: actionsList,
    );
  }

}

