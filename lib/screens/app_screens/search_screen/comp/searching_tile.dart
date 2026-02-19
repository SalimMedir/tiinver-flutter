import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/providers/profile/profile_provider.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_widget.dart';
import '../../../../widgets/image_loader_widget.dart';

class SearchingTile extends StatelessWidget {
  SearchingTile({
    super.key,
    required this.name,
    required this.userName,
    required this.buttonText,
    required this.buttonAction,
    required this.imageUrl,
    required this.isLoading
  });

  final String name;
  final String userName;
  final String imageUrl;
  final String buttonText;
  final VoidCallback buttonAction;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 60,
              width: 60,
              child: ImageLoaderWidget(imageUrl: imageUrl),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 55.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget1(
                  text: name,
                  fontSize: 16.dp,
                  fontWeight: FontWeight.w500,
                  isTextCenter: false,
                  overFlow: TextOverflow.ellipsis,
                  textColor: textColor,
                  maxLines: 1,
                ),
                TextWidget1(
                  text: userName,
                  fontSize: 11.dp,
                  fontWeight: FontWeight.w300,
                  isTextCenter: false,
                  textColor: textColor,
                  maxLines: 1,
                  overFlow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          isLoading
              ? CircularProgressIndicator()
              : SubmitButton(
            height: 3.h,
            width: 20.w,
            textSize: 10.dp,
            radius: 5,
            title: buttonText,
            press: buttonAction,
          ),
        ],
      ),
    );
  }
}
