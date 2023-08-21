import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final formKey = GlobalKey<FormState>();

  String id = '';
  String password ='';
  String name = '';
  String address = '';
  String phoneNumber = '';
  String branchId = '';
  String employeeId = '';
  String role = '';

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        Container(
          height: 25.0,
        ),
      ],
    );
  }

  Future join() async {
    var data = {
      "name" : name,
      "address" : address,
      "phoneNumber" : phoneNumber,
      "branchId" : branchId,
      "employeeId" : employeeId,
      "loginId" : id,
      "loginPw" : password,
      "role" : role
    };
    var body = json.encode(data);
    final uri = Uri.http('192.168.42.1:8080', '/join'); // local test라도 ip를 직접 입력해야지 됨

    var res = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: body
    );
    print(res.body);
    print(res.statusCode);
    // TODO ip 잘못되면 아무 반응없던데 어떻게 해결?
    if(res.statusCode == 200) {
      print("success");
      Get.snackbar(
        '가입 완료!',
        '회원 가입이 완료되었습니다',
        backgroundColor: Colors.white,
      );
    } else {
      print("fail..");
      Get.snackbar(
        '가입 실패!',
        '서버 에러 발생',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  registerButton() {
    return ElevatedButton(
      onPressed: () async {
        if(formKey.currentState!.validate()) {
          // 폼 저장
          formKey.currentState!.save();
          join();
        } else {
          Get.snackbar(
            '가입 실패!',
            '입력 항목을 확인해주세요',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: Text('회원 가입'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('회원 가입'),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                children: [
                  renderTextFormField(
                    label: 'ID',
                    onSaved: (val) {
                      setState(() {
                        id = val;
                      });
                    },
                    validator: (val) {
                      if(val.length < 2) {
                        return 'ID를 2자 이상 입력하세요.';
                      }
                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: 'PASSWORD',
                    onSaved: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (val) {
                      if(val.length < 8) {
                        return 'Password를 8자 이상 입력하세요.';
                      }
                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: 'NAME',
                    onSaved: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                    validator: (val) {
                      if(val.length < 2) {
                        return '이름은 필수 사항입니다.';
                      }
                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: 'ADDRESS',
                    onSaved: (val) {
                      setState(() {
                        address = val;
                      });
                    },
                    validator: (val) {
                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: 'PHONE NUMBER',
                    onSaved: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                    validator: (val) {
                      if(val.length < 8) {
                        return '전화번호는 필수 사항입니다.';
                      }
                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: 'BRANCH ID',
                    onSaved: (val) {
                      setState(() {
                        branchId = val;
                      });
                    },
                    validator: (val) {
                      if(val.length < 1) {
                        return '지점은 필수 사항입니다.';
                      }
                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: 'EMPLOYEE ID',
                    onSaved: (val) {
                      setState(() {
                        employeeId = val;
                      });
                    },
                    validator: (val) {
                      if(val.length < 1) {
                        return '직원 입력은 필수 사항입니다.';
                      }
                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: 'ROLE',
                    onSaved: (val) {
                      setState(() {
                        role = val;
                      });
                    },
                    validator: (val) {
                      if(val.length < 1) {
                        return '역할은 필수 사항입니다.';
                      }
                      return null;
                    },
                  ),
                  registerButton(),
                ],
              ),
            ),
          ),
        ));
  }
}

class ResponseVO {

}