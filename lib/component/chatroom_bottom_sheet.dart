import 'package:fms/const/colors.dart';
import 'package:fms/locator/locator.dart';
import 'package:flutter/material.dart';
import '../model/Member.dart';
import '../model/chat_room.dart';
import '../service/http_chat.dart';
import 'member_alert_dialog.dart';

class ChatroomBottomSheet extends StatefulWidget {

  const ChatroomBottomSheet({
    Key? key}) : super(key: key);

  @override
  State<ChatroomBottomSheet> createState() => _ChatroomBottomSheetState();
}

class _ChatroomBottomSheetState extends State<ChatroomBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? memberId;
  var memberName;
  int? employeeId;

  final HttpChat _chatService = locator<HttpChat>();

  @override
  Widget build(BuildContext context) {
    // 키보드의 높이
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // 빈 공간 누르면 키보드 내려가도록
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MemberAlertDialog(
                      memberResult: (Member member) {
                        print("@@@@@@@@@@@@@@ memberResult=$member");
                        memberId = member.memberId;
                        memberName = member.name;
                        employeeId = member.employeeId;
                      },
                    ),
                    SizedBox(height: 16.0),
                    _SaveButton(
                      onPressed: onSavedPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavedPressed() async {
    // formKey는 생성을 했는데, Form 위젯과 결합을 안했을 때
    if(formKey.currentState == null) {

    }

    // validate를 실행하면 모든 form 필드의 validator가 실행되고 에러가 있으면 String 리턴, 없으면 null
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Future<ChatRoom> chatRoom = _chatService.createChatRoom(memberName, memberId);
      print('create chatRoom ?! $chatRoom');
      Navigator.pop(context);
    } else {
      print("create chatRoom 에러가 있습니다");
    }
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                child: Text('저장')
            )
        ),
      ],
    );
  }
}