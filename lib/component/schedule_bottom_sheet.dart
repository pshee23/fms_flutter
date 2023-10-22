import 'package:fms/const/colors.dart';
import 'package:fms/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/Lesson.dart';
import '../model/category_colors.dart';
import '../model/schedule.dart';
import '../service/http_service.dart';
import 'custom_text_field.dart';
import 'custom_time_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({
    required this.selectedDate,
    Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String? startTime;
  String? endTime;

  int? lessonId;
  int? memberId;
  int? employeeId;

  int? selectedColorId;

  String? lessonText = '';

  final HttpService _httpService = locator<HttpService>();
  TextEditingController searchController = TextEditingController();
  Future<List<Lesson>>? lessonListResults;
  emptySearchField() {
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // 키보드의 높이
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // 빈 공간 누르면 키보드 내려가도록
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
                      onStartTimeSaved: (String? val) {
                        startTime = val;
                      },
                      onEndTimeSaved: (String? val) {
                        endTime = val;
                      }
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(Icons.format_list_bulleted_outlined),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text(lessonText!)
                        ),
                        ElevatedButton.icon(onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Select Lesson"),
                                  content: Scaffold(
                                    appBar: SearchHeader(),
                                    body: lessonListResults == null ? displayAllList() : displayFoundList(),
                                  )
                                );
                              }
                          );
                          setState(() {
                            lessonText = '1:1 PT 수업';
                          });
                        }, icon: Icon(Icons.search), label: Text("검색"),),
                      ]
                    ),
                    _Content(
                      onLessonIdSaved: (String? val) {
                        lessonId = int.parse(val!);
                      },
                      onMemberIdSaved: (String? val) {
                        memberId = int.parse(val!);
                      },
                      onEmployeeIdSaved: (String? val) {
                        employeeId = int.parse(val!);
                      },
                    ),
                    SizedBox(height: 16.0),
                    FutureBuilder<List<CategoryColors>>(
                        future: _httpService.fetchCategoryColors(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData && selectedColorId == null && snapshot.data!.isNotEmpty) {
                            selectedColorId = snapshot.data![0].colorId;
                          }
                          return _ColorPicker(
                            colors: snapshot.hasData
                                ? snapshot.data! : [],
                            selectedColorId: selectedColorId,
                            colorIdSetter: (int id){
                              setState(() {
                                selectedColorId = id;
                              });
                            },
                          );
                        }
                    ),
                    SizedBox(height: 8.0),
                    _SaveButton(
                      onPressed: onSavedPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar SearchHeader() {
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
            prefixIcon: Icon(Icons.person_pin, color: Colors.lightBlueAccent, size:30),
            suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white,),
              onPressed: emptySearchField,
            ),
          ),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          onFieldSubmitted: (str) {
            print(str);
            Future<List<Lesson>> lessonList = _httpService.fetchLessons();

            setState(() {
              lessonListResults = lessonList;
            });
          },
        )
    );
  }

  displayAllList() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group, color: Colors.grey, size: 15),
            Text(
              'Search Lesson',
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
    return FutureBuilder<List<Lesson>>(
      future: lessonListResults,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Text('No DATA');
        }

        List<LessonResult> searchList = [];
        List<Lesson>? lessonList = snapshot.data;
        lessonList!.forEach((element) {
          LessonResult lessonResult = LessonResult(element);
          searchList.add(lessonResult);
        });
        return ListView(
           children: searchList,
        );
      }
    );
  }

  void onSavedPressed() async {
    // formKey는 생성을 했는데, Form 위젯과 결합을 안했을 때
    if(formKey.currentState == null) {

    }

    // validate를 실행하면 모든 form 필드의 validator가 실행되고 에러가 있으면 String 리턴, 없으면 null
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();

      var selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.selectedDate.toString())).toString();
      var startTimeStr = '$selectedDate $startTime:00';
      var endTimeStr = '$selectedDate $endTime:00';
      print('startTimeStr=$startTimeStr, endTimeStr=$endTimeStr');
      DateTime startTimeRes = DateTime.parse(startTimeStr);
      DateTime endTimeRes = DateTime.parse(endTimeStr);
      print('startTime=$startTimeRes, endTime=$endTimeRes');

      Schedule schedule = Schedule(
        lessonHistoryId: 0,
        lessonId: int.parse('$lessonId'),
        lessonName: "", // TODO read/write 별도의 class..
        memberId: int.parse('$memberId'),
        memberName: "",
        employeeId: int.parse('$employeeId'),
        employeeName: "",
        startDateTime: startTimeRes,
        endDateTime: endTimeRes,
        status: "RESERVE",
        // colorId: 1,
        // updateDateTime: DateTime.now()
      );
      var code = await _httpService.createLessonHistory(schedule);
      print('create Lesson ?! $code');
      Navigator.pop(context);
    } else {
      print("create Lesson 에러가 있습니다");
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartTimeSaved;
  final FormFieldSetter<String> onEndTimeSaved;

  const _Time({
    required this.onStartTimeSaved,
    required this.onEndTimeSaved,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
            child: CustomTimeField(
              onSaved: onStartTimeSaved,
              label: 'Start',
            )
        ),
        SizedBox(width: 16.0,),
        Expanded(
            child: CustomTimeField(
              onSaved: onEndTimeSaved,
              label: 'End',
            )
        ),
      ],
    );
  }
}


class _Content extends StatelessWidget {
  final FormFieldSetter<String> onLessonIdSaved;
  final FormFieldSetter<String> onMemberIdSaved;
  final FormFieldSetter<String> onEmployeeIdSaved;

  const _Content({
    required this.onLessonIdSaved,
    required this.onMemberIdSaved,
    required this.onEmployeeIdSaved,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomTextField(
              lable: 'lessonId',
              isTime: false,
              onSaved: onLessonIdSaved,
            ),
          ),
          SizedBox(width: 8.0,),
          Expanded(
            child: CustomTextField(
              lable: 'memberId',
              isTime: false,
              onSaved: onMemberIdSaved,
            ),
          ),
          SizedBox(width: 8.0,),
          Expanded(
            child: CustomTextField(
              lable: 'employeeId',
              isTime: false,
              onSaved: onEmployeeIdSaved,
            ),
          ),
        ],
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColors> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors.map((e) =>
          GestureDetector(
              onTap: () {
                colorIdSetter(e.colorId!);
              },
              child: renderColor(
                  e,
                  selectedColorId == e.colorId
              )
          )
      ).toList(),
    );
  }

  Widget renderColor(CategoryColors color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(int.parse('FF${color.hexCode}', radix: 16)),
          border: isSelected ? Border.all(
            color: Colors.black,
            width: 4.0,
          ) : null
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                child: Text('저장')
            )
        ),
      ],
    );
  }
}

class LessonResult extends StatelessWidget {
  final Lesson eachLesson;
  LessonResult(this.eachLesson);

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
                print('tapped=$eachLesson');
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  // backgroundImage: eachLesson.lessonId == 0 > circularProgress() : null
                ),
                title: Text(eachLesson.lessonName, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
                subtitle: Text(eachLesson.memberName, style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
