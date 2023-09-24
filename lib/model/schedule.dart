
class Schedule {
    int lessonHistoryId;
    int lessonId;
    int memberId;
    int employeeId;
    DateTime startDateTime;
    DateTime endDateTime;
    // int colorId;
    String status;
    // DateTime updateDateTime;

    Schedule({
      required this.lessonHistoryId,
      required this.lessonId,
      required this.memberId,
      required this.employeeId,
      required this.startDateTime,
      required this.endDateTime,
      required this.status,
      // required this.colorId,
      // required this.updateDateTime
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      lessonHistoryId: json['lessonHistoryId'],
      employeeId: json['employeeId'],
      memberId: json['memberId'],
      lessonId: json['lessonId'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      status: json['status'],
      // colorId: 1,
      // updateDateTime: DateTime.now()
    );
  }

  Map<String, dynamic> toJson() => {
    'lessonId' : lessonId,
    'memberId' : memberId,
    'employeeId' : employeeId,
    'startDateTime' : startDateTime.toIso8601String(),
    'endDateTime' : endDateTime.toIso8601String(),
    'status' : status,
    // 'colorId' : colorId,
    // 'updateDateTime' : updateDateTime.toIso8601String(),
  };

  @override
  String toString() =>
      'lessonId=$lessonId, '
          'memberId=$memberId, '
          'employeeId=$employeeId, '
          'startDateTime=$startDateTime, '
          'endDateTime=$endDateTime, '
          'status=$status, ';
          // 'colorId=$colorId, '
          // 'updateDateTime=$updateDateTime';
}