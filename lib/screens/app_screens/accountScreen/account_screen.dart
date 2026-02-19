import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/providers/profile/profile_provider.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/widgets/header.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

import '../../../constants/images_path.dart';
import '../other_user_profile_screen/comp/dialogue_box.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var signP = Provider.of<SignInProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1(
          "Account",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20),
        child: Column(
          children: [
            SizedBox(height: 100,),
            SubmitButton(title: "Log Out", press: () {
              signP.logout();
            },),
            SizedBox(height: 20,),
            SubmitButton(title: "Delete My Account", press: () {
              showDialog(context: context, builder: (context) {
                return DialogueBox().customDialogue(
                    context,
                    title: 'Delete Account',
                    subTitle: "Are you sure you want to Delete Account?",
                    primaryButtonText: "Delete",
                    primaryTap: (){
                      var signP =  Provider.of<SignInProvider>(context,listen: false);
                      Provider.of<ProfileProvider>(context,listen: false)
                          .deleteAccount(
                          userId: signP.userId.toString(),
                          userApiKey: signP.userApiKey.toString()
                      );
                    });
              },);
            },),
          ],
        ),
      ),
    );
  }
}
