class Lesson {
  final int lessonId;
  final int memberId;
  final int employeeId;

  final int totalCount;
  final int currentCount;

  final DateTime startDateTime;
  final DateTime endDateTime;

  Lesson(
      this.lessonId,
      this.memberId,
      this.employeeId,
      this.totalCount,
      this.currentCount,
      this.startDateTime,
      this.endDateTime,
      );

  Lesson.fromJson(Map<String, dynamic> json):
        lessonId = int.parse("${json['lessonId'] ?? '0'}"),
        memberId = int.parse("${json['memberId'] ?? '0'}"),
        employeeId = int.parse("${json['employeeId'] ?? '0'}"),
        totalCount = int.parse("${json['totalCount'] ?? '0'}"),
        currentCount = int.parse("${json['currentCount'] ?? '0'}"),
        startDateTime = DateTime.parse(json['startDateTime']),
        endDateTime = DateTime.parse(json['endDateTime']);

  Map<String, dynamic> toJson() => {
    'lessonId' : lessonId,
    'memberId' : memberId,
    'employeeId' : employeeId,
    'totalCount' : totalCount,
    'currentCount' : currentCount,
    'startDateTime' : startDateTime,
    'endDateTime' : endDateTime,
  };

  @override
  String toString() =>
      'lessonId=$lessonId, '
      'memberId=$memberId, '
      'employeeId=$employeeId, '
      'totalCount=$totalCount, '
      'currentCount=$currentCount, '
      'startDateTime=$startDateTime, '
      'endDateTime=$endDateTime';
}