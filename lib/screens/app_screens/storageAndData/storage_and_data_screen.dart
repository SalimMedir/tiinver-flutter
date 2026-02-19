import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/screens/app_screens/storageAndData/comp/storage_tile.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../widgets/header.dart';

class StorageAndDataScreen extends StatefulWidget {
  const StorageAndDataScreen({super.key});

  @override
  State<StorageAndDataScreen> createState() => _StorageAndDataScreenState();
}

class _StorageAndDataScreenState extends State<StorageAndDataScreen> {

  bool isMobileDataTrue = true;
  bool isWifiTrue = true;
  bool isRoamingTrue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1(
          "Storage and Data",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            TextWidget1(
                text: "Automatic Media Download",
                fontSize: 14.dp,
                fontWeight: FontWeight.w500,
                isTextCenter: false,
                textColor: textColor),
            SizedBox(height: 15,),
            StorageTile(title: "When using mobile data", trailing: Switch(
              value: isMobileDataTrue,
              inactiveTrackColor: themeColor,
              inactiveThumbColor: bgColor,
              activeColor: bgColor,
              hoverColor: bgColor,

              onChanged: (value) {
                setState(() {
                  isMobileDataTrue = value;
                });
              },)),
            SizedBox(height: 15,),
            StorageTile(title: "When connected on wifi", trailing: Switch(
              value: isWifiTrue,
              inactiveTrackColor: themeColor,
              inactiveThumbColor: bgColor,
              activeColor: bgColor,
              hoverColor: bgColor,

              onChanged: (value) {
                setState(() {
                  isWifiTrue = value;
                });
              },)),
            SizedBox(height: 15,),
            StorageTile(title: "When roaming", trailing: Switch(
              value: isRoamingTrue,
              inactiveTrackColor: themeColor,
              inactiveThumbColor: bgColor,
              activeColor: bgColor,
              hoverColor: bgColor,

              onChanged: (value) {
                setState(() {
                  isRoamingTrue = value;
                });
              },)),
          ],
        ),
      ),
    );
  }
}
