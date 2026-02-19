import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/widgets/field_widget.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../constants/images_path.dart';

class TiinverAiChat extends StatelessWidget {
  TiinverAiChat({super.key});

  var msgC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("Tiinver AI", [], isIconShow: true,isCenterTitle: true,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: TextWidget1(text: "Hello, how can i help you?", fontSize: 20.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor))
        ],
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 0),
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 100.w,
                child: InputField(
                    inputController: msgC,
                  hintText: "Ask your question",
                  suffixIcon: GestureDetector(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                        padding: EdgeInsets.all(20),
                        height: 8.h,
                        child: Image.asset(ImagesPath.sendIcon)),
                  ),
                  bdRadius: 0,
                ))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
