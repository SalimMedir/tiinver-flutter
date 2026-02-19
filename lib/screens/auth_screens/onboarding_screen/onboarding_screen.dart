import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

import '../../../constants/images_path.dart';
import '../../../providers/onboard/onboard_provider.dart';
import '../signin_screen/sign_in_screen.dart';
import 'comp/navigate_button.dart';

class OnboardingScreen extends StatelessWidget {

  OnboardingScreen({super.key});

  final List<String> images = [
    ImagesPath.onboard1,
    ImagesPath.onboard2,
    ImagesPath.onboard3,
    ImagesPath.onboard4
  ];

  @override
  Widget build(BuildContext context) {
    var onBoardP = Provider.of<OnboardProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        leadingWidth: 50,
        leading: Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: GestureDetector(
              onTap: (){
                onBoardP.previousPage();
              },
              child: NavigateButton(icon: CupertinoIcons.back, height: 30, width: 30, iconSize: 6.w,)),
        ),
        actions: [
          GestureDetector(
              onTap: (){
                onBoardP.nextPage();
              },
              child: NavigateButton(icon: CupertinoIcons.forward, height: 35, width: 35, iconSize: 6.w,)),
          SizedBox(width: 15,),
        ],
      ),
      body: Consumer<OnboardProvider>(builder: (context,value,child){
        return Column(
            children: [
              SizedBox(
                height: 70.h,
                child: PageView.builder(
                    controller: value.pageController,
                    itemCount: 4,
                    onPageChanged: (int index){
                      value.setPage(index);
                    },
                    itemBuilder: (_,i){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(images[i],height: 50.w,),
                          SizedBox(height: 20,),
                          SizedBox(
                              width: 80.w,
                              child: TextWidget1(text: value.titleText[i], fontSize: 18.dp, fontWeight: FontWeight.w600,
                                  isTextCenter: true, textColor: themeColor,maxLines: 10,)),
                          SizedBox(height: 10,),
                          SizedBox(
                              width: 80.w,
                              child: TextWidget1(text: value.subtitleText[i], fontSize: 14.dp, fontWeight: FontWeight.w400,
                                  isTextCenter: true, textColor: textColor,maxLines: 10,)),
                        ],
                      );
                    }),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20,),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    List.generate(images.length,
                            (index) =>value.buildDot(index)
                    )
                ),
              )
            ],
        );
      }),
      floatingActionButton: GestureDetector(
        onTap: (){
          debugPrint("Tap");
          Get.off(()=> SignInScreen());
        },
        child: SizedBox(
          height: 50,
          width: 50,
          child: Center(
              child: TextWidget1(text: "Skip", fontSize: 16.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor)),
        ),
      ),
    );
  }
}
