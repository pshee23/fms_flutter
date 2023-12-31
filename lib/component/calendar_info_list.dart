import 'package:fms/component/schedule_card.dart';
import 'package:fms/component/today_banner.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../locator/locator.dart';
import '../model/schedule.dart';
import '../service/http_service.dart';

class CalendarInfoList extends StatelessWidget {
  final DateTime selectedDay;
  final OnDaySelected? onDaySelected;

  const CalendarInfoList({
    required this.selectedDay,
    required this.onDaySelected,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = locator<HttpService>();

    return FutureBuilder(
        future: httpService.fetchSchedules(selectedDay),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData == false) {
            return Column(
              children: [
                TodayBanner(
                    selectedDay: selectedDay,
                    scheduleCount: 0
                ),
                const SizedBox(height: 8.0,),
                Text("No Schedule"),
              ],
            );
          }

          if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          List<Schedule> scheduleList = snapshot.data;
          return Column(
            children: [
              TodayBanner(
                  selectedDay: selectedDay,
                  scheduleCount: scheduleList.length
              ),
              const SizedBox(height: 8.0,),
              ListView.separated(
                  itemCount: scheduleList.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8.0,);
                  }, // item 사이에 이루어지는 Builder
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    final scheduleInfo = scheduleList[index];
                    return ScheduleCard(
                      startTime: scheduleInfo.startDateTime,
                      endTime: scheduleInfo.endDateTime,
                      scheduleInfo: scheduleInfo,
                      color: Colors.red,
                      onDaySelected: onDaySelected,
                    );
                  }),
            ],
          );
        }
    );
  }
}