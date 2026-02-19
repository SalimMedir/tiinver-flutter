import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/providers/dashboard/dashboard_provider.dart';
import 'package:tiinver_project/providers/profile/profile_provider.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';

import '../chat_home_screen/chat_home_screen.dart';
import '../dash_board_screen/dash_board_screen.dart';
import '../notification_screen/notification_screen.dart';
import '../profile_screen/profile_screen.dart';

class BottomNavbarScreen extends StatefulWidget {
  const BottomNavbarScreen({super.key});

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {

  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    Provider.of<SignInProvider>(context,listen: false).getApiKey();
    Provider.of<ProfileProvider>(context,listen: false).getUserProfile(context);
    //var signInP = Provider.of<SignInProvider>(context, listen: false);


  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dashBoardP = Provider.of<DashboardProvider>(context,listen: false);
    //debugPrint(signP.userId.toString());
    return Scaffold(
      backgroundColor: themeColor,
      body: Consumer<DashboardProvider>(builder: (context, value, child) {
        return IndexedStack(
          index: value.currentIndex,
          children: <Widget>[
            DashBoardScreen(),
            ChatListScreen(),
            NotificationScreen(),
            ProfileScreen(),
          ],
        );
      },),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: dashBoardP.currentIndex,
        selectedItemColor: bgColor,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: bgColor,
        backgroundColor: themeColor,
        showSelectedLabels: true,
        onTap: (index) {
          dashBoardP.setIndex(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded,),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,),
            label: "My Profile",
          ),
        ],
      ),
    );
  }
}
