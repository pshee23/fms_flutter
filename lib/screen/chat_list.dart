import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fms/component/ChatRoomScreen.dart';

import '../component/chatroom_bottom_sheet.dart';
import '../const/colors.dart';
import '../locator/locator.dart';
import '../model/chat_room.dart';
import '../service/http_chat.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final HttpChat _httpChat = locator<HttpChat>();
  TextEditingController searchController = TextEditingController();
  Future<List<ChatRoom>>? searchResultList;

  String searchText = '';
  String searchOption = "name";

  emptySearchField() {
    searchController.clear();
    setState(() {
      searchText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "채팅",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              appBar: searchHeader(setState),
              body: chatRoomFoundList(),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: (){
        // TODO Create Custom Chat Room
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) {
            return ChatroomBottomSheet();
          },
        ).whenComplete(() => resetPage());
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(Icons.add),
    );
  }

  resetPage() {
    setState(() {

    });
  }

  chatRoomFoundList() {
    searchResultList = _httpChat.fetchChatRoomsById();

    return FutureBuilder(
        future: searchResultList,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Text('No DATA');
          }
          List<RoomResult> searchList = [];
          List<ChatRoom>? roomList = snapshot.data;

          roomList!.forEach((element) {
            searchList.add(RoomResult(eachRoom: element));
          });
          // memberList!.forEach((element) {
          //   if(searchText.isNotEmpty) {
          //     var tmpElement = element.name;
          //     if(searchOption == "name") {
          //       tmpElement = element.name;
          //     } else if(searchOption == "memberId") {
          //       tmpElement = element.memberId.toString();
          //     } else if(searchOption == "phoneNumber") {
          //       tmpElement = element.phoneNumber;
          //     }
          //
          //     if(tmpElement.contains(searchText)){
          //       MemberResult memberResult = MemberResult(
          //         eachMember: element,
          //       );
          //       searchList.add(memberResult);
          //     }
          //   } else {
          //     MemberResult memberResult = MemberResult(
          //       eachMember: element,
          //     );
          //     searchList.add(memberResult);
          //   }
          // });

          return ListView(
            children: searchList,
          );
        }
    );
  }

  AppBar searchHeader(StateSetter setState) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: TextFormField(
          controller: searchController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9a-z A-Z ㄱ-ㅎ|가-힣|·|：]'))
          ],
          decoration: InputDecoration(
            hintText: '등록된 회원 검색',
            hintStyle: TextStyle(
              color: Colors.lightBlueAccent,
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlueAccent)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            filled: true,
            suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white,),
              onPressed: emptySearchField,
            ),
          ),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          }
      ),
    );
  }
}

class RoomResult extends StatelessWidget {
  final ChatRoom eachRoom;

  const RoomResult({
    required this.eachRoom,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(1.0, 0);
                      var end = Offset.zero;
                      var curve = Curves.ease;
                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(
                        CurveTween(curve: curve),
                      );
                      return SlideTransition(position: animation.drive(tween),child: child,);
                    },
                    pageBuilder: (context, animation, secondaryAnimation) => ChatRoomScreen(chatRoom: eachRoom,),
                    fullscreenDialog: false,
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.face),backgroundColor: Colors.blue,),
                title: Row(
                  children: [
                    Text(eachRoom.name, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(width: 8,),
                    Text("["),
                    Text(eachRoom.memberId, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                    Text("]"),
                  ],
                ),
                subtitle: Text(eachRoom.roomId, style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
            )
          ],
        ),
      ),
    );
  }
}
