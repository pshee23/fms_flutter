
import 'package:fms/model/schedule.dart';

class ScheduleResponse {
    int code;
    String message;
    List<Schedule> lessonHistoryInfoList;

    ScheduleResponse({
      required this.code,
      required this.message,
      required this.lessonHistoryInfoList,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    print('0000000000. json=$json');
    List<Map<String, dynamic>> scheduleDynamic = json['lessonHistoryInfoList'];
    print('1111111111. result=$scheduleDynamic');
    List<Schedule> listdatas = [];
    for (int i = 0; i < scheduleDynamic.length; i++) {
      listdatas.add(Schedule.fromJson(scheduleDynamic[i]));
    }
    print('222222222222 . listdatas=$listdatas');
    return ScheduleResponse(
        code: json['code'],
        message: json['message'],
        lessonHistoryInfoList: listdatas
    );
  }

  Map<String, dynamic> toJson() => {
    'code' : code,
    'message' : message,
    'lessonHistoryInfoList' : lessonHistoryInfoList
  };

  @override
  String toString() =>
      'code=$code, '
          'message=$message, '
          'lessonHistoryInfoList=$lessonHistoryInfoList';
}