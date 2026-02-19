import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import '../DatabaseHelper/db_helper.dart';
import '../SocketIO/demo_chat_screen.dart';
import '../models/connectedUsers/connected_users_model.dart';
import '../models/msgModel/message_model.dart';

class SocketProvider with ChangeNotifier {
  late IO.Socket _socket;
  final String _serverUrl = 'https://api.tiinver.com:2020'; // Replace with your server URL
  List<MessageModel> _messages = [];
  final DatabaseHelper2 _dbHelper = DatabaseHelper2();
  List<Map<String, dynamic>> _chatRooms = [];
  List<Map<String, dynamic>> get chatRooms => _chatRooms;

  List<MessageModel> get messages => _messages;

  SocketProvider() {
    _initializeSocket();
  }

  void _initializeSocket() {
    _socket = IO.io(_serverUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .build());

    _socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    _socket.on('message', (data) async {
      try {
        await handleMessage(data);
        log(data.toString());
      } catch (e) {
        log('Error handling message: $e');
      }
    });

    _socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }

  Future<void> loadChatRooms() async {
    _chatRooms = await _dbHelper.getChatRooms();
    notifyListeners();
  }

  Future<void> handleMessage(dynamic data) async {
    try {
      final message = MessageModel.fromJson(data);
      final chatId = await _dbHelper.getChatId(message.sender.toString(), message.receiver.toString());
      if (chatId != null) {
        await _dbHelper.insertMessage(message);
        log("Chat Id Exists");
      } else {
        await _dbHelper.createChat(
          message.sender.toString(),
          message.receiver.toString(),
          message.profile.toString(),
          message.from.toString(),
          message.nikname.toString(),
        );
        log("Chat Id Does Not Exist");
      }
      _messages.add(message); // Update local list
      notifyListeners();
    } catch (e) {
      log('Error processing message: $e');
    }
  }

  void sendMessage(
      String senderId,
      String receiverId,
      String message,
      String conversationId,
      String to,
      String from,
      ) {
    final chatMessage = MessageModel(
      conversationId: conversationId,
      messageId: DateTime.now().toString(),
      to: to,
      from: from,
      sender: senderId,
      receiver: receiverId,
      message: message,
      stamp: DateTime.now(),
    );
    _socket.emit('send_message', chatMessage.toJson());
    _dbHelper.insertMessage(chatMessage);
    _messages.add(chatMessage); // Update local list
    notifyListeners();
  }

  // Future<List<Map<String, dynamic>>> getMessages(String chatRoomId) async {
  //   return await _dbHelper.getMessages(chatRoomId);
  // }

  Future<List<MessageModel>> getMessages(String chatRoomId) async {
    final messages = await _dbHelper.getMessages(chatRoomId);
    return messages.map((e) => MessageModel.fromJson(e)).toList();
  }

  Future<void> checkOrCreateChat(BuildContext context, ConnectedUser user) async {
    final signInP = Provider.of<SignInProvider>(context, listen: false);
    final chatId = await _dbHelper.getChatId(signInP.userId.toString(), user.userId.toString());

    if (chatId != null) {
      Get.to(
        DemoChatScreen(
          chatRoomId: chatId,
          userId: signInP.userId.toString(),
          otherUserId: user.userId.toString(),
          otherUserFirstName: user.firstname.toString(),
          otherUserProfile: user.profile.toString(),
          otherUserUserName: user.username.toString(),
        ),
      );
    } else {
      final newChatId = await _dbHelper.createChat(
        signInP.userId.toString(),
        user.userId.toString(),
        user.profile.toString(),
        user.firstname.toString(),
        user.username.toString(),
      );

      Get.to(
        DemoChatScreen(
          chatRoomId: newChatId,
          userId: signInP.userId.toString(),
          otherUserId: user.userId.toString(),
          otherUserFirstName: user.firstname.toString(),
          otherUserProfile: user.profile.toString(),
          otherUserUserName: user.username.toString(),
        ),
      );
    }
  }
}
