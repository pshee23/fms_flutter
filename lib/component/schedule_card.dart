import 'package:flutter/material.dart';
import 'package:fms/component/schedule_info_sheet.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../const/colors.dart';
import '../model/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final Schedule scheduleInfo;
  final Color color;
  final OnDaySelected? onDaySelected;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.scheduleInfo,
    required this. color,
    required this.onDaySelected,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) {
            return ScheduleInfoSheet(
                scheduleInfo: scheduleInfo
            );
          },
        ).whenComplete(() => onDaySelected != null ? onDaySelected!(startTime, endTime) : null);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: PRIMARY_COLOR,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Time(startTime: startTime, endTime: endTime),
                SizedBox(width: 16.0,),
                _Content(scheduleInfo: scheduleInfo),
                SizedBox(width: 16.0,),
                _Category(
                  color: color,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat("yyyy-MM-dd").format(startTime),
          // '${startTime.toString()}',
          style: textStyle,
        ),
        Row(
          children: [
            Text(
              DateFormat("HH:mm").format(startTime),
              style: textStyle.copyWith(
                  color: Colors.blue
              ),
            ),
            Text(" ~ "),
            Text(
              DateFormat("HH:mm").format(endTime),
              style: textStyle.copyWith(
                color: Colors.blue
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _Content extends StatelessWidget {
  final Schedule scheduleInfo;

  const _Content({
    required this.scheduleInfo,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15.0,
    );

    return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scheduleInfo.lessonName,
              style: textStyle,
            ),
            Text(
              scheduleInfo.status,
              style: textStyle,
            ),
          ],
        )
    );
  }
}


class _Category extends StatelessWidget {
  final Color color;

  const _Category({
    required this.color,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: 16.0,
      height: 16.0,
    );
  }
}
