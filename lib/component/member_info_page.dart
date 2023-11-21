import 'package:flutter/material.dart';
import 'package:fms/component/personal_info_page.dart';

import '../model/Member.dart';

class MemberInfoPage extends StatelessWidget {
  final Member eachMember;

  const MemberInfoPage({
    required this.eachMember,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "회원 정보",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: PersonalInfoPage(),
    );
  }
}
