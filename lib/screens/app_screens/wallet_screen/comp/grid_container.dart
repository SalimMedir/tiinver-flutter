import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

class GridContainer extends StatelessWidget {
  const GridContainer({
    super.key,
    this.image,
    this.buttonText,
    this.onTap,
  });

  final String? image;
  final String? buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image!,width: 40.w,),
        SizedBox(height: 20,),
        SubmitButton(
          radius: 8,
          width: 25.w,
            height: 4.h,
            textSize: 10.dp,
            title: buttonText,
            press: onTap!
        )
      ],
    );
  }
}
