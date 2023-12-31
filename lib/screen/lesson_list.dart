
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  List<ElevatedButton> keywordList = [];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  double screenHeight = 0;
  double screenWidth = 0;

  bool isFirstRequest = true;

  String searchText = '';
  String searchOption = "name";

  int isNameDownSort = 0; // 1: ASC 0: NONE, -1: DESC
  int isDateDownSort = 0;
  bool isMyLessonSearch = true;

  emptySearchField() {
    searchController.clear();
    setState(() {
      searchText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ExpansionTile(
          title: Text("정렬 & 필터"),
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(isDateDownSort == 1) {
                        isDateDownSort = -1;
                        keywordList.add(keywordCard("날짜-내림차순"));
                        removeFromList("날짜-오름차순");
                      } else {
                        isDateDownSort = 1;
                        keywordList.add(keywordCard("날짜-오름차순"));
                        removeFromList("날짜-내림차순");
                      }
                    });
                  },
                  child: Row(
                    children: [
                      const Text("시간순"),
                      const SizedBox(width: 10,),
                      Icon(isDateDownSort == -1 ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white,),
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
              ],
            ),
          ],
        ),
        ExpansionTile(
          title: Text("날짜 범위 설정"),
          children: [
            Row(
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
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFirstRequest = true;
                      removeFromList(DateFormat('yyyy-MM-dd').format(startDate).toString());
                      removeFromList(DateFormat('yyyy-MM-dd').format(endDate).toString());
                    });
                  },
                  child: const Row(
                    children: [
                      Text("날짜 초기화"),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text("상세 검색"),
          children: <Widget> [
            Divider(height: 3, color: Colors.grey,),
            Row(
              children: [
                SizedBox(width: screenWidth*0.2, child: Text("수업명", textAlign: TextAlign.center,)),
                SizedBox(
                  width: screenWidth*0.8,
                  child: TextFormField(
                      controller: searchController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9a-z A-Z ㄱ-ㅎ|가-힣|·|：]'))
                      ],
                      decoration: InputDecoration(
                        hintText: '수업명 검색',
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
                        suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.lightBlueAccent,),
                          onPressed: emptySearchField,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                          searchOption = "className";
                        });
                      }
                  ),
                )
              ],
            ),
            // Container(
            //   height: screenHeight*0.05,
            //   width: screenWidth,
            //   child: Text("text")
            // ),
            // Scaffold(
            //   appBar: searchHeader(setState),
            //   // body: displayFoundList(),
            // ),
          ]
        ),
        SizedBox(
          child: Wrap(
            direction: Axis.horizontal, // 나열 방향
            alignment: WrapAlignment.start, // 정렬 방식
            spacing: 2, // 상하 간격,
            children: keywordList,
          ),
        ),
        displayFoundList()
      ],
    );
  }

  removeFromList(value) {
    ElevatedButton tmp = keywordCard(value);
    keywordList.removeWhere((element) => element.key == tmp.key);
  }

  displayFoundList() {
    // searchResultList = (isMyLessonSearch == true ? _httpService.fetchLessonsByEmployee() : _httpService.fetchLessonsByBranch());
    searchResultList = (isFirstRequest == true) ? _httpService.fetchScheduleRange(null, null, isDateDownSort, 0) : _httpService.fetchScheduleRange(startDate, endDate, isDateDownSort, 0);

    return FutureBuilder(
        future: searchResultList,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(child: Text('결과 없음', style: TextStyle(color: Colors.grey),), );
          }

          List<Schedule>? lessonList = snapshot.data;
          List<Schedule>? searchList = [];

          lessonList!.forEach((element) {
            if(searchText.isNotEmpty) {
              var tmpElement = element.lessonName;
              if(searchOption == "lessonName") {
                tmpElement = element.lessonName;
              } else if(searchOption == "memberId") {
                tmpElement = element.memberId.toString();
              }

              if(tmpElement.contains(searchText)){
                searchList.add(element);
              }
            } else {
              searchList.add(element);
            }
          });
          //
          // if(isNameDownSort == -1) {
          //   searchList.sort((b, a) => a.eachMember.name.compareTo(b.eachMember.name));
          // } else if(isNameDownSort == 1) {
          //   searchList.sort((a, b) => a.eachMember.name.compareTo(b.eachMember.name));
          // }
          //
          if(isDateDownSort == -1) {
            searchList.sort((b, a) => a.startDateTime.compareTo(b.startDateTime));
          } else if(isDateDownSort == 1){
            searchList.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
          }

          // return ListView(
          //   children: searchList,
          // );
          return Container(
            // height: 253, // TODO overflow
            child: ListView.separated(
                itemCount: searchList.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8.0,);
                }, // item 사이에 이루어지는 Builder
                shrinkWrap: true,
                itemBuilder: (context, index){
                  final scheduleInfo = searchList[index];
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

  ElevatedButton keywordCard(String value) {
    return ElevatedButton(key: Key(value), onPressed: (){}, child: Text(value));
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
        isFirstRequest = false;
        keywordList.add(keywordCard(DateFormat('yyyy-MM-dd').format(startDate).toString()));
        keywordList.add(keywordCard(DateFormat('yyyy-MM-dd').format(endDate).toString()));
      });
    }
  }
}