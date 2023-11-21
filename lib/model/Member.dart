class Member {
  int memberId;
  String name;

  int employeeId;

  String address;
  String phoneNumber;

  String status;

  Member(
      this.memberId,
      this.name,
      this.employeeId,
      this.address,
      this.phoneNumber,
      this.status,
  );

  void setName(String val) {
    name = val;
  }

  set setPhoneNumber(String val) => val;

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