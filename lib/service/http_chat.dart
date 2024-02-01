import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fms/model/chat_room.dart';
import 'package:http/http.dart' as http;

abstract class HttpChat {

  Future<List<ChatRoom>> fetchAllChatRooms();
}

class HttpChatImplementation implements HttpChat {

  static final storage = FlutterSecureStorage();
  String serverUrl = dotenv.get('SERVER_URL');

  @override
  Future<List<ChatRoom>> fetchAllChatRooms() async {
    var url = '/chat/room/list';
    print('fetch All ChatRooms. url=$url');
    final uri = Uri.http(serverUrl, url);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'toyProject1234'
      },
    );

    var code = response.statusCode;
    print('get All ChatRooms list. code=$code, body=${response.body}');

    final List<ChatRoom> result = jsonDecode(utf8.decode(response.bodyBytes))
        .map<ChatRoom>((json) => ChatRoom.fromJson(json)).toList();
    print('get list body. result=$result');
    return result;
  }
}