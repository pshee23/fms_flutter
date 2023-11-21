class Member {
  final int memberId;
  final String name;

  final int employeeId;

  final String address;
  final String phoneNumber;

  final String status;

  Member(
      this.memberId,
      this.name,
      this.employeeId,
      this.address,
      this.phoneNumber,
      this.status,
  );

  set name(String name) {
    this.name = name;
  }

  set phoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  Member.fromJson(Map<String, dynamic> json):
        memberId = int.parse("${json['memberId'] ?? '0'}"),
        name = json['name'] ?? 'ERROR?',
        employeeId = int.parse("${json['employeeId'] ?? '0'}"),
        address = json['address'] ?? 'ERROR?',
        phoneNumber = json['phoneNumber'] ?? 'ERROR?',
        status = json['status'] ?? 'ERROR?';

  Map<String, dynamic> toJson() => {
    'memberId' : memberId,
    'name' : name,
    'employeeId' : employeeId,
    'address' : address,
    'phoneNumber' : phoneNumber,
    'status' : status,
  };

  @override
  String toString() =>
      'memberId=$memberId, '
      'name=$name, '
      'employeeId=$employeeId, '
      'address=$address, '
      'phoneNumber=$phoneNumber, '
      'status=$status';
}