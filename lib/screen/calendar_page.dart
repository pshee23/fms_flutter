import 'package:fms/component/schedule_bottom_sheet.dart';
import 'package:fms/const/colors.dart';
import 'package:flutter/material.dart';

import '../component/calendar.dart';
import '../component/calendar_info_list.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8.0,),
            CalendarInfoList(
              selectedDay: selectedDay,
              onDaySelected: onDaySelected,
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: (){
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) {
            return ScheduleBottomSheet(
              selectedDate: selectedDay,
            );
          },
        ).whenComplete(() => onDaySelected(selectedDay, selectedDay));
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(Icons.add),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay){
    print("onDaySelected called! selected=$selectedDay, focused=$focusedDay");
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay; // 이전 달 날짜 선택시 캘린더 이동
    });
  }
}