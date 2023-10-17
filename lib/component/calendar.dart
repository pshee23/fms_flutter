import 'package:fms/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;

  final OnDaySelected? onDaySelected;

  const Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration( // 평일 박스 데코
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.grey[200],
    );
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    // TODO
    Map<DateTime, List<String>> events = {
      DateTime.utc(2023,10,13) : [ "12", "23" ],
      DateTime.utc(2022,10,14) : [ "23" ],
    };

    List<String> getEventsForDay(DateTime day) {
      return events[day] ?? [];
    }
    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        )
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false, // 오늘 날짜 표시 여부
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
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle, // 외부 박스 변경. 기본 동그라미라 선택시 오류
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          color: PRIMARY_COLOR,
        ),
        // markerSizeScale: 0.5,
        markersAnchor : 1.3,
        markersMaxCount : 1,
        markerSize : 8.0,
        markerDecoration : const BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.circle,
          // backgroundBlendMode: BlendMode.screen,
        ),
      ),
      onDaySelected: onDaySelected,
      selectedDayPredicate: (DateTime date) {
        if(selectedDay == null) {
          return false;
        }
        // 시 분 초 말고 날짜만 비교하기 위해
        return date.year == selectedDay!.year &&
        date.month == selectedDay!.month &&
        date.day == selectedDay!.day;
      },
      eventLoader: getEventsForDay,
    );
  }
}

class Event {
  String title;

  Event(this.title);
}