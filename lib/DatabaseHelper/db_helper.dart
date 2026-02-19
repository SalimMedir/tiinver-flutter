import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/msgModel/message_model.dart';
import '../models/msgModel/msg_model.dart';

class DatabaseHelper2 {
  static final DatabaseHelper2 _instance = DatabaseHelper2._internal();
  factory DatabaseHelper2() => _instance;
  DatabaseHelper2._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'chat_database.db');
    return await openDatabase(
      path,
      version: 1, // Ensure this is incremented
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
              'last_message TEXT, '
              'lastMessageTime INTEGER'
              ')',
        );
        await db.execute(
          '''
        CREATE TABLE messages (
          messageId TEXT PRIMARY KEY,
          conversationId TEXT,
          type TEXT,
          "to" TEXT,  -- Escaping reserved keyword
          sender TEXT,
          receiver TEXT,
          "from" TEXT,  -- Escaping reserved keyword
          nikname TEXT,
          message TEXT,
          verb TEXT,
          object TEXT,
          profile TEXT,
          status TEXT,
          stamp INTEGER,
          resource TEXT,
          isQuoted TEXT
        )
        ''',
        );
      },
    );
  }

  // Future<void> insertMessage(MessageModel message) async {
  //   final db = await database;
  //   await db.insert(
  //     'messages',
  //     message.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  Future<void> insertMessage(MessageModel message) async {
    final db = await database;
    await db.insert(
      'messages',
      message.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getChatRooms() async {
    final db = await database;
    return await db.query('chat_list');
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

  Future<List<Map<String, dynamic>>> getMessages(String chatRoomId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('messages');
    List<Message> messages = List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
    return await db.query('messages', where: 'conversationId = ?', whereArgs: [chatRoomId]);
  }

  Future<void> deleteMessage(String messageId) async {
    final db = await database;
    await db.delete(
      'messages',
      where: 'messageId = ?',
      whereArgs: [messageId],
    );
  }

  Future<void> updateMessage(MessageModel message) async {
    final db = await database;
    await db.update(
      'messages',
      message.toJson(),
      where: 'messageId = ?',
      whereArgs: [message.messageId],
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
