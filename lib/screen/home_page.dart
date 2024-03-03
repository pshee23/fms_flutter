import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fms/screen/personal_info.dart';
import 'package:fms/screen/settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../locator/locator.dart';
import '../model/Login.dart';
import '../service/http_service.dart';
import 'calendar_page.dart';
import 'chat_list.dart';
import 'lesson_list.dart';
import 'member_list.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String baseUrl = '127.0.0.1:8080';
  static final storage = FlutterSecureStorage();
  // dynamic userInfo = '';
  late Login login;
  final HttpService _httpService = locator<HttpService>();

  logout() async {
    // userInfo = await storage.read(key: 'login');
    String username = login.accountName;

    _httpService.logout(username);
    Navigator.pushNamed(context, '/');
  }

  checkUserState() async {
    var userInfo = await storage.read(key: 'login');
    if (userInfo == null) {
      print('로그인 페이지로 이동');
      Navigator.pushNamed(context, '/');
    } else {
      print('로그인 확인');
      login = Login.fromJson(jsonDecode(userInfo));
    }
  }

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if(notification != null) {
        print("showwwwwwwww");
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
                'high_importance_channel', 'high_importance_notification', importance: Importance.max
            ),
          ),
        );
      }
    });
    super.initState();
    // FlutterLocalNotification.requestNotificationPermission();
    // FlutterLocalNotification.init();

    baseUrl = dotenv.get('SERVER_URL');
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
  }

  Future checkAuthorization(path) async {
    final uri = Uri.http(baseUrl, path);
    var res = await http.get(uri,
        headers: {'Authorization' : login.accessToken},
    );

    int status_code = res.statusCode;
    print(res.body);
    if(status_code == 200) {
      print("[$status_code] $path success");
    } else if (status_code == 403) {
      print("[$status_code] $path not allowed");
    } else if (status_code == 500) {
      print("500 returned request refresh");
      refreshTokenRequest();
    } else {
      print("[$status_code] $path fail..");
    }
  }

  Future refreshTokenRequest() async {
    final uri = Uri.http(baseUrl, '/api/refresh');
    var res = await http.put(uri,
        headers: {'Authorization' : login.refreshToken},
    );

    int statusCode = res.statusCode;
    if(statusCode == 200) {

      String responseBody = utf8.decode(res.bodyBytes);

      Map<String, dynamic> map = jsonDecode(responseBody);
      print("map = $map");
      var prefix = map['grantType'];
      var access = map['accessToken'];
      var refresh = map['refreshToken'];
      print("[$statusCode] refresh success");
      var re_refreshtoken = prefix + refresh;
      var re_authorization = prefix + access;
      print("received refresh result. re_authorization=$re_authorization, re_refreshtoken=$re_refreshtoken");

      print("before relogin login_obj=$login");
      // TODO body가 아니라 header로
      Login reLogin = Login(login.accountName, login.password,
          re_authorization, re_refreshtoken);
      var val = jsonEncode(reLogin);
      login = reLogin;
      await storage.write(key: 'login', value: val,);
      var result = storage.read(key: 'login');
      print("relogin result=$result, login_obj=$login");
    } else {
      var res_body = res.body;
      print("[$statusCode] refresh fail.. body=$res_body");
    }
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [CalendarPage(), LessonList(), ChatList(), MemberList(), PersonalInfo(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(onPressed: (){logout();}, icon: Icon(Icons.exit_to_app))
          ],
        ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
            label: '스케쥴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '수업조회',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅',
          ),
          // TODO employee만 보이도록 해야함
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '회원조회',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          )
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}