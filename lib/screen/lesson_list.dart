
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fms/component/member_info_page.dart';

import '../locator/locator.dart';
import '../model/Member.dart';
import '../service/http_service.dart';

class LessonList extends StatefulWidget {
  const LessonList({Key? key}) : super(key: key);

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  final HttpService _httpService = locator<HttpService>();
  TextEditingController searchController = TextEditingController();
  Future<List<Member>>? searchResultList;

  String searchText = '';
  String searchOption = "name";

  int isNameDownSort = 0; // 1: ASC 0: NONE, -1: DESC
  int isCreateDownSort = 0;
  bool isMyMemberSearch = true;

  emptySearchField() {
    searchController.clear();
    setState(() {
      searchText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "수업 검색",
            style: TextStyle(
                fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isNameDownSort = (isNameDownSort == 1) ? -1 : 1;
                      isCreateDownSort = 0;
                    });
                  },
                  child: Row(
                    children: [
                      const Text("이름순"),
                      const SizedBox(width: 10,),
                      Icon(isNameDownSort == -1 ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white,),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCreateDownSort = (isCreateDownSort == 1) ? -1 : 1;
                      isNameDownSort = 0;
                    });
                  },
                  child: Row(
                    children: [
                      const Text("생성순"),
                      const SizedBox(width: 10,),
                      Icon(isCreateDownSort == -1 ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white,),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      isMyMemberSearch = (isMyMemberSearch == true) ? false : true;
                    });
                  },
                  child: Row(
                    children: [
                      isMyMemberSearch==true ? const Text("회원 전체") : const Text("담당 회원"),
                      const SizedBox(width: 10,),
                      Icon(isMyMemberSearch==true ? Icons.people : Icons.person, color: Colors.white,),
                    ],
                  ),
                ),
              ]
          ),
        ),
        Expanded(
          child: Scaffold(
            appBar: searchHeader(setState),
            body: displayFoundList(),
          ),
        ),
      ],
    );
  }

  displayFoundList() {
    searchResultList = (isMyMemberSearch == true ? _httpService.fetchMemberByEmployee() : _httpService.fetchMemberByBranch());

    return FutureBuilder(
        future: searchResultList,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Text('No DATA');
          }
          List<MemberResult> searchList = [];
          List<Member>? memberList = snapshot.data;

          memberList!.forEach((element) {
            if(searchText.isNotEmpty) {
              var tmpElement = element.name;
              if(searchOption == "name") {
                tmpElement = element.name;
              } else if(searchOption == "memberId") {
                tmpElement = element.memberId.toString();
              } else if(searchOption == "phoneNumber") {
                tmpElement = element.phoneNumber;
              }

              if(tmpElement.contains(searchText)){
                MemberResult memberResult = MemberResult(
                  eachMember: element,
                );
                searchList.add(memberResult);
              }
            } else {
              MemberResult memberResult = MemberResult(
                eachMember: element,
              );
              searchList.add(memberResult);
            }
          });

          if(isNameDownSort == -1) {
            searchList.sort((b, a) => a.eachMember.name.compareTo(b.eachMember.name));
          } else if(isNameDownSort == 1) {
            searchList.sort((a, b) => a.eachMember.name.compareTo(b.eachMember.name));
          }

          if(isCreateDownSort == -1) {
            searchList.sort((b, a) => a.eachMember.memberId.compareTo(b.eachMember.memberId));
          } else if(isCreateDownSort == 1){
            searchList.sort((a, b) => a.eachMember.memberId.compareTo(b.eachMember.memberId));
          }

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
      actions: [
        PopupMenuButton(
          child: Icon(Icons.manage_search),
          onSelected: (value) {
            print("???????????? $value");
            searchOption = value;
          },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("이름"), value: "name",),
              PopupMenuItem(child: Text("ID"), value: "memberId",),
              PopupMenuItem(child: Text("전화번호"), value: "phoneNumber",),
            ],
        ),
      ],
    );
  }
}

class MemberResult extends StatelessWidget {
  final Member eachMember;

  const MemberResult({
    required this.eachMember,
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
                    pageBuilder: (context, animation, secondaryAnimation) => MemberInfoPage(eachMember: eachMember,),
                    fullscreenDialog: false,
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.face),backgroundColor: Colors.blue,),
                title: Row(
                  children: [
                    Text(eachMember.name, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(width: 8,),
                    Text("["),
                    Text(eachMember.memberId.toString(), style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                    Text("]"),
                  ],
                ),
                subtitle: Text(eachMember.phoneNumber, style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
            )
          ],
        ),
      ),
    );
  }
}
