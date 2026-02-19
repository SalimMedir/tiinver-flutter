import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/widgets/image_loader_widget.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_widget.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
    required this.name,
    required this.userName,
    required this.image,
  });

  final String userName;
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 60
      ),
      width: 100.w,
      decoration: BoxDecoration(
        color: lightGreyColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: themeColor,
                    width: 4
                )
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                height: 150,
                width: 150,
                child:  ImageLoaderWidget(imageUrl: image),
              ),
            ),
          ),
          TextWidget1(text: name, fontSize: 24.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
          TextWidget1(text: userName, fontSize: 10.dp, fontWeight: FontWeight.w400, isTextCenter: false, textColor: darkGreyColor),
        ],
      ),
    );
  }
}
