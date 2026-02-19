// class ChatProvider extends ChangeNotifier {
//
//   List<ChatRoomModel> _chatList = [];
//   bool _isLoading = false;
//   String? _errorMessage;
//   List<ChatRoomModel> _chatRooms = [];
//
//   List<ChatRoomModel> get chatList => _chatList;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   List<ChatRoomModel> get chatRooms => _chatRooms;
//
//   Future<void> fetchChatRooms() async {
//     try {
//       var chatRoomsData = await FirebaseFirestore.instance.collection('chatRooms').get();
//       _chatRooms = chatRoomsData.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         return ChatRoomModel.fromMap(data);
//       }).toList();
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching chat rooms: $e");
//       _errorMessage = e.toString();
//       notifyListeners(); // Notify listeners even in case of error
//     }
//   }
//
//
//   Future<void> fetchChatList(String userId) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('chats')
//           .where('participants', arrayContains: userId)
//           .get();
//
//       _chatList = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         return ChatRoomModel.fromMap(data);
//       }).toList();
//     } catch (e) {
//       _errorMessage = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Stream<QuerySnapshot> getMessages(String chatId) {
//     return FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp')
//         .snapshots();
//   }
//
//   Future<void> sendMessage(String chatId, String senderId, String text) async {
//     var timestamp = Timestamp.now();
//     await FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
//       'senderId': senderId,
//       'text': text,
//       'timestamp': timestamp,
//     });
//   }
//
//   // Set user to inactive after a period of inactivity
//   void setUserInactive(String userId) {
//     Future.delayed(Duration(minutes: 1), () async {
//       await _firestore.collection('users').doc(userId).update({
//         'isActive': false,
//       });
//     });
//   }
//
//   Stream<QuerySnapshot> getUserChats(String userId) {
//     return _firestore.collection('users').doc(userId).collection('chats').orderBy('createdAt', descending: true).snapshots();
//   }
//
//   Future<DocumentSnapshot> getUserDetails(String userId) {
//     return FirebaseFirestore.instance.collection('users').doc(userId).get();
//   }
//
//   Future<String> createChat(String userId1, String userId2) async {
//     String chatId = userId1.hashCode <= userId2.hashCode ? '$userId1-$userId2' : '$userId2-$userId1';
//
//     DocumentSnapshot chatDoc = await _firestore.collection('chats').doc(chatId).get();
//
//     if (!chatDoc.exists) {
//       await _firestore.collection('chats').doc(chatId).set({
//         'userIds': [userId1, userId2],
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       await _firestore.collection('users').doc(userId1).collection('chats').doc(chatId).set({
//         'chatId': chatId,
//         'userId': userId2,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       await _firestore.collection('users').doc(userId2).collection('chats').doc(chatId).set({
//         'chatId': chatId,
//         'userId': userId1,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     }
//
//     return chatId;
//   }
//
// // Methods for sending images, audio, etc. will be similar
// }

// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// import '../../models/chatModel/chat_model.dart';
// import '../connectedUsers/connected_users_provider.dart';
//
// class ChatProvider with ChangeNotifier {
//   Database? _database;
//   List<Chat> _chats = [];
//   List<Message> _messages = [];
//
//   List<Chat> get chats => _chats;
//   List<Message> get messages => _messages;
//
//   Future<void> initializeDatabase() async {
//     final databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'chat_app.db');
//
//     _database = await openDatabase(path, version: 1, onCreate: _createDb);
//     await _loadInitialData();
//   }
//
//   Future<void> _createDb(Database db, int newVersion) async {
//     await db.execute('''
//       CREATE TABLE users (
//         id INTEGER PRIMARY KEY,
//         firstname TEXT,
//         lastname TEXT,
//         username TEXT,
//         profile TEXT
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE chats (
//         id TEXT PRIMARY KEY,
//         userId INTEGER,
//         connectedUserId INTEGER,
//         FOREIGN KEY (userId) REFERENCES users (id),
//         FOREIGN KEY (connectedUserId) REFERENCES users (id)
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE messages (
//         id TEXT PRIMARY KEY,
//         chatId TEXT,
//         senderId INTEGER,
//         content TEXT,
//         type TEXT,
//         timestamp TEXT,
//         FOREIGN KEY (chatId) REFERENCES chats (id),
//         FOREIGN KEY (senderId) REFERENCES users (id)
//       )
//     ''');
//   }
//
//   Future<void> _loadInitialData() async {
//     final chatList = await _database?.query('chats');
//     final messageList = await _database?.query('messages');
//
//     _chats = chatList?.map((chat) => Chat.fromMap(chat)).toList() ?? [];
//     _messages = messageList?.map((message) => Message.fromMap(message)).toList() ?? [];
//
//     notifyListeners();
//   }
//
//   Future<String> createChat(String userId, String connectedUserId) async {
//     final existingChat = _chats.firstWhere(
//           (chat) => (chat.userId == userId && chat.connectedUserId == connectedUserId) ||
//           (chat.userId == connectedUserId && chat.connectedUserId == userId),
//       orElse: () => Chat.empty(),
//     );
//
//     if (existingChat.id != 'empty') {
//       return existingChat.id;
//     }
//
//     final chatId = DateTime.now().toString();
//     final newChat = Chat(id: chatId, userId: userId, connectedUserId: connectedUserId);
//
//     // Save to local database
//     await _database?.insert('chats', newChat.toMap());
//
//     _chats.add(newChat);
//     notifyListeners();
//
//     return chatId;
//   }
//
//   Future<void> loadChats() async {
//     final List<Map<String, dynamic>> chatMaps = await _database!.query('chats');
//     _chats = chatMaps.map((map) => Chat.fromMap(map)).toList();
//     notifyListeners();
//   }
//
//   Future<void> addChat(Chat chat) async {
//     await _database!.insert('chats', chat.toMap());
//     _chats.add(chat);
//     notifyListeners();
//   }
//
//   Future<void> addMessage(Message message) async {
//     await _database?.insert('messages', message.toMap());
//     _messages.add(message);
//     notifyListeners();
//   }
// }

// class ChatProvider with ChangeNotifier {
//
//   Database? _database;
//   List<Chat> _chats = [];
//   List<Message> _messages = [];
//   ConnectedUsersProvider? _connectedUsersProvider;
//
//   List<Chat> get chats => _chats;
//   List<Message> get messages => _messages;
//
//   // Future<void> loadChats() async {
//   //   // Load chats from the database
//   //   final List<Map<String, dynamic>> chatMaps = await _database!.query('chats');
//   //   _chats = chatMaps.map((map) => Chat.fromMap(map)).toList();
//   //   notifyListeners();
//   // }
//
//   void setConnectedUsersProvider(ConnectedUsersProvider provider) {
//     _connectedUsersProvider = provider;
//   }
//
//   Future<void> initializeDatabase() async {
//     final databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'chat_app.db');
//
//     _database = await openDatabase(path, version: 1, onCreate: _createDb);
//     await _loadInitialData();
//   }
//
//   Future<void> _loadInitialData() async {
//     await loadChats();
//     await loadMessages();
//   }
//
//   Future<void> loadChats() async {
//     if (_database != null) {
//       final List<Map<String, dynamic>> chatMaps = await _database!.query('chats');
//       _chats = chatMaps.map((map) => Chat.fromMap(map)).toList();
//       notifyListeners();
//     }
//   }
//
//   Future<void> loadMessages() async {
//     if (_database != null) {
//       final List<Map<String, dynamic>> messageMaps = await _database!.query('messages');
//       _messages = messageMaps.map((map) => Message.fromMap(map)).toList();
//       notifyListeners();
//     }
//   }
//
//   Future<void> _createDb(Database db, int newVersion) async {
//     await db.execute('''
//       CREATE TABLE users (
//         id INTEGER PRIMARY KEY,
//         firstname TEXT,
//         lastname TEXT,
//         username TEXT,
//         profile TEXT
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE chats (
//         id TEXT PRIMARY KEY,
//         userId INTEGER,
//         connectedUserId INTEGER,
//         FOREIGN KEY (userId) REFERENCES users (id),
//         FOREIGN KEY (connectedUserId) REFERENCES users (id)
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE messages (
//         id TEXT PRIMARY KEY,
//         chatId TEXT,
//         senderId INTEGER,
//         content TEXT,
//         type TEXT,
//         timestamp TEXT,
//         FOREIGN KEY (chatId) REFERENCES chats (id),
//         FOREIGN KEY (senderId) REFERENCES users (id)
//       )
//     ''');
//   }
//
//   // Future<void> _loadInitialData() async {
//   //   final chatList = await _database?.query('chats');
//   //   final messageList = await _database?.query('messages');
//   //
//   //   _chats = chatList!.map((chat) => Chat.fromMap(chat)).toList();
//   //   _messages = messageList!.map((message) => Message.fromMap(message)).toList();
//   //
//   //   notifyListeners();
//   // }
//
//   Future<String> createChat(String userId, String connectedUserId) async {
//     final existingChat = _chats.firstWhere(
//           (chat) =>
//       (chat.userId == userId && chat.connectedUserId == connectedUserId) ||
//           (chat.userId == connectedUserId && chat.connectedUserId == userId),
//       orElse: () => Chat.empty(),
//     );
//
//     if (existingChat.id != '') {
//       print('Existing chat found: ${existingChat.id}');
//       return existingChat.id;
//     }
//
//     final chatId = DateTime.now().toIso8601String();
//     final newChat = Chat(id: chatId, userId: userId, connectedUserId: connectedUserId);
//
//     await _database?.insert('chats', newChat.toMap());
//
//     _chats.add(newChat);
//     notifyListeners();
//
//     print('New chat created: $chatId');
//     return chatId;
//   }
//
//   Future<void> addMessage(Message message) async {
//     await _database?.insert('messages', message.toMap());
//     _messages.add(message);
//     notifyListeners();
//   }
// }
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';

import '../../DatabaseHelper/database_helper.dart';
import '../../SocketIO/demo_chat_screen.dart';
import '../../gloabal_key.dart';
import '../../models/connectedUsers/connected_users_model.dart';
import '../message/message_provider.dart';
import '../signIn/sign_in_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class ChatProvider extends ChangeNotifier {

  bool _isRecording = false;
  String? _voiceMessagePath;
  TextEditingController _messageController = TextEditingController();


  TextEditingController get messageController => _messageController;
  bool get isRecording => _isRecording;
  String? get voiceMessagePath => _voiceMessagePath;

  SignInProvider signInProvider = SignInProvider();
  MessageProvider messageProvider = MessageProvider();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _chatRooms = [];
  List<Map<String, dynamic>> get chatRooms => _chatRooms;

  late IO.Socket _socket;

  static SignInProvider? get user => GlobalProviderAccess.signProvider;

  ChatProvider(){
    _initializeSocket();
  }

  Future<void> startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.mp3';
    _voiceMessagePath = path;
    _isRecording = true;
    notifyListeners();
    RecordMp3.instance.start(path, (type) {
      print('Recording status: $type');
    });
  }

  Future<void> stopRecording() async {
    final success = await RecordMp3.instance.stop();
    _isRecording = false;
    notifyListeners();
    print('Recording stopped: $success');
    if (success) {
      _voiceMessagePath = null;
      notifyListeners();
      // Handle the recorded file, e.g., save to database
    }
  }

  String getConversationID(String id) {
    return user!.userId.hashCode <= id.hashCode ? '${user!.userId}_$id' : '${id}_${user!.userId}';
  }

  Future<void> loadChatRooms() async {
    _chatRooms = await _dbHelper.getChatRooms();
    notifyListeners();
  }

  Future<void> addChatRoom(Map<String, dynamic> chatRoom) async {
    await _dbHelper.insertChatRoom(chatRoom);
    _chatRooms.add(chatRoom);
    notifyListeners();
  }

  Future<void> addMessage(Map<String, dynamic> message) async {

    // await _dbHelper.insertMessage(message);
  }

  Future<List<Map<String, dynamic>>> getMessages(String chatRoomId) async {
    return await _dbHelper.getMessages(chatRoomId);
  }

  void _initializeSocket() {
    _socket = IO.io('https://api.tiinver.com:2020', IO.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .build());

    _socket.onConnect((_) {
      print('Connected to socket server');
    });

    _socket.on('message', (data) {
      _dbHelper.insertMessage(data);
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }


  Future<void> sendMessage(
      String chatRoomId, String senderId, String voiceMessagePath,
      String message, receiverId,receiverName
      ) async {
    _socket.emit('message', message);
    Random random = Random();
    try {
      await _dbHelper.saveMessage(
          chatRoomId,
          senderId,
          message,
          voiceMessagePath,
          receiverId,
          receiverName
      );
      int msgId = random.nextInt(1000000000);
      messageProvider.sendPrivateMsg(
        msg: message,
        from: GlobalProviderAccess.profileProvider!.userModel.firstname.toString(),
        to: receiverName,
        msgSize: "1244",
        chatRoomId: chatRoomId,
        msgId: msgId.toString(),
        receiverId: receiverId,
      );

    } catch (e) {
      print("Error sending message: $e");
    }
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




// Future<void> checkOrCreateChat(BuildContext context, ConnectedUser user) async {
//   final chatProvider = Provider.of<ChatProvider>(context, listen: false);
//   final signInP = Provider.of<SignInProvider>(context, listen: false);
//
//   // Check if chat already exists
//   final chatId = await chatProvider.getChatId(signInP.userId.toString(), user.userId.toString());
//   if (chatId != null) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChatScreen(
//           chatRoomId: '',
//           otherUserId: '',
//           // chatId: chatId,
//           // senderId: signInP.userId.toString(),
//           // targetId: user.userId.toString(),
//           // firstName: user.firstname.toString(),
//           // userName: user.username.toString(),
//           // profile: user.profile!,
//         ),
//       ),
//     );
//   } else {
//     // Create a new chat
//     final newChatId = await chatProvider.createChat(signInP.userId.toString(), user.userId.toString());
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChatScreen(
//           chatRoomId: '',
//           otherUserId: '',
//
//           // chatId: newChatId,
//           // senderId: signInP.userId.toString(),
//           // targetId: user.userId.toString(),
//           // firstName: user.firstname.toString(),
//           // userName: user.username.toString(),
//           // profile: user.profile!,
//         ),
//       ),
//     );
//   }
// }


// Future<String> createChat(String senderId, String receiverId) async {
//   final db = await database;
//
//   if (db == null) throw Exception("Database is not initialized");
//
//   final chatId = UniqueKey().toString();
//
//   await db.insert(
//     'chats',
//     {
//       'id': chatId,
//       'senderId': senderId,
//       'receiverId': receiverId,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//
//   notifyListeners();
//   return chatId;
// }
