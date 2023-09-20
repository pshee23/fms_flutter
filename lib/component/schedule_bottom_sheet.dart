import 'package:fms/const/colors.dart';
import 'package:fms/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/category_colors.dart';
import '../model/schedule.dart';
import '../service/http_service.dart';
import 'custom_text_field.dart';

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

  int? startHour;
  int? startMin;
  int? endHour;
  int? endMin;

  int? lessonId;
  int? memberId;
  int? employeeId;

  int? selectedColorId;

  final HttpService _httpService = locator<HttpService>();

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
                      onStartHourSaved: (String? val) {
                        startHour = int.parse(val!);
                      },
                      onStartMinSaved: (String? val) {
                        startMin = int.parse(val!);
                      },
                      onEndHourSaved: (String? val) {
                        endHour = int.parse(val!);
                      },
                      onEndMinSaved: (String? val) {
                        endMin = int.parse(val!);
                      },
                    ),
                    SizedBox(height: 16.0),
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

  void onSavedPressed() async {
    // formKey는 생성을 했는데, Form 위젯과 결합을 안했을 때
    if(formKey.currentState == null) {

    }

    // validate를 실행하면 모든 form 필드의 validator가 실행되고 에러가 있으면 String 리턴, 없으면 null
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.selectedDate.toString())).toString();
      var startTimeStr = '$selectedDate $startHour:$startMin:00';
      var endTimeStr = '$selectedDate $endHour:$endMin:00';
      print('startTimeStr=$startTimeStr, endTimeStr=$endTimeStr');
      DateTime startTime = DateTime.parse(startTimeStr);
      DateTime endTime = DateTime.parse(endTimeStr);
      print('startTime=$startTime, endTime=$endTime');
      Schedule schedule = Schedule(
        lessonHistoryId: 0,
        lessonId: 1,
        memberId: 1,
        employeeId: 1,
        startDateTime: startTime,
        endDateTime: endTime,
        status: "RESERVE",
        // colorId: 1,
        // updateDateTime: DateTime.now()
      );
      var code = await _httpService.createLessonHistory(schedule);
    } else {
      print("에러가 있습니다");
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartHourSaved;
  final FormFieldSetter<String> onStartMinSaved;
  final FormFieldSetter<String> onEndHourSaved;
  final FormFieldSetter<String> onEndMinSaved;

  const _Time({
    required this.onStartHourSaved,
    required this.onStartMinSaved,
    required this.onEndHourSaved,
    required this.onEndMinSaved,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
              lable: 'Start Hour',
              isTime: true,
              onSaved: onStartHourSaved,
            )
        ),
        Expanded(
            child: CustomTextField(
              lable: 'Min',
              isTime: true,
              onSaved: onStartMinSaved,
            )
        ),
        SizedBox(width: 16.0,),
        Expanded(
            child: CustomTextField(
              lable: 'End Hour',
              isTime: true,
              onSaved: onEndHourSaved,
            )
        ),
        Expanded(
            child: CustomTextField(
              lable: 'Min',
              isTime: true,
              onSaved: onEndMinSaved,
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
