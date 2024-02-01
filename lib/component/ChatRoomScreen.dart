import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;

  const ChatRoomScreen({
    required this.roomId,
    Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  // final List<MyChat> chats = []; // 내가 입력한 채팅 // 상대방 채팅을 저장할 리스트도 필요하긴 함
  final List<Text> chats = [];
  final TextEditingController _textEditingController = TextEditingController();

  StompClient? stompClient;
  final socketUrl = 'baseurl/chatting';
  String serverUrl = dotenv.get('SERVER_URL');

  void onConnect(StompFrame frame) {
    print("################# onConnect");
    stompClient!.subscribe(
        destination: '/sub/chat/room/65bb60be080ebd450933e4f5',
        callback: (StompFrame frame) {
          print("################# callback");
          if (frame.body != null) {
            // Map<String, dynamic> obj = json.decode(frame.body!);
            print("#################");
            // Msg message = Msg(content : obj['content'], uuid : obj['uuid']);
            // setState(() => {
            //   list.add(message)
            // });
          }
        });
    sendJoin();
  }

  sendJoin() {
    print("################# sendJoin");
    stompClient!.send(
        destination: '/pub/chat/message',
        body: json.encode({
          "type" : "JOIN",
          "roomId": "65bb64c0768bbe33afff7cc2",
          "sender" : "aaa",
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
            "roomId": "65bb64c0768bbe33afff7cc2",
            "sender" : "aaa",
            "content" : text
          }));
    });
  }

  @override
  void initState() {
    var url = "http://$serverUrl/ws";
    print("############ url=" + url);
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
              title: Text("홍길동", style: Theme.of(context).textTheme.titleLarge,),
              actions: [
                Icon(Icons.search, size: 20,),
                SizedBox(width: 25,),
                Icon(Icons.menu ,size: 20,),
                SizedBox(width: 25,)
              ],
            ),
            body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _TimeLine(time: "2023년 1월 1일 금요일"),
                          // OtherChat(
                          //   name: "홍길동",
                          //   text: "새해 복 많이 받으세요",
                          //   time: "오전 10:10",),
                          // MyChat(
                          //   time: "오후 2:15",
                          //   text: "선생님도 많이 받으십시오.",
                          // ),
                          ...List.generate(chats.length, (index) => chats[index]),
                        ],
                      )
                    ),
                  ),
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
      chats.add(  // 다시 그리기 위해 리스트에 추가
        // MyChat(text: text, time: DateFormat("a k:m").format(new DateTime.now())
        //     .replaceAll("AM", "오전")
        //     .replaceAll("PM", "오후"),
        // ),
          Text(text),
      );
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
