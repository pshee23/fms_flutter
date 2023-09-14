
class Schedules {
    int lessonId;
    // int memberId;
    DateTime startDateTime;
    // private int totalCount;
    // private int currentCount;
    DateTime endDateTime;
    //
    int colorId;
    String content;
    DateTime createDateTime;

    Schedules({
      required this.lessonId,
      required this.startDateTime,
      required this.endDateTime,
      required this.content,
      required this.colorId,
      required this.createDateTime
  });
}