import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/screens/app_screens/group_chat_screen/comp/toast_msg.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../routes/routes_name.dart';
import '../../../widgets/field_widget.dart';
import '../group_profile_screen/group_profile_screen.dart';

class GroupChatScreen extends StatelessWidget {
  GroupChatScreen({super.key});

  var msgC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("",
        [
          SizedBox(
            width: 82.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupProfileScreen()));
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: themeColor,
                                width: 1.5
                            )
                        ),
                        child: CircleAvatar(
                          radius: 3.7.h,
                          backgroundColor: lightGreyColor,
                          backgroundImage: AssetImage(ImagesPath.profileImage),
                        ),
                      ),
                      SizedBox(width: 10,),
                      SizedBox(
                        width:35.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget1(text: "English", fontSize: 20.dp,
                                fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                            TextWidget1(text: "Alexandra, Jasmine, Alexandra", fontSize: 10.dp,overFlow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400, isTextCenter: false, textColor: textColor,maxLines: 1,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                    height: 8.h,
                    child: Image.asset(ImagesPath.editIcon)),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                    height: 8.h,
                    child: Image.asset(ImagesPath.phoneIcon)),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                    height: 8.h,
                    child: Image.asset(ImagesPath.menuIcon)),
              ],
            ),
          )
        ],
        toolbarHeight: 10.h,
        isIconShow: true,isCenterTitle: true,),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 78.h,
              width: 100.w,
              color: lightGreyColor,
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ToastMsg(text: "6/30/2024",),
                      ToastMsg(text: "Reminder Create Group “English”",),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            color: tileColor,
            padding: EdgeInsets.only(bottom: 0),
            width: 100.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 65.w,
                    child: InputField(
                      inputController: msgC,
                      hintText: "messag...",
                      bdRadius: 0,
                    )),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(RoutesName.graphicScreen);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                          height: 8.h,
                          child: Image.asset(msgC.text.isEmpty ? ImagesPath.editIcon : ImagesPath.voiceIcon)),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        height: 8.h,
                        child: Image.asset(ImagesPath.galleryIcon)),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        height: 8.h,
                        child: Image.asset(ImagesPath.sendIcon)),
                  ],
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}


//Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           ToastMsg(text: "6/30/2024",),
//           ToastMsg(text: "Reminder Create Group “English”",),
//         ],
//       ),
//       floatingActionButton: Container(
//         color: tileColor,
//         padding: EdgeInsets.only(bottom: 0),
//         width: 100.w,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//                 width: 65.w,
//                 child: InputField(
//                   inputController: msgC,
//                   hintText: "messag...",
//                   bdRadius: 0,
//                 )),
//             Row(
//               children: [
//                 Container(
//                     padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                     height: 8.h,
//                     child: Image.asset(msgC.text.isEmpty ? ImagesPath.editIcon : ImagesPath.voiceIcon)),
//                 Container(
//                     padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                     height: 8.h,
//                     child: Image.asset(ImagesPath.galleryIcon)),
//                 Container(
//                     padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                     height: 8.h,
//                     child: Image.asset(ImagesPath.sendIcon)),
//               ],
//             )
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,