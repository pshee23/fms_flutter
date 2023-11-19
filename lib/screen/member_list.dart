
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../locator/locator.dart';
import '../model/Member.dart';
import '../service/http_service.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  final HttpService _httpService = locator<HttpService>();
  TextEditingController searchController = TextEditingController();
  Future<List<Member>>? searchResultList;

  String searchText = '';

  bool isNameDownSort = true;
  bool isCreateDownSort = true;
  bool isMyMemberSearch = true;

  emptySearchField() {
    searchController.clear();
    setState(() {
      searchText = '';
    });
  }

  // TODO search none registered branch member list

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "회원 검색",
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
                      isNameDownSort = (isNameDownSort == true) ? false : true;
                    });
                  },
                  child: Row(
                    children: [
                      const Text("이름순"),
                      const SizedBox(width: 10,),
                      Icon(isNameDownSort==true ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white,),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCreateDownSort = (isCreateDownSort == true) ? false : true;
                    });
                  },
                  child: Row(
                    children: [
                      const Text("생성순"),
                      const SizedBox(width: 10,),
                      Icon(isCreateDownSort==true ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white,),
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
              if(element.name.contains(searchText)){
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

          if(isNameDownSort) {
            searchList.sort((b, a) => a.eachMember.name.compareTo(b.eachMember.name));
          } else {
            searchList.sort((a, b) => a.eachMember.name.compareTo(b.eachMember.name));
          }

          if(isCreateDownSort) {
            searchList.sort((b, a) => a.eachMember.memberId.compareTo(b.eachMember.memberId));
          } else {
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
            FilteringTextInputFormatter.allow(RegExp('[a-z A-Z ㄱ-ㅎ|가-힣|·|：]'))
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
        )
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
                // TODO specific member info
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                ),
                title: Text(eachMember.name, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
                subtitle: Text(eachMember.phoneNumber, style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
