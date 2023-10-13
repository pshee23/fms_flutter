import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../locator/locator.dart';
import '../model/schedule.dart';
import '../service/http_service.dart';

class ScheduleInfoSheet extends StatefulWidget {
  final Schedule scheduleInfo;

  const ScheduleInfoSheet({
    required this.scheduleInfo,
    Key? key}) : super(key: key);

  @override
  State<ScheduleInfoSheet> createState() => _ScheduleInfoSheetState();
}

class _ScheduleInfoSheetState extends State<ScheduleInfoSheet> {

  final HttpService _httpService = locator<HttpService>();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // 빈 공간 누르면 키보드 내려가도록
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInset + 150,
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 30.0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                      '레슨 정보',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusBox(
                  label: '상태', value: widget.scheduleInfo.status,
                ),
                _TextBox(
                  label: '수업명', value: widget.scheduleInfo.lessonName,
                ),
                _TextBox(
                  label: '강사', value: widget.scheduleInfo.employeeName,
                ),
                _TextBox(
                  label: '수강생', value: widget.scheduleInfo.memberName,
                ),
                _TextBox(
                  label: '시작 시간', value: DateFormat("yyyy-MM-dd hh:mm:ss").format(widget.scheduleInfo.startDateTime),
                ),
                _TextBox(
                  label: '종료 시간', value: DateFormat("yyyy-MM-dd hh:mm:ss").format(widget.scheduleInfo.endDateTime),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        _httpService.updateScheduleStatus(widget.scheduleInfo.lessonHistoryId, "DELETED");
                      },
                      label: Text('수업 삭제'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: Size(20, 50),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      icon: Icon(Icons.cancel),
                      onPressed: (){
                        _httpService.updateScheduleStatus(widget.scheduleInfo.lessonHistoryId, "CANCELED");
                      },
                      label: Text('수업 취소'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: Size(20, 50),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      onPressed: (){
                        _httpService.updateScheduleStatus(widget.scheduleInfo.lessonHistoryId, "FINISHED");
                      },
                      label: Text('수업 완료'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        minimumSize: Size(20, 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatusBox({
    required this.label,
    required this.value,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 20,
                child: Text(
                  label,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  status(value),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3.0,),
          const Divider(thickness: 1, height: 1, color: Colors.grey),
        ],
      ),
    );
  }

  status(value) {
    switch(value){
      case 'FINISHED':
        return '수업완료';
      case 'RESERVE':
        return '수업전';
      case 'CANCELED':
        return '취소됨';
      case 'DELETED':
        return '삭제됨';
      default:
        return '수업전';
    }
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 20,
                child: Text(
                  label,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0,),
          const Divider(thickness: 1, height: 1, color: Colors.grey),
        ],
      ),
    );
  }
}
