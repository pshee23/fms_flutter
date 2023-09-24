import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fms/model/category_colors.dart';
import 'package:http/http.dart' as http;

import '../model/schedule.dart';

abstract class HttpService {
  Future<List<CategoryColors>> fetchCategoryColors();

  Future<int> createLessonHistory(schedule);

  void logout(username);

  Future<List<Schedule>> fetchSchedules(datetime);
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
    // DateTime datetime = DateFormat("yyyy-MM-dd").format(datetime);
    DateTime dateTime = datetime;

    print('watchSchedules. body=$datetime');

    final uri = Uri.http(serverUrl, '/lesson-history/datetime/${dateTime.year}/${dateTime.month}/${dateTime.day}');
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
        // Uri.parse('http://192.168.10.162:8080/lesson-history'),
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body
    );

    var code = response.statusCode;
    print('create Lesson-History. code=$code');
    return code;
  }

}