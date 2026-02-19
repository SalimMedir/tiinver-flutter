import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/screens/app_screens/chat_screen/chat_screen.dart';
import 'package:tiinver_project/widgets/image_loader_widget.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_widget.dart';

import '../../../../firebase/chat/firebase_chat.dart';
import '../../../../models/chatModel/chat_model.dart';
import '../../../../models/msgModel/msg_model.dart';
import 'date_util.dart';

class ChatTile extends StatelessWidget {
  ChatTile({super.key,required this.name,required this.chatText,
    required this.lastMsgTime,required this.tapAction,required this.image});

  String name;
  String chatText;
  String lastMsgTime;
  String image;
  VoidCallback tapAction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: tapAction,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: themeColor,
                  width: 1.5
                )
              ),
              child: CircleAvatar(
                radius: 3.5.h,
                backgroundColor: lightGreyColor,
                backgroundImage: AssetImage(image),
              ),
            ),
            SizedBox(width: 10,),
            SizedBox(
              width:55.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget1(text: name, fontSize: 20.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                  TextWidget1(text: chatText, fontSize: 11.dp, fontWeight: FontWeight.w300, isTextCenter: false, textColor: textColor),
                ],
              ),
            ),
            TextWidget1(text: lastMsgTime, fontSize: 8.dp, fontWeight: FontWeight.w400, isTextCenter: false, textColor: textColor),
          ],
        ),
      ),
    );
  }
}

// class ChatUserCard extends StatefulWidget {
//   final ChatUser user;
//
//   const ChatUserCard({super.key, required this.user});
//
//   @override
//   State<ChatUserCard> createState() => _ChatUserCardState();
// }

// class _ChatUserCardState extends State<ChatUserCard> {
//   //last message info (if null --> no message)
//   Message? _message;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0.0,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(0.0))),
//       child: InkWell(
//           borderRadius: const BorderRadius.all(Radius.circular(15)),
//           onTap: () {
//             // Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (_) => ChatScreen(
//             //           targetId: '',
//             //           firstName: '',
//             //           profile: '',
//             //           userName: '', senderId: '', chatId: '',)));
//             // user: widget.user
//           },
//           child: StreamBuilder(
//             stream: FirebaseChat.getLastMessage(widget.user),
//             builder: (context, snapshot) {
//               final data = snapshot.data?.docs;
//               final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
//               if (list.isNotEmpty) _message = list[0];
//               return ListTile(
//                 tileColor: bgColor,
//                 leading: InkWell(
//                   onTap: () {
//                     // showDialog(
//                     //     context: context,
//                     //     builder: (_) => ProfileDialog(user: widget.user));
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: CircleAvatar(
//                       radius: 3.h,
//                         child: ImageLoaderWidget(imageUrl: widget.user.profile)),
//                   ),
//                 ),
//                 title: Text(widget.user.firstname, maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: textColor),),
//                 subtitle: Text(
//                   _message != null ? _message!.type == Type.image ? 'image 🖼' :
//                   _message!.type == Type.voice? "voice 🎤" : _message!.message : "Hello",
//                   maxLines: 1,style: TextStyle(
//                     color: textColor
//                 ),),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
//                 trailing: _message == null ? null : _message!.read.isEmpty && _message!.fromUserUid != FirebaseChat.user!.userId ?
//                 const SizedBox(
//                   width: 15,
//                   height: 15,
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius:
//                         BorderRadius.all(Radius.circular(10))),
//                   ),
//                 )
//                     :
//                 Text(
//                   MyDateUtil.getLastMessageTime(
//                       context: context, time: _message!.sent),
//                   style: TextStyle(color: textColor),
//                 ),
//               );
//             },
//           )),
//     );
//   }
// }
