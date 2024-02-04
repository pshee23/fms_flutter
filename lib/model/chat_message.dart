class ChatMessage {
  final String type;
  final String roomId;
  final String sender;
  final String content;

  ChatMessage(this.type, this.roomId, this.sender, this.content);

  ChatMessage.fromJson(Map<String, dynamic> json):
        type = json['type'],
        roomId = json['roomId'],
        sender = json['sender'],
        content = json['content'];

  Map<String, dynamic> toJson() => {
    'type' : type,
    'roomId' : roomId,
    'sender' : sender,
    'content' : content,
  };

  @override
  String toString() =>
      'type=$type, '
      'roomId=$roomId, '
      'sender=$sender, '
      'content=$content';
}