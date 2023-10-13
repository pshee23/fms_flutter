
class Schedule {
    int lessonHistoryId;
    int lessonId;
    String lessonName;
    int memberId;
    String memberName;
    int employeeId;
    String employeeName;
    DateTime startDateTime;
    DateTime endDateTime;
    // int colorId;
    String status;
    // DateTime updateDateTime;

    Schedule({
      required this.lessonHistoryId,
      required this.lessonId,
      required this.lessonName,
      required this.memberId,
      required this.memberName,
      required this.employeeId,
      required this.employeeName,
      required this.startDateTime,
      required this.endDateTime,
      required this.status,
      // required this.colorId,
      // required this.updateDateTime
  });
// TODO fromJson시 데이터가 null이면 작동을 안함..
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      lessonHistoryId: json['lessonHistoryId'],
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      memberId: json['memberId'],
      memberName: json['memberName'],
      lessonId: json['lessonId'],
      lessonName: json['lessonName'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      status: json['status'],
      // colorId: 1,
      // updateDateTime: DateTime.now()
    );
  }

  Map<String, dynamic> toJson() => {
    'lessonHistoryId' : lessonHistoryId,
    'lessonId' : lessonId,
    'lessonName' : lessonName,
    'memberId' : memberId,
    'memberName' : memberName,
    'employeeId' : employeeId,
    'employeeName' : employeeName,
    'startDateTime' : startDateTime.toIso8601String(),
    'endDateTime' : endDateTime.toIso8601String(),
    'status' : status,
    // 'colorId' : colorId,
    // 'updateDateTime' : updateDateTime.toIso8601String(),
  };

  @override
  String toString() =>
      'lessonHistoryId=$lessonHistoryId, '
      'lessonId=$lessonId, '
          'lessonName=$lessonName, '
          'memberId=$memberId, '
          'memberName=$memberName, '
          'employeeId=$employeeId, '
          'employeeName=$employeeName, '
          'startDateTime=$startDateTime, '
          'endDateTime=$endDateTime, '
          'status=$status, ';
          // 'colorId=$colorId, '
          // 'updateDateTime=$updateDateTime';
}