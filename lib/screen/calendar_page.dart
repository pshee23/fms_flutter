import 'package:fms/component/schedule_bottom_sheet.dart';
import 'package:fms/component/schedule_card.dart';
import 'package:fms/component/today_banner.dart';
import 'package:fms/const/colors.dart';
import 'package:flutter/material.dart';

import '../component/calendar.dart';

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
            SizedBox(height: 8.0,),
            TodayBanner(
                selectedDay: selectedDay,
                scheduleCount: 3
            ),
            SizedBox(height: 8.0,),
            _ScheduleList(),
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
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(Icons.add),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay){
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay; // 이전 달 날짜 선택시 캘린더 이동
    });
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
            itemCount: 3,
            separatorBuilder: (context, index) {
              return SizedBox(height: 8.0,);
            }, // item 사이에 이루어지는 Builder
            itemBuilder: (context, index){
              return ScheduleCard(
                startTime: 12,
                endTime: 14,
                content: '프로그래밍 공부하기',
                color: Colors.red,
              );
            }),
      ),
    );
  }
}
