import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../localDB/DatabaseService.dart';
import '../localDB/local_chat_message.dart';
import '../locator/locator.dart';
import '../model/chat_message.dart';
import '../model/chat_room.dart';
import '../service/http_chat.dart';
import 'chat_bubbles.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatRoomScreen({
    required this.chatRoom,
    Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final List<ChatBubbles> chats = [];
  final TextEditingController _textEditingController = TextEditingController();

  static final storage = FlutterSecureStorage();
  final HttpChat _httpChat = locator<HttpChat>();
  final DatabaseService database = DatabaseService();

  StompClient? stompClient;
  final socketUrl = 'baseurl/chatting';
  String serverUrl = dotenv.get('SERVER_URL');
  String roomId = "";
  String myId = "";
  String token = "";

  void onConnect(StompFrame frame) {
    print("################# onConnect");
    stompClient!.subscribe(
        destination: '/sub/chat/room/' + roomId,
        callback: (StompFrame frame) {
          if (frame.body != null) {
            final dynamic resultDynamic = json.decode(frame.body!);
            ChatMessage result = ChatMessage.fromJson(resultDynamic);

            bool isMe = false;
            String isRead = 'N';
            if(myId == result.sender) {
              isMe = true;
              isRead = 'N';
            } else {
              isMe = false;
              isRead = 'Y';
            }

            LocalChatMessage message = LocalChatMessage(null, result.roomId, isRead, result.sender, result.content);

            setState(() {
              if(result.type == "CHAT") {
                chats.add(ChatBubbles(chatMessage: result, isRead: isRead == 'N' ? false : true, isMe: isMe,));
                database.addMessage(message);
              } else if (result.type == "JOIN"){

              }

            });
          }
        });
    sendJoin();
  }

  getMyId() async {
    myId = (await storage.read(key: 'id'))!;
  }

  void getMyDeviceToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    print("내 디바이스 토큰 : $token");
  }

  sendJoin() {
    print("################# sendJoin.");
    stompClient!.send(
        destination: '/pub/chat/message',
        body: json.encode({
          "type" : "JOIN",
          "roomId": roomId,
          "sender" : myId,
          "content" : null,
          "deviceToken" : token
        }));
    _httpChat.updateChatUser(roomId, "JOIN");
  }

  sendLeave() {
    print("################# sendLeave.");
    stompClient!.send(
        destination: '/pub/chat/message',
        body: json.encode({
          "type" : "LEAVE",
          "roomId": roomId,
          "sender" : myId,
          "content" : null,
          "deviceToken" : token
        }));
  }

  sendMessage(text){
    print("################# send Text");
    setState(() {
      stompClient!.send(
          destination: '/pub/chat/message',
          body: json.encode({
            "type" : "CHAT",
            "roomId": roomId,
            "sender" : myId,
            "content" : text,
            "deviceToken" : token
          }));
    });
  }

  getChatHistory() async {
    Future<List<LocalChatMessage>> localChat = database.findMessages(roomId);
    await localChat.asStream().forEach((element) {
      element.forEach((element) {
        print("############# localChat = " + element.toString());
        bool isMe = false;
        if(myId == element.sender) {
          isMe = true;
        } else {
          isMe = false;
        }
        ChatMessage message = ChatMessage("CHAT", element.roomId, element.sender, element.content);
        ChatBubbles bubbles = ChatBubbles(chatMessage: message, isRead: element.isRead == 'N' ? false : true, isMe: isMe,);
        chats.add(bubbles);
      });
    });
    setState(() {

    });
  }

  @override
  void initState() {
    roomId = widget.chatRoom.roomId;

    getChatHistory();

    getMyId();
    var url = "http://$serverUrl/ws";
    print("############ roomId=" +roomId+"/ url=" + url);
    super.initState();
    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.sockJS(
            url: url,
            onConnect: onConnect,
            onWebSocketError: (dynamic error) => print(error.toString()),
            //stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
            //webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
          ));
      stompClient!.activate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue[100],
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text("Chat with " + widget.chatRoom.title, style: Theme.of(context).textTheme.titleLarge,),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  print("뒤로 가기 버튼 클릭!");
                  _httpChat.updateChatUser(roomId, "LEAVE");
                  stompClient?.deactivate();
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
                children: [
                  // chat list 칸
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _TimeLine(time: "2023년 1월 1일 금요일"),
                          ...List.generate(chats.length, (index) => chats[index]),
                        ],
                      )
                    ),
                  ),
                  // chat 입력 칸
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              child: TextField(
                                controller: _textEditingController,
                                maxLines: 1,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                                onSubmitted: _handleSubmitted,
                              )
                          ),
                        ),
                      ]
                    ),
                  )
                ],
            ),
        ),
    );
  }
  void _handleSubmitted(text) {
    _textEditingController.clear(); // 전송하면 텍스트필드를 비워줌
    setState(() {
      // chats.add(  // 다시 그리기 위해 리스트에 추가
      //   // MyChat(text: text, time: DateFormat("a k:m").format(new DateTime.now())
      //   //     .replaceAll("AM", "오전")
      //   //     .replaceAll("PM", "오후"),
      //   // ),
      //     ChatBubbles(chatMessage: text)
      // );
      sendMessage(text);
    });
  }
}

class _TimeLine extends StatelessWidget {
  final String time;

  const _TimeLine({
    required this.time,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(time);
  }
}
