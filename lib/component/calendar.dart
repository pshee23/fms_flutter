import 'dart:collection';

import 'package:fms/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../locator/locator.dart';
import '../service/http_service.dart';

class Calendar extends StatefulWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected? onDaySelected;

  const Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime focusedDate = DateTime.now();

  @override
  void initState() {
    focusedDate = widget.focusedDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = locator<HttpService>();
    Map<DateTime, List<String>> monthEventCount = HashMap<DateTime, List<String>>();

    final defaultBoxDeco = BoxDecoration( // 평일 박스 데코
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.grey[200],
    );
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );
    const headerStyle = HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        )
    );

    List<String> getEventsForDay(DateTime day) {
      return monthEventCount[day] ?? [];
    }
    return FutureBuilder(
      future: httpService.fetchMonthlySchedule(focusedDate),
      builder: (BuildContext context, AsyncSnapshot<Map<DateTime, List<String>>> snapshot) {
        if (snapshot.hasData == false) {
          return const Text("No Schedule");
        }
        print('Calendar.dart FutureBuilder. Data=${snapshot.data}');
        monthEventCount = snapshot.data!;

        return TableCalendar(
          locale: 'ko_KR',
          focusedDay: focusedDate,
          firstDay: DateTime(1800),
          lastDay: DateTime(3000),
          headerStyle: headerStyle,
          calendarStyle: CalendarStyle(
            isTodayHighlighted: false,
            // 오늘 날짜 표시 여부
            defaultDecoration: defaultBoxDeco,
            weekendDecoration: defaultBoxDeco,
            selectedDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: PRIMARY_COLOR,
                  width: 1.0,
                )
            ),
            outsideDecoration: const BoxDecoration(
              shape: BoxShape.rectangle, // 외부 박스 변경. 기본 동그라미라 선택시 오류
            ),
            defaultTextStyle: defaultTextStyle,
            weekendTextStyle: defaultTextStyle,
            selectedTextStyle: defaultTextStyle.copyWith(
              color: PRIMARY_COLOR,
            ),
            // markerSizeScale: 0.5,
            markersAnchor: 1.3,
            markersMaxCount: 1,
            markerSize: 8.0,
            markerDecoration: const BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              // backgroundBlendMode: BlendMode.screen,
            ),
          ),
          onDaySelected: widget.onDaySelected,
          selectedDayPredicate: (DateTime date) {
            if (widget.selectedDay == null) {
              return false;
            }
            // 시 분 초 말고 날짜만 비교하기 위해
            return date.year == widget.selectedDay!.year &&
                date.month == widget.selectedDay!.month &&
                date.day == widget.selectedDay!.day;
          },
          onPageChanged: (DateTime date) {
            print("onPageChanged =$date, focusedDay=${widget.focusedDay}");
            setState(() {
              focusedDate = date;
            });
          },
          eventLoader: getEventsForDay,
        );
      }
    );
  }
}