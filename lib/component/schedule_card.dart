import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../const/colors.dart';
import '../model/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final Schedule scheduleInfo;
  final Color color;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.scheduleInfo,
    required this. color,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
            builder: (BuildContext context) {
              return _ScheduleInfo(
                  scheduleInfo: scheduleInfo
              );
            }
        );
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

class _ScheduleInfo extends StatelessWidget {
  final Schedule scheduleInfo;

  const _ScheduleInfo({
    required this.scheduleInfo,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // TODO Size control, data input
      content: Column(
        children: [
          Text('schedule name: ${scheduleInfo.lessonId}'),
          Text('employee name: ${scheduleInfo.employeeId}'),
          Text('member name: ${scheduleInfo.memberId}'),
          Text('schedule start: ${scheduleInfo.startDateTime}'),
          Text('schedule end: ${scheduleInfo.endDateTime}'),
          Text('schedule status: ${scheduleInfo.status}'),
        ],
      ),
      insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
      actions: [
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
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
              DateFormat("hh:mm:ss").format(startTime),
              // '${endTime.toString()}',
              style: textStyle.copyWith(
                  color: Colors.blue
              ),
            ),
            Text(" ~ "),
            Text(
              DateFormat("hh:mm:ss").format(endTime),
              // '${endTime.toString()}',
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
              'lesson number: ${scheduleInfo.lessonId}', // TODO return lesson name
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
