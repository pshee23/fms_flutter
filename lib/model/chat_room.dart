class ChatRoom {
  final String roomId;
  final String title;
  final String toId;
  final String fromId;

  ChatRoom(this.roomId, this.title, this.toId, this.fromId);

  ChatRoom.fromJson(Map<String, dynamic> json):
        roomId = json['roomId'],
        title = json['title'],
        toId = json['toId'],
        fromId = json['fromId'];

  Map<String, dynamic> toJson() => {
    'roomId' : roomId,
    'title' : title,
    'toId' : toId,
    'fromId' : fromId,
  };

  @override
  String toString() =>
      'roomId=$roomId, '
      'title=$title, '
      'toId=$toId, '
      'fromId=$fromId';
}