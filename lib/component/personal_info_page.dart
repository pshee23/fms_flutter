import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  final String name;
  final String phoneNumber;
  
  const PersonalInfoPage({
    required this.name, 
    required this.phoneNumber,
    Key? key}) : super(key: key);

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(35.0),
          child: Text(
            "개인 정보",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        _ManageInfo(label: '이름', value: widget.name),
        _ManageInfo(label: '전화 번호', value: widget.phoneNumber),
      ],
    );
  }
}

class _ManageInfo extends StatefulWidget {
  final String label;
  final String value;

  const _ManageInfo({
    required this.label,
    required this.value,
    Key? key}) : super(key: key);

  @override
  State<_ManageInfo> createState() => _ManageInfoState();
}

class _ManageInfoState extends State<_ManageInfo> {
  bool isChange = false;

  @override
  Widget build(BuildContext context) {
    return (isChange == false) ?
        _TextBox(label: widget.label, value: widget.value, changeMode: changeMode)
        : _EditBox(label: widget.label, value: widget.value,);
  }

  changeMode() {
    setState(() {
      print("&&&&&&&&&&");
      isChange = (isChange == true) ? false : true;
    });
  }
}

class _TextBox extends StatelessWidget {
  final String label;
  final String value;
  final ChangeMode? changeMode;

  const _TextBox({
    required this.label,
    required this.value,
    required this.changeMode,
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
              onPressed: () {
                print("#######");
                changeMode;
              },
            )
          ],
        ),
      ),
    );
  }
}

class _EditBox extends StatelessWidget {
  final String label;
  final String value;
  const _EditBox({
    required this.label,
    required this.value,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("????");
  }
}
