import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../locator/locator.dart';
import '../model/Member.dart';
import '../service/http_service.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({
    Key? key}) : super(key: key);

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final formKey = GlobalKey<FormState>();
  final HttpService _httpService = locator<HttpService>();

  Future<Member>? member;
  bool isChange = false;

  // TODO get Member/Employee Info

  @override
  Widget build(BuildContext context) {
    member = _httpService.fetchPersonalInfo();

    return FutureBuilder(
      future: member,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const Text('No DATA');
        }

        Member? member = snapshot.data;

        return Form(
          key: formKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(35.0),
                child: Text(
                  "개인 정보",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
              ),
              Container(
                color: Colors.pink,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit,size: 18,color: Colors.grey,),
                      onPressed: () {
                        print("onPressed changeMode");
                        changeMode();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.save ,size: 18,color: Colors.grey,),
                      onPressed: () {
                        print("onPressed saveMode");
                        saveMode();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined ,size: 18,color: Colors.grey,),
                      onPressed: () {
                        print("onPressed cancel");
                        changeMode();
                      },
                    )
                  ],
                ),
              ),
              _ManageInfo(isChange : isChange, label: '이름', value: member!.name, onSaved: (val){
                print("???? onSaved? name");
                // tmpName = val;
              },),
              _ManageInfo(isChange : isChange, label: '전화 번호', value: member!.phoneNumber, onSaved: (val){
                print("???? onSaved? phone");
                // tmpPhoneNum = val;
              },),
            ],
          ),
        );
      },
    );
  }

  changeMode() {
    setState(() {
      print("&&&&&&&&&&");
      isChange = (isChange == true) ? false : true;
    });
  }

  saveMode() {
    setState(() {
      print("saveMode setState");
      // TODO send save and edit value and change to changeMode
      isChange = (isChange == true) ? false : true;
      if (formKey.currentState!.validate()) {
        // validation 이 성공하면 true 가 리턴돼요!

        // validation 이 성공하면 폼 저장하기
        formKey.currentState!.save();

        Get.snackbar(
          '저장완료!',
          '폼 저장이 완료되었습니다!',
          backgroundColor: Colors.white,
        );
      }
    });
  }
}

class _ManageInfo extends StatelessWidget {
  final bool isChange;
  final String label;
  final String value;
  final FormFieldSetter onSaved;

  const _ManageInfo({
    required this.isChange,
    required this.label,
    required this.value,
    required this.onSaved,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          Expanded(
            child: TextFormField(
              readOnly: (isChange == false) ? true : false,
              onSaved: onSaved,
              initialValue: value,
              decoration: (isChange == false)
                  ? const InputDecoration(filled: false,)
                  : const InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}