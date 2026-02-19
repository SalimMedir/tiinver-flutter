import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tiinver_project/providers/message/message_provider.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';

import '../models/msgModel/msg_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Random random = Random();

  static Database? _database;
  // final msgId = UniqueKey().toString();
  SignInProvider signInProvider = SignInProvider();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'tiinver_chat.db');

    return await openDatabase(
      path,
      version: 2, // Ensure this is incremented
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE chats ('
              'id TEXT PRIMARY KEY, '
              'senderId TEXT, '
              'receiverId TEXT, '
              'receiverProfileImage TEXT, '
              'receiverFirstName TEXT, '
              'receiverUsername TEXT'
              ')',
        );
        await db.execute(
          'CREATE TABLE chat_list ('
              'id TEXT PRIMARY KEY, '
              'receiverId TEXT, '
              'receiverProfileImage TEXT, '
              'receiverFirstName TEXT, '
              'receiverUsername TEXT, '
              'last_message TEXT, ' // Corrected column definition
              'lastMessageTime INTEGER' // Corrected column definition
              ')',
        );
        await db.execute(
          'CREATE TABLE messages ('
              'id TEXT PRIMARY KEY, '
              'chat_room_id TEXT, '
              'sender_id TEXT, '
              'message TEXT, '
              'voiceMessagePath TEXT, '
              'timestamp INTEGER'
              ')',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add new columns if they don't exist
          await db.execute(
            'ALTER TABLE messages ADD COLUMN voiceMessagePath TEXT',
          );
          await db.execute(
            'ALTER TABLE chats ADD COLUMN receiverProfileImage TEXT',
          );
          await db.execute(
            'ALTER TABLE chats ADD COLUMN receiverFirstName TEXT',
          );
          await db.execute(
            'ALTER TABLE chats ADD COLUMN receiverUsername TEXT',
          );
        }
      },
    );
  }


  Future<int> insertChatRoom(Map<String, dynamic> chatRoom) async {
    final db = await database;
    return await db.insert('chats', chatRoom, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getChatRooms() async {
    final db = await database;
    return await db.query('chat_list');
  }

  // Future<int> insertMessage(Map<String, dynamic> message) async {
  //   final db = await database;
  //   return await db.insert('messages', message, conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  Future<void> updateLastMessage(String chatRoomId, String lastMessage) async {
    final db = await database;
    db.update(
      'chat_list',
      {'last_message': lastMessage},
      where: 'id = ?',
      whereArgs: [chatRoomId],
    );
  }

  Future<int> insertMessage(Map<String, dynamic> message) async {
    final db = await _database;
    return await db!.insert('messages', message, conflictAlgorithm: ConflictAlgorithm.replace);


    // Insert or replace the message
    // await db!.insert(
    //   'messages',
    //   message.toMap(),
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );

    // Update the last message in chat_list
    // await db.rawUpdate(
    //   'UPDATE chat_list SET last_message = ? WHERE id = ?',
    //   [message.message, message.chatRoomId],
    // );
  }

  Future<List<Map<String, dynamic>>> getMessages(String chatRoomId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('messages');
    List<Message> messages = List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
    return await db.query('messages', where: 'chat_room_id = ?', whereArgs: [chatRoomId]);
  }

  Future<String?> getChatId(String senderId, String receiverId) async {
    final db = await database;
    final result = await db.query(
      'chats',
      where: '(senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)',
      whereArgs: [senderId, receiverId, receiverId, senderId],
      limit: 1,
    );

    return result.isNotEmpty ? result.first['id'] as String? : null;
  }

  Future<void> saveMessage(
      String chatRoomId, String senderId,
      String message, String voiceMessagePath,String receiverId,
      String receiverName
      ) async {
    final db = await database;
    int msgId = random.nextInt(1000000000);
    db.insert(
      'messages',
      {
        'id': msgId.toString(),
        'chat_room_id': chatRoomId,
        'sender_id': senderId,
        'message': message,
        'voiceMessagePath': voiceMessagePath,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.update(
      'chat_list',
      {'lastMessageTime': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [chatRoomId],
    );


  }

  Future<String> createChat(String senderId, String receiverId,
      String profileImage, String firstName, String username) async {
    final db = await database;

    final chatId = "${senderId}_${receiverId}";

    await db.insert(
      'chats',
      {
        'id': chatId,
        'senderId': senderId,
        'receiverId': receiverId,
        'receiverProfileImage': profileImage,
        'receiverFirstName': firstName,
        'receiverUsername': username,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'chat_list',
      {
        'id': chatId,
        'receiverId': receiverId,
        'receiverProfileImage': profileImage,
        'receiverFirstName': firstName,
        'receiverUsername': username,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return chatId;
  }
}
