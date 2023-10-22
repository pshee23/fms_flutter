class Lesson {
  final int lessonId;
  final String lessonName;

  final int memberId;
  final String memberName;

  final int employeeId;
  final String employeeName;

  final int totalCount;
  final int currentCount;

  final DateTime startDateTime;
  final DateTime endDateTime;

  Lesson(
      this.lessonId,
      this.lessonName,
      this.memberId,
      this.memberName,
      this.employeeId,
      this.employeeName,
      this.totalCount,
      this.currentCount,
      this.startDateTime,
      this.endDateTime,
  );

  Lesson.fromJson(Map<String, dynamic> json):
        lessonId = int.parse("${json['lessonId'] ?? '0'}"),
        lessonName = json['lessonName'],
        memberId = int.parse("${json['memberId'] ?? '0'}"),
        memberName = json['memberName'] ?? 'ERROR?',
        employeeId = int.parse("${json['employeeId'] ?? '0'}"),
        employeeName = json['employeeName'] ?? 'ERROR?',
        totalCount = int.parse("${json['totalCount'] ?? '0'}"),
        currentCount = int.parse("${json['currentCount'] ?? '0'}"),
        startDateTime = DateTime.parse(json['startDateTime']),
        endDateTime = DateTime.parse(json['endDateTime']);

  Map<String, dynamic> toJson() => {
    'lessonId' : lessonId,
    'lessonName' : lessonName,
    'memberId' : memberId,
    'memberName' : memberName,
    'employeeId' : employeeId,
    'employeeName' : employeeName,
    'totalCount' : totalCount,
    'currentCount' : currentCount,
    'startDateTime' : startDateTime,
    'endDateTime' : endDateTime,
  };

  @override
  String toString() =>
      'lessonId=$lessonId, '
      'lessonName=$lessonName, '
      'memberId=$memberId, '
      'memberName=$memberName, '
      'employeeId=$employeeId, '
      'employeeName=$employeeName, '
      'totalCount=$totalCount, '
      'currentCount=$currentCount, '
      'startDateTime=$startDateTime, '
      'endDateTime=$endDateTime';
}