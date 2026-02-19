import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../providers/otherUserProfile/other_user_profile_provider.dart';
import '../other_user_profile_screen/comp/dialogue_box.dart';
import 'comp/report_tile.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {

    var otherUserProfileP = Provider.of<OtherUserProfileProvider>(context,listen: false);
    var signInP = Provider.of<SignInProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: bgColor,

      appBar: Header().header1("Report",
          [],
          isCenterTitle: true,
          isIconShow: true),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [

            ReportTile(
              title: "Nudity",
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueBox().customDialogue(
                        context,
                        title: "Report Reminder ?",
                        subTitle: "I am reporting this user for posting content"
                            "related to Nudity",
                        primaryButtonText: "Report",
                        primaryTap: (){
                          otherUserProfileP.reportUser(
                              userId: userId,
                              userName: userName,
                              msg: "I am reporting this user for posting content"
                                  "related to Nudity",
                              userApiKey: signInP.userApiKey.toString())
                              .whenComplete(() {
                            Get.back();
                            Get.snackbar("success", "Reported Successfully");
                              },);

                        }
                    );
                  },);
              },
            ),

            ReportTile(
              title: "Violence",
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueBox().customDialogue(
                        context,
                        title: "Report Reminder ?",
                        subTitle: "I am reporting this user for posting content"
                            "related to Violence",
                        primaryButtonText: "Report",
                        primaryTap: (){
                          otherUserProfileP.reportUser(
                              userId: userId,
                              userName: userName,
                              msg: "I am reporting this user for posting content"
                                  "related to Violence",
                              userApiKey: signInP.userApiKey.toString())
                              .whenComplete(() {
                            Get.back();
                            Get.snackbar("success", "Reported Successfully");
                          },);
                        }
                    );
                  },);
              },
            ),

            ReportTile(
              title: "Harassment",
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueBox().customDialogue(
                        context,
                        title: "Report Reminder ?",
                        subTitle: "I am reporting this user for posting content"
                            "related to Harassment",
                        primaryButtonText: "Report",
                        primaryTap: (){
                          otherUserProfileP.reportUser(
                              userId: userId,
                              userName: userName,
                              msg: "I am reporting this user for posting content"
                                  "related to Harassment",
                              userApiKey: signInP.userApiKey.toString())
                              .whenComplete(() {
                            Get.back();
                            Get.snackbar("success", "Reported Successfully");
                          },);
                        }
                    );
                  },);
              },
            ),

            ReportTile(
              title: "False Information",
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueBox().customDialogue(
                        context,
                        title: "Report Reminder ?",
                        subTitle: "I am reporting this user for posting content"
                            "related to False Information",
                        primaryButtonText: "Report",
                        primaryTap: (){
                          otherUserProfileP.reportUser(
                              userId: userId,
                              userName: userName,
                              msg: "I am reporting this user for posting content"
                                  "related to False Information",
                              userApiKey: signInP.userApiKey.toString())
                              .whenComplete(() {
                            Get.back();
                            Get.snackbar("success", "Reported Successfully");
                          },);
                        }
                    );
                  },);
              },
            ),

            ReportTile(
              title: "Unauthorized Sales",
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueBox().customDialogue(
                        context,
                        title: "Report Reminder ?",
                        subTitle: "I am reporting this user for posting content"
                            "related to Unauthorized_Sales",
                        primaryButtonText: "Report",
                        primaryTap: (){
                          otherUserProfileP.reportUser(
                              userId: userId,
                              userName: userName,
                              msg: "I am reporting this user for posting content"
                                  "related to Unauthorized_Sales",
                              userApiKey: signInP.userApiKey.toString())
                              .whenComplete(() {
                            Get.back();
                            Get.snackbar("success", "Reported Successfully");
                          },);
                        }
                    );
                  },);
              },
            ),

            ReportTile(
              title: "Hate Speech",
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueBox().customDialogue(
                        context,
                        title: "Report Reminder ?",
                        subTitle: "I am reporting this user for posting content"
                            "related to Hate Speech",
                        primaryButtonText: "Report",
                        primaryTap: (){
                          otherUserProfileP.reportUser(
                              userId: userId,
                              userName: userName,
                              msg: "I am reporting this user for posting content"
                                  "related to Hate Speech",
                              userApiKey: signInP.userApiKey.toString())
                              .whenComplete(() {
                            Get.back();
                            Get.snackbar("success", "Reported Successfully");
                          },);
                        }
                    );
                  },);
              },
            ),

            ReportTile(
              title: "Terrorism",
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueBox().customDialogue(
                        context,
                        title: "Report Reminder ?",
                        subTitle: "I am reporting this user for posting content"
                            "related to Terrorism",
                        primaryButtonText: "Report",
                        primaryTap: (){
                          otherUserProfileP.reportUser(
                              userId: userId,
                              userName: userName,
                              msg: "I am reporting this user for posting content"
                                  "related to Terrorism",
                              userApiKey: signInP.userApiKey.toString())
                              .whenComplete(() {
                            Get.back();
                            Get.snackbar("success", "Reported Successfully");
                          },);
                        }
                    );
                  },);
              },
            ),

            ReportTile(
              title: "Under 13 years old",
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueBox().customDialogue(
                        context,
                        title: "Report Reminder ?",
                        subTitle: "I am reporting this user for posting content "
                            "related to Under 13 years old",
                        primaryButtonText: "Report",
                        primaryTap: (){
                          otherUserProfileP.reportUser(
                              userId: userId,
                              userName: userName,
                              msg: "I am reporting this user for posting content "
                                  "related to Under 13 years old",
                              userApiKey: signInP.userApiKey.toString())
                              .whenComplete(() {
                            Get.back();
                            Get.snackbar("success", "Reported Successfully");
                          },);
                        }
                    );
                  },);
              },
            ),

          ],
        ),
      ),
    );
  }
}
