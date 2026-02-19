import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/providers/chat/chat_provider.dart';

import '../DatabaseHelper/database_helper.dart';
import '../constants/colors.dart';
import '../constants/images_path.dart';
import '../constants/text_widget.dart';
import '../models/msgModel/message_model.dart';
import '../providers/chatsocket_provider.dart';
import '../screens/app_screens/chat_screen/chat_screen.dart';
import '../screens/auth_screens/onboarding_screen/comp/navigate_button.dart';
import '../widgets/image_loader_widget.dart';

class DemoChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String userId;
  final String otherUserId;
  final String otherUserFirstName;
  final String otherUserProfile;
  final String otherUserUserName;

  DemoChatScreen({
    super.key,
    required this.chatRoomId,
    required this.userId,
    required this.otherUserId,
    required this.otherUserFirstName,
    required this.otherUserProfile,
    required this.otherUserUserName,

  });

  var messageController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
          backgroundColor: bgColor,
          surfaceTintColor: bgColor,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: Get.back,
              child: NavigateButton(
                icon: CupertinoIcons.back,
                height: 30,
                width: 30,
                iconSize: 6.w,),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: ImageLoaderWidget(imageUrl: otherUserProfile),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30.w,
                    child: TextWidget1(
                        text: otherUserFirstName, fontSize: 16,
                        fontWeight: FontWeight.bold, isTextCenter: false, textColor: textColor),
                  ),
                  SizedBox(
                    width: 30.w,
                    child: TextWidget1(
                        text: otherUserUserName, fontSize: 12,
                        fontWeight: FontWeight.w500, isTextCenter: false, textColor: textColor),
                  ),
                ],
              ),
              Image.asset(ImagesPath.editIcon,height: 30,),
              Image.asset(ImagesPath.phoneIcon,height: 30,),
              Image.asset(ImagesPath.menuIcon,height: 30,),
            ],
          )
      ),
      body: Consumer<SocketProvider>(
        builder: (context, socketProvider, child) {
          return Column(
            children: [
              Expanded(
                child: Consumer<SocketProvider>(
                  builder: (context, chatProvider, child) {
                    return FutureBuilder<List<MessageModel>>(
                      future: chatProvider.getMessages(chatRoomId),
                      builder: (context, AsyncSnapshot<List<MessageModel>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No messages yet.'));
                        }

                        final messages = snapshot.data!;
                        final ScrollController scrollController = ScrollController();

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (scrollController.hasClients) {
                            scrollController.jumpTo(scrollController.position.maxScrollExtent);
                          }
                        });

                        return ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          reverse: false,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMe = message.sender == userId; // Replace with actual user ID
                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: MessageBubble(
                                text: message.message.toString(),
                                timestamp: Timestamp.fromDate(message.stamp!),
                                isSender: isMe,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () async {
                        socketProvider.sendMessage(
                            userId,
                            otherUserId,
                            messageController.text,
                            chatRoomId,
                            otherUserFirstName, "cdsnig"
                        );
                        // await _sendMessage(context,messageController.text.toString());
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.send,
                          color: bgColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _sendMessage(context,msg) async {
    final message = msg;
    final _chatProvider = Provider.of<ChatProvider>(context,listen: false);
    if (message.isNotEmpty) {
      _chatProvider.sendMessage(
          chatRoomId,
          userId.toString(),
          _chatProvider.voiceMessagePath.toString(),
          _chatProvider.messageController.text.toString(),
          otherUserId,
          otherUserFirstName,
      ).whenComplete(() {
        // setState(() async {
        //
        //   // _messageController.clear();
        // });
      },);
      await _dbHelper.updateLastMessage(
        chatRoomId,
        msg,
      );
      // _chatProvider.messageController.clear();
      // Save text message to database and send it
      print('Send message: $message');
      // _messageController.clear();
    }
    else if (_chatProvider.voiceMessagePath != null) {
      _chatProvider.sendMessage(
          chatRoomId,
          userId.toString(),
          _chatProvider.voiceMessagePath.toString(),
          _chatProvider.messageController.text.toString(),
          otherUserId,
          otherUserFirstName,
      ).whenComplete(() {
        // setState(() async {
        //   await _dbHelper.updateLastMessage(
        //     widget.chatRoomId,
        //     _messageController.text.toString(),
        //   );
        //   // _messageController.clear();
        // });
      },);
      await _dbHelper.updateLastMessage(
        chatRoomId,
        _chatProvider.messageController.text.toString(),
      );
      // _chatProvider.messageController.clear();
      // Save voice message to database and send it
      print('Send voice message: ${_chatProvider.voiceMessagePath}');
      // _chatProvider.voiceMessagePath = null; // Clear the path after sending
    }


    _chatProvider.loadChatRooms();
  }

}
