import 'package:fms/const/colors.dart';
import 'package:fms/locator/locator.dart';
import 'package:flutter/material.dart';

import '../model/category_colors.dart';
import '../service/color_service.dart';
import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({
    required this.selectedDate,
    Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  final ColorService _colorService = locator<ColorService>();

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
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
                      onStartSaved: (String? val) {
                        startTime = int.parse(val!);
                      },
                      onEndSaved: (String? val) {
                        endTime = int.parse(val!);
                      },
                    ),
                    SizedBox(height: 16.0),
                    _Content(
                      onSaved: (String? val) {
                        content = val;
                      },
                    ),
                    SizedBox(height: 16.0),
                    FutureBuilder<List<CategoryColors>>(
                        future: _colorService.fetchCategoryColors(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData && selectedColorId == null && snapshot.data!.isNotEmpty) {
                            selectedColorId = snapshot.data![0].colorId;
                          }
                          return _ColorPicker(
                            colors: snapshot.hasData
                                ? snapshot.data! : [],
                            selectedColorId: selectedColorId,
                            colorIdSetter: (int id){
                              setState(() {
                                selectedColorId = id;
                              });
                            },
                          );
                        }
                    ),
                    SizedBox(height: 8.0),
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

  void onSavedPressed() {
    // formKey는 생성을 했는데, Form 위젯과 결합을 안했을 때
    if(formKey.currentState == null) {

    }

    // validate를 실행하면 모든 form 필드의 validator가 실행되고 에러가 있으면 String 리턴, 없으면 null
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      print('startTime=$startTime');
    } else {
      print("에러가 있습니다");
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
              lable: '시작 시간',
              isTime: true,
              onSaved: onStartSaved,
            )
        ),
        SizedBox(width: 16.0,),
        Expanded(
            child: CustomTextField(
              lable: '마감 시간',
              isTime: true,
              onSaved: onEndSaved,
            )
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _Content({
    required this.onSaved,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        lable: '내용',
        isTime: false,
        onSaved: onSaved,
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColors> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors.map((e) =>
          GestureDetector(
              onTap: () {
                colorIdSetter(e.colorId!);
              },
              child: renderColor(
                  e,
                  selectedColorId == e.colorId
              )
          )
      ).toList(),
    );
  }

  Widget renderColor(CategoryColors color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(int.parse('FF${color.hexCode}', radix: 16)),
          border: isSelected ? Border.all(
            color: Colors.black,
            width: 4.0,
          ) : null
      ),
      width: 32.0,
      height: 32.0,
    );
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
