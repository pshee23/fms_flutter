
import 'package:flutter/material.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {

  String name = "박세희";
  String phoneNumber = "010-1234-5678";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(35.0),
          child: Text(
            "내 정보",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        _TextBox(label: '이름', value: name),
        _TextBox(label: '전화 번호', value: phoneNumber),
      ],
    );
  }
}

class _TextBox extends StatelessWidget {
  final String label;
  final String value;

  const _TextBox({
    required this.label,
    required this.value,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
            Expanded(child: Text(value)),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () {  },)
          ],
        ),
      ),
    );
  }
}
