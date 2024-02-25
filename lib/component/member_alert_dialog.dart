import 'package:flutter/material.dart';
import 'package:fms/model/Member.dart';
import '../locator/locator.dart';
import '../service/http_service.dart';

typedef MemberSetter = void Function(Member member);

class MemberAlertDialog extends StatefulWidget {
  final MemberSetter memberResult;

  const MemberAlertDialog({
    required this.memberResult,
    Key? key}) : super(key: key);

  @override
  State<MemberAlertDialog> createState() => _MemberAlertDialogState();
}

class _MemberAlertDialogState extends State<MemberAlertDialog> {
  String? labelText = '';

  final HttpService _httpService = locator<HttpService>();
  TextEditingController searchController = TextEditingController();
  Future<List<Member>>? searchResultList;

  emptySearchField() {
    searchController.clear();
  }

  @override
  void initState() {
    Future<List<Member>> memberList = _httpService.fetchMemberByBranch();

    setState(() {
      searchResultList = memberList;
    });
    super.initState();
  }

  // TODO 회원 검색 페이지로 연동해서 가져오는 방법도 생각
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Icon(Icons.format_list_bulleted_outlined),
          SizedBox(width: 10),
          Expanded(
              child: Text(labelText!)
          ),
          ElevatedButton.icon(onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                            title: Text("Select member"),
                            content: Scaffold(
                              appBar: searchHeader(setState),
                              body: searchResultList == null
                                  ? displayNoneList()
                                  : displayFoundList(),
                            )
                        );
                      }
                  );
                }
            );
          }, icon: Icon(Icons.search), label: Text("검색"),),

        ]
    );
  }

  AppBar searchHeader(StateSetter setState) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search here..',
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
            // prefixIcon: Icon(Icons.person_pin, color: Colors.lightBlueAccent, size:30),
            suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white,),
              onPressed: emptySearchField,
            ),
          ),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          onFieldSubmitted: (str) {
            print('onFieldSubmitted=$str');
            Future<List<Member>> memberList = _httpService.fetchMemberByBranch();

            setState(() {
              searchResultList = memberList;
              print('onFieldSubmitted result=$searchResultList');
            });
          },
        )
    );
  }

  displayNoneList() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group, color: Colors.grey, size: 15),
            Text(
              'Search Member',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
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
            MemberResult memberResult = MemberResult(
              eachMember: element,
              memberSetter: (Member member) {
                setState(() {
                  labelText = member.name;
                  widget.memberResult(member);
                });
              },
            );
            searchList.add(memberResult);
          });

          return ListView(
            children: searchList,
          );
        }
    );
  }

}

class MemberResult extends StatelessWidget {
  final Member eachMember;
  final MemberSetter memberSetter;

  const MemberResult({
    required this.eachMember,
    required this.memberSetter,
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
                print('tapped=$eachMember');
                memberSetter(eachMember);
                Navigator.pop(context);
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
