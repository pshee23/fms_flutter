import 'package:flutter/material.dart';

import '../const/colors.dart';

class ScheduleCard extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final Color color;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.status,
    required this. color,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              _Content(content: status),
              SizedBox(width: 16.0,),
              _Category(
                color: color,
              )
            ],
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
          // '${startTime.toString().padLeft(2, '0')}:00',
          '${startTime.toString()}',
          style: textStyle,
        ),
        Text(
            // '${endTime.toString().padLeft(2, '0')}:00',
          '${endTime.toString()}',
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}


class _Content extends StatelessWidget {
  final String content;

  const _Content({
    required this.content,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Text(content)
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
