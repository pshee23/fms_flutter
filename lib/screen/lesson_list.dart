
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../component/schedule_card.dart';
import '../locator/locator.dart';
import '../model/schedule.dart';
import '../service/http_service.dart';

class LessonList extends StatefulWidget {
  const LessonList({Key? key}) : super(key: key);

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  final HttpService _httpService = locator<HttpService>();
  TextEditingController searchController = TextEditingController();
  Future<List<Schedule>>? searchResultList;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  bool isFirstRequest = true;

  String searchText = '';
  String searchOption = "name";

  int isNameDownSort = 0; // 1: ASC 0: NONE, -1: DESC
  int isCreateDownSort = 0;
  bool isMyLessonSearch = true;

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
                      _selectDate(context);
                    });
                  },
                  child: const Row(
                    children: [
                      Text("검색 범위"),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       isNameDownSort = (isNameDownSort == 1) ? -1 : 1;
                //       isCreateDownSort = 0;
                //     });
                //   },
                //   child: Row(
                //     children: [
                //       const Text("이름순"),
                //       const SizedBox(width: 10,),
                //       Icon(isNameDownSort == -1 ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white,),
                //     ],
                //   ),
                // ),
                // const SizedBox(width: 10,),
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
                      isMyLessonSearch = (isMyLessonSearch == true) ? false : true;
                    });
                  },
                  child: Row(
                    children: [
                      isMyLessonSearch==true ? const Text("수업 전체") : const Text("담당 수업"),
                      const SizedBox(width: 10,),
                      Icon(isMyLessonSearch==true ? Icons.people : Icons.person, color: Colors.white,),
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
    // searchResultList = (isMyLessonSearch == true ? _httpService.fetchLessonsByEmployee() : _httpService.fetchLessonsByBranch());
    searchResultList = isFirstRequest == true ? _httpService.fetch10Schedules() : _httpService.fetchScheduleRange(startDate, endDate);

    return FutureBuilder(
        future: searchResultList,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(child: Text('결과 없음', style: TextStyle(color: Colors.grey),), );
          }

          List<Schedule>? lessonList = snapshot.data;
          print("??????????? $lessonList");
          // lessonList!.forEach((element) {
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
          //
          // if(isNameDownSort == -1) {
          //   searchList.sort((b, a) => a.eachMember.name.compareTo(b.eachMember.name));
          // } else if(isNameDownSort == 1) {
          //   searchList.sort((a, b) => a.eachMember.name.compareTo(b.eachMember.name));
          // }
          //
          // if(isCreateDownSort == -1) {
          //   searchList.sort((b, a) => a.eachMember.memberId.compareTo(b.eachMember.memberId));
          // } else if(isCreateDownSort == 1){
          //   searchList.sort((a, b) => a.eachMember.memberId.compareTo(b.eachMember.memberId));
          // }

          // return ListView(
          //   children: searchList,
          // );
          return Container(
            // height: 253, // TODO overflow
            child: ListView.separated(
                itemCount: lessonList!.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8.0,);
                }, // item 사이에 이루어지는 Builder
                shrinkWrap: true,
                itemBuilder: (context, index){
                  final scheduleInfo = lessonList[index];
                  return ScheduleCard(
                    startTime: scheduleInfo.startDateTime,
                    endTime: scheduleInfo.endDateTime,
                    scheduleInfo: scheduleInfo,
                    color: Colors.red,
                    onDaySelected: null,
                  );
                }),
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
            hintText: '수업 검색',
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

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate.start;
        endDate = pickedDate.end;
      });
    }
  }
}