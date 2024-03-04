import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fms/model/chat_room.dart';
import 'package:http/http.dart' as http;

abstract class HttpChat {

  Future<List<ChatRoom>> fetchChatRoomsById();

  Future<ChatRoom> createChatRoom(memberName, memberId);

  void updateChatUser(status);
}

class HttpChatImplementation implements HttpChat {

  static final storage = FlutterSecureStorage();
  String serverUrl = dotenv.get('SERVER_URL');

  @override
  Future<List<ChatRoom>> fetchChatRoomsById() async {
    final id = await storage.read(key: 'id');
    final isEmployee = await storage.read(key: 'isEmployee');
    String userType = (isEmployee != null && isEmployee.contains("true")) ? 'employee' : 'member';

    var url = '/chat/room/list/$userType/$id';
    print('fetch Chat Rooms By Id. url=$url');

    final uri = Uri.http(serverUrl, url);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'toyProject1234'
      },
    );

    var code = response.statusCode;
    print('get Chat Rooms By Id list. code=$code, body=${response.body}');

    final List<ChatRoom> result = jsonDecode(utf8.decode(response.bodyBytes))
        .map<ChatRoom>((json) => ChatRoom.fromJson(json)).toList();
    print('get list body. result=$result');
    return result;
  }

  @override
  Future<ChatRoom> createChatRoom(memberName, memberId) async {
    final id = await storage.read(key: 'id');
    final body = {
      'name' : memberName,
      'employeeId' : id,
      'memberId' : memberId
    };

    var url = '/chat/room';
    final uri = Uri.http(serverUrl, url);
    print('create Chat Room. url=$uri');

    final jsonString = json.encode(body);
    final response = await http.post(
        uri,
        body: jsonString,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'toyProject1234'
        }
    );
    print('get monthly list body. result=${response.body}');
    final dynamic resultDynamic = jsonDecode(utf8.decode(response.bodyBytes));
    ChatRoom chatRoom = ChatRoom.fromJson(resultDynamic);
    print('create Chat Room body. result=$chatRoom');
    return chatRoom;
  }

  @override
  Future<void> updateChatUser(status) async {
    final id = await storage.read(key: 'id');
    var token = await storage.read(key: 'token');
    print('updateChatUser get Token???. token=$token');
    final body = {
      'id' : id,
      'deviceToken' : token.toString(),
      'status' : status
    };
    print('updateChatUser body. body=$body');
    var url = '/chat/user';
    final uri = Uri.http(serverUrl, url);
    print('update Chat User. url=$uri');

    final jsonString = json.encode(body);
    final response = await http.put(
        uri,
        body: jsonString,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'toyProject1234'
        }
    );
    print('update Chat User result. result=$response');
  }
}