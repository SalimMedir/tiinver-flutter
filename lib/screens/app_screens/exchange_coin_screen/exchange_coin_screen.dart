import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/screens/app_screens/recharge_coin_screen/recharge_coin_screen.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../widgets/header.dart';
import '../wallet_screen/comp/grid_container.dart';

class ExchangeCoinScreen extends StatelessWidget {
  const ExchangeCoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("0 Coins",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Expanded(
            child: ListView(
              children: [
                GridContainer(
                  image: ImagesPath.rechargeImage,
                  buttonText: "Recharge",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RechargeCoinScreen(),));
                  },
                ),
                SizedBox(height: 40,),
                GridContainer(
                  image: ImagesPath.withDrawImage,
                  buttonText: "With Draw",
                  onTap: (){},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
