import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/images_path.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

class FollowNotificationTile extends StatelessWidget {
  const FollowNotificationTile({super.key,this.bgColor});

  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: bgColor ?? themeColor.withOpacity(0.3)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle
            ),
          ),
          SizedBox(
            height: 5.h,
            child: Image.asset(ImagesPath.profileImage),
          ),
          Column(
            children: [
              SizedBox(
                width: 55.w,
                child: TextWidget1(text: "Reminder", fontSize: 16.dp,
                    fontWeight: FontWeight.w700, isTextCenter: false,
                    textColor: darkGreyColor),
              ),
              SizedBox(height: 5,),
              SizedBox(
                width: 55.w,
                child: TextWidget1(
                  text: "Started Following you",
                  fontSize: 10.dp, fontWeight: FontWeight.w700, isTextCenter: false,
                  textColor: darkGreyColor, maxLines: 2,overFlow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget1(text: "1 mint ago", fontSize: 8.dp,
                    fontWeight: FontWeight.w500, isTextCenter: false,
                    textColor: darkGreyColor),
                SubmitButton(
                    title: "Following",
                    width: 20.w,
                    height: 4.h,
                    textSize: 10.dp,
                    press: (){}
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
