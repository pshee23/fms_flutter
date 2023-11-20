
import 'package:flutter/material.dart';
import 'package:fms/component/personal_info_page.dart';

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
    return PersonalInfoPage(
        name: name,
        phoneNumber: phoneNumber
    );
  }
}