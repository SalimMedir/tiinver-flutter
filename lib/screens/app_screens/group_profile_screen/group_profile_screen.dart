import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/widgets/header.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

import '../../../constants/images_path.dart';

class GroupProfileScreen extends StatefulWidget {
  const GroupProfileScreen({super.key});

  @override
  State<GroupProfileScreen> createState() => _GroupProfileScreenState();
}

class _GroupProfileScreenState extends State<GroupProfileScreen> {

  bool isCommentTrue = true;

  @override
  Widget build(BuildContext context) {
    double defaultH = 20.0;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("English",
          isCenterTitle: true,
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isIconShow: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: defaultH,),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: themeColor,
                            width: 4
                        )
                    ),
                    child: CircleAvatar(
                      radius: 10.h,
                      backgroundColor: lightGreyColor,
                      backgroundImage: AssetImage(ImagesPath.profileImage),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: themeColor,
                      shape: BoxShape.circle
                    ),
                    child: Image.asset(ImagesPath.cameraIcon,color: bgColor,),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextWidget1(text: "Live Coments", fontSize: 16.dp,
                            fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                        const Spacer(),
                        Switch(
                            value: isCommentTrue,
                            inactiveTrackColor: lightGreyColor,
                            inactiveThumbColor: bgColor,

                            onChanged: (value) {
                              setState(() {
                                isCommentTrue = value;
                              });
                            },)
                      ],
                    ),
                    SizedBox(height: defaultH,),
                    TextWidget1(text: "Link Description group", fontSize: 13.dp,
                        fontWeight: FontWeight.w600, isTextCenter: false, textColor: textColor),
                    SizedBox(height: defaultH,),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle
                          ),
                          child: Icon(CupertinoIcons.link,color: bgColor,),
                        ),
                        SizedBox(width: defaultH,),
                        TextWidget1(text: "Invitation Link", fontSize: 16.dp,
                            fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                      ],
                    ),
                    SizedBox(height: defaultH,),
                    Row(
                      children: [
                        TextWidget1(text: "Participants", fontSize: 24.dp,
                            fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                        Spacer(),
                        SizedBox(
                          width: 7.w,
                          child: Image.asset(ImagesPath.searchingIcon),
                        )
                      ],
                    ),
                    SizedBox(height: defaultH,),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle
                          ),
                          child: Image.asset(ImagesPath.addUserIcon),
                        ),
                        SizedBox(width: defaultH,),
                        TextWidget1(text: "Add Participants", fontSize: 16.dp,
                            fontWeight: FontWeight.w600, isTextCenter: false, textColor: darkGreyColor),
                      ],
                    ),
                    SizedBox(height: defaultH,),
                  ],
                ),
              ),
              SizedBox(
                width: 100.w,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 3.5.h,
                          backgroundImage: AssetImage(ImagesPath.profileImage),
                        ),
                        title: TextWidget1(text: "Alexandra", fontSize: 16.dp,
                            fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                        subtitle: TextWidget1(text: "Alex@73456", fontSize: 12.dp,
                            fontWeight: FontWeight.w600, isTextCenter: false, textColor: darkGreyColor),
                        trailing: index == 0 ? SubmitButton(
                          width: 25.w,
                            height: 5.h,
                            bdColor: bgColor,
                            textC: themeColor,
                            textSize: 16.dp,
                            title: "Admin",
                            press: (){}
                        ):
                        SizedBox(),
                      ),
                    );
                  },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
