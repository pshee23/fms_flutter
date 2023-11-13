
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

  emptySearchField() {
    searchController.clear();
    setState(() {
      searchText = '';
    });
  }

  // TODO search none registered branch member list

  @override
  Widget build(BuildContext context) {
    searchResultList = _httpService.fetchMemberByEmployee();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "회원 검색",
            style: TextStyle(
                fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
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
    return FutureBuilder(
        future: searchResultList,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Text('No DATA');
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
