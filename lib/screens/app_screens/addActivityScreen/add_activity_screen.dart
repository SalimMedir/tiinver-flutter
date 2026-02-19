import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/providers/graphic/graphic_provider.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/screens/app_screens/bottom_navbar_screen/bottom_navbar_screen.dart';
import 'package:tiinver_project/widgets/field_widget.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

class AddActivityScreen extends StatelessWidget {
  AddActivityScreen({super.key,required this.imageFilePath});
  //
  final postController = TextEditingController();
  File imageFilePath ;

  @override
  Widget build(BuildContext context) {
    var graphicP = Provider.of<GraphicProvider>(context,listen: false);
    var signP = Provider.of<SignInProvider>(context,listen: false);
    signP.getApiKey();
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<GraphicProvider>(builder: (context, value, child) {
                  return value.isLoading ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator())  : SubmitButton(
                    width: 30.w,
                    title: "Post",
                    press: () {
                      value.addActivity(
                          message: postController.text,
                          // imageFilePath.toString()
                          image: File(imageFilePath.path),
                          userId: signP.userId.toString(),
                          apiKey: signP.userApiKey.toString())
                          .whenComplete(() {
                        Get.offAll(()=>BottomNavbarScreen());
                        graphicP.clearData();
                      },);
                    },) ;
                },)
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(
                    width: 70.w,
                    child: InputField(
                      hintText: "Say Something...",
                        inputController: postController,
                      maxLines: 6,
                    )
                ),
                Spacer(),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(imageFilePath,height: 17.5.h,width: 18.w,fit: BoxFit.fill,))
              ],
            )
          ],
        ),
      ),
    );
  }
}
