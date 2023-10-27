import 'dart:collection';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fms/model/category_colors.dart';
import 'package:http/http.dart' as http;

import '../model/Lesson.dart';
import '../model/schedule.dart';

abstract class HttpService {
  Future<List<CategoryColors>> fetchCategoryColors();

  Future<int> createLessonHistory(schedule);

  void logout(username);

  Future<List<Schedule>> fetchSchedules(datetime);

  Future<Map<DateTime, List<String>>> fetchMonthlySchedule(datetime);

  void updateScheduleStatus(lessonHistoryId, status);

  void fetchId(isEmployee, loginId);

  Future<List<Lesson>> fetchLessonsByEmployee();
}

class HttpServiceImplementation implements HttpService {

  static final storage = FlutterSecureStorage();
  String serverUrl = dotenv.get('SERVER_URL');

  @override
  logout(username) async {
    var data = {
      "username" : username,
    };
    final uri = Uri.http(serverUrl, '/api/logout', data);
    http.put(uri);
    await storage.delete(key: 'login');
  }

  @override
  Future<List<Schedule>> fetchSchedules(datetime) async {
    DateTime dateTime = datetime;
    final id = await storage.read(key: 'id');
    final isEmployee = await storage.read(key: 'isEmployee');
    print('watchSchedules. date=$datetime, id=$id, isEmployee=$isEmployee');
    var path = 'member';
    if(isEmployee == 'true') {
      path = 'employee';
    }
    var url = '/lesson-history/$path/$id/datetime/${dateTime.year}/${dateTime.month}/${dateTime.day}';
    print('fetch schedules get. url=$url');
    final uri = Uri.http(serverUrl, url);
    final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'toyProject1234'
        },
    );

    var code = response.statusCode;
    print('get Lesson-History list. code=$code, body=${response.body}');

    final List<Schedule> result = jsonDecode(response.body)
        .map<Schedule>((json) => Schedule.fromJson(json)).toList();
    print('get list body. result=$result');
    return result;
  }

  @override
  Future<Map<DateTime, List<String>>> fetchMonthlySchedule(datetime) async {
    DateTime dateTime = datetime;
    final id = await storage.read(key: 'id');
    final isEmployee = await storage.read(key: 'isEmployee');
    print('fetchMonthlySchedule. date=$datetime, id=$id, isEmployee=$isEmployee');
    var path = 'member';
    if(isEmployee == 'true') {
      path = 'employee';
    }
    var url = '/lesson-history/$path/$id/datetime/${dateTime.year}/${dateTime.month}';
    print('fetch schedules get. url=$url');
    final uri = Uri.http(serverUrl, url);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'toyProject1234'
      },
    );

    var code = response.statusCode;
    print('get Lesson-History list. code=$code, body=${response.body}');

    final Map<String, dynamic> result = jsonDecode(response.body);
    Map<DateTime, List<String>> resultMap = new HashMap<DateTime, List<String>>();
    result.forEach((key, value) {
      resultMap[DateTime.parse(key).toUtc()] = List<String>.from(value);
    });
    print('get monthly list body. result=$resultMap');

    return resultMap;
  }

  @override
  Future<List<CategoryColors>> fetchCategoryColors() async {
    final uri = Uri.http(serverUrl, '/colors');
    final response = await http.get(uri);
    final List<CategoryColors> result = jsonDecode(response.body)
        .map<CategoryColors>((json) => CategoryColors.fromJson(json)).toList();
    return result;
  }

  @override
  Future<int> createLessonHistory(schedule) async {
    print('createLessonHistory. body=$schedule');
    final uri = Uri.http(serverUrl, '/lesson-history');
    var body = json.encode(schedule.toJson());
    final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body
    );

    var code = response.statusCode;
    print('create Lesson-History. code=$code');
    return code;
  }

  @override
  updateScheduleStatus(lessonHistoryId, status) async {
    final uri = Uri.http(serverUrl, 'lesson-history/$lessonHistoryId/status/$status');
    print('update status. uri=$uri');
    http.put(uri);
  }

  @override
  void fetchId(isEmployee, loginId) async {
    print('fetchId. isEmployee=$isEmployee, loginId=$loginId');

    String path = 'member';
    if(isEmployee == true) {
      path = 'employee';
    }
    final uri = Uri.http(serverUrl, '/$path/$loginId');
    final response = await http.get(uri);

    var code = response.statusCode;
    print('fetchId result. code=$code, body=${response.body}');
    storage.write(key: 'id', value: response.body,);
    storage.write(key: 'isEmployee', value: isEmployee.toString(),);
  }

  @override
  Future<List<Lesson>> fetchLessonsByEmployee() async {
    final id = await storage.read(key: 'id');
    final uri = Uri.http(serverUrl, '/lesson/list/employee/$id');
    return _fetchLessons(uri);
  }

  Future<List<Lesson>> _fetchLessons(uri) async {
    print('fetchLessons request. uri=$uri');
    final response = await http.get(uri);

    print('fetchLessons response.body=${response.body}');
    List<Lesson> resultList = [];
    final List<dynamic> resultDynamic = jsonDecode(response.body);
    resultDynamic.forEach((element) {
      print('element=$element');
      resultList.add(Lesson.fromJson(element));
    });
    resultList.forEach((element) {
      print('fetchLessons result=$element');
    });
    return resultList;
  }
}