import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../model/chat_message.dart';
import '../model/chat_room.dart';
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

  StompClient? stompClient;
  final socketUrl = 'baseurl/chatting';
  String serverUrl = dotenv.get('SERVER_URL');
  String roomId = "";
  String myId = "";

  void onConnect(StompFrame frame) {
    print("################# onConnect");
    stompClient!.subscribe(
        destination: '/sub/chat/room/' + roomId,
        callback: (StompFrame frame) {
          print("################# callback");
          if (frame.body != null) {
            print("################# body=" + frame.body.toString());
            // final ChatMessage result = json.decode(frame.body!)
            //     .map<ChatMessage>((json) => ChatMessage.fromJson(json));
            final dynamic resultDynamic = json.decode(frame.body!);
            ChatMessage result = ChatMessage.fromJson(resultDynamic);
            print("################# result=" + result.toString());
            bool isMe = false;
            if(myId == result.sender) {
              print("same @@ " + myId);
              isMe = true;
            } else {
              print("not same @@ " + myId + " / result.sender =" + result.sender);
              isMe = false;
            }
            setState(() {
              chats.add(ChatBubbles(chatMessage: result, isMe: isMe,));
            });
          }
        });
    sendJoin();
  }

  checkMyState() async {
    myId = (await storage.read(key: 'id'))!;
  }

  sendJoin() {
    print("################# sendJoin");
    stompClient!.send(
        destination: '/pub/chat/message',
        body: json.encode({
          "type" : "JOIN",
          "roomId": roomId,
          "sender" : myId,
          "content" : null
        }));
  }

  sendMessage(text){
    setState(() {
      // stompClient!.send(destination: '/chat/message', body: json.encode({"content" : _textController.value.text, "uuid": myUuid}));
      stompClient!.send(
          destination: '/pub/chat/message',
          body: json.encode({
            "type" : "CHAT",
            "roomId": roomId,
            "sender" : myId,
            "content" : text
          }));
    });
  }

  @override
  void initState() {
    roomId = widget.chatRoom.roomId;
    checkMyState();
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
              title: Text("Chat with " + widget.chatRoom.name, style: Theme.of(context).textTheme.titleLarge,),
              actions: [
                Icon(Icons.search, size: 20,),
                SizedBox(width: 25,),
                Icon(Icons.menu ,size: 20,),
                SizedBox(width: 25,)
              ],
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
