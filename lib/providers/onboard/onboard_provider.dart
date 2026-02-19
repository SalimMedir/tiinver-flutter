import 'package:flutter/material.dart';
import 'package:tiinver_project/constants/colors.dart';

class OnboardProvider extends ChangeNotifier{

  int currentIndex = 0;

  PageController pageController = PageController();

  List subtitleText = [
    "You can create posts such as photos videos or animation",
    "Private or group chat, through whichyou can send text ,"
        "photo, video oranimation messages, but also via a "
        "shared board where you can write "
        "a message with your finger",
    "It will allow the user to express their emotions through animation",
    "A messaging system that provide an election board where you can share between 2"
        " or more people, by which you can write a message with your finger "
        "on a shared board as message with your finger on a shared board as"
        " if you where in front of class board"
  ];

  List titleText = [
    "Publication",
    "Chat",
    "Animemes",
    "Share Board",
  ];

  AnimatedContainer buildDot(index){
    return AnimatedContainer(
      margin: EdgeInsets.only(right: 5),
      height: 10,
      width: currentIndex == index ? 25 : 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? themeColor : darkGreyColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)
      ), duration: Duration(microseconds: 1000),
    );
  }

  nextPage(){
    if(currentIndex < 3){
      currentIndex++;
      pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      notifyListeners();
    }
  }

  previousPage(){
    if(currentIndex > 0){
      currentIndex--;
      pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      notifyListeners();
    }
  }

  setPage(int index){
    currentIndex = index;
    notifyListeners();
  }


}