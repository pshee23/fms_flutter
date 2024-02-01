class ChatRoom {
  final String roomId;
  final String name;
  final String employeeId;
  final String memberId;

  ChatRoom(this.roomId, this.name, this.employeeId, this.memberId);

  ChatRoom.fromJson(Map<String, dynamic> json):
        roomId = json['roomId'],
        name = json['name'],
        employeeId = json['employeeId'],
        memberId = json['memberId'];

  Map<String, dynamic> toJson() => {
    'roomId' : roomId,
    'name' : name,
    'employeeId' : employeeId,
    'memberId' : memberId,
  };

  @override
  String toString() =>
      'roomId=$roomId, '
      'name=$name, '
      'employeeId=$employeeId, '
      'memberId=$memberId';
}