import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../locator/locator.dart';
import '../model/schedule.dart';
import '../service/http_service.dart';

class ScheduleInfoSheet extends StatelessWidget {
  final Schedule scheduleInfo;

  const ScheduleInfoSheet({
    required this.scheduleInfo,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final HttpService httpService = locator<HttpService>();

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
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
                  label: '상태', value: scheduleInfo.status,
                ),
                _TextBox(
                  label: '수업명', value: scheduleInfo.lessonName,
                ),
                _TextBox(
                  label: '강사', value: scheduleInfo.employeeName,
                ),
                _TextBox(
                  label: '수강생', value: scheduleInfo.memberName,
                ),
                _TextBox(
                  label: '시작 시간', value: DateFormat("yyyy-MM-dd hh:mm:ss").format(scheduleInfo.startDateTime),
                ),
                _TextBox(
                  label: '종료 시간', value: DateFormat("yyyy-MM-dd hh:mm:ss").format(scheduleInfo.endDateTime),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        // TODO 수업 완료한건 삭제 못하도록
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("수업 상태 변경"),
                                content: const Text("수업을 삭제하시겠습니까?"),
                                actions: <Widget>[
                                  ElevatedButton(onPressed: () {
                                    httpService.updateScheduleStatus(scheduleInfo.lessonHistoryId, "DELETED");
                                    Navigator.pop(context);Navigator.pop(context);
                                  }, child: const Text("네")),
                                  ElevatedButton(onPressed: () {Navigator.pop(context);},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: const Text("아니요"),
                                  ),
                                ],
                              );
                            }
                        );
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
                        // TODO 수업 완료한건 취소 못하도록
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("수업 상태 변경"),
                                content: const Text("수업을 취소하시겠습니까?"),
                                actions: <Widget>[
                                  ElevatedButton(onPressed: () {
                                    httpService.updateScheduleStatus(scheduleInfo.lessonHistoryId, "CANCELED");
                                    Navigator.pop(context);Navigator.pop(context);
                                  }, child: const Text("네")),
                                  ElevatedButton(onPressed: () {Navigator.pop(context);},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: const Text("아니요"),
                                  ),
                                ],
                              );
                            }
                        );
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
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("수업 상태 변경"),
                                content: const Text("수업 완료로 변경하시겠습니까?"),
                                actions: <Widget>[
                                  ElevatedButton(onPressed: () {
                                    httpService.updateScheduleStatus(scheduleInfo.lessonHistoryId, "FINISHED");
                                    Navigator.pop(context);Navigator.pop(context);
                                  }, child: const Text("네")),
                                  ElevatedButton(onPressed: () {Navigator.pop(context);}, 
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: const Text("아니요"),
                                  ),
                                ],
                              );
                            }
                        );
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