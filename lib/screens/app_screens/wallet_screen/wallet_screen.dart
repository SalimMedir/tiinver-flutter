import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/screens/app_screens/earn_coin_screen/earn_coin_screen.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../constants/images_path.dart';
import '../../../providers/signIn/sign_in_provider.dart';
import '../buy_coin_screen/buy_coin_screen.dart';
import '../transfer_coin_screen/transfer_coin_screen.dart';
import 'comp/grid_container.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignInProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1(provider.user !=null ? "${provider.user!.coinsAmount.toString()} Coins" : "0 Coins",
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
            child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                GridContainer(
                  image: ImagesPath.earnImage,
                  buttonText: "Earn Coin",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EarnCoinScreen(),));
                  },
                ),
                GridContainer(
                  image: ImagesPath.buyImage,
                  buttonText: "Buy Coin",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BuyCoinScreen(),));
                  },
                ),
                GridContainer(
                  image: ImagesPath.transferImage,
                  buttonText: "Transfer",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TransferCoinScreen(),));
                  },
                ),
                GridContainer(
                  image: ImagesPath.withDrawImage,
                  buttonText: "WithDraw",
                  onTap: (){

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
