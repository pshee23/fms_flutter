import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.username,
    required this.refreshtoken,
    required this.authorization
  });

  final String username;
  final String refreshtoken;
  final String authorization;

  @override
  State<HomePage> createState() => _HomePageState();
}

// class TokenInfo {
//   final String grantType;
//   final String accessToken;
//   final String refreshToken;
//
//   TokenInfo({
//     required this.grantType,
//     required this.accessToken,
//     required this.refreshToken});
//
//   factory TokenInfo.fromJSON(Map<String, dynamic> map) {
//     return TokenInfo(
//         grantType: map['grantType'],
//         accessToken: map['accessToken'],
//         refreshToken: map['refreshToken']);
//   }
// }

class _HomePageState extends State<HomePage> {
  String baseUrl = '192.168.10.162:8080';

  String username = "";
  String access_token = "";
  String refresh_token = "";

  @override
  void initState() {
    username = widget.username;
    access_token = widget.authorization;
    refresh_token = widget.refreshtoken;
    super.initState();
  }

  Future checkAuthorization(path) async {
    final uri = Uri.http(baseUrl, path);
    var res = await http.get(uri,
        headers: {'Authorization' : access_token},
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
        headers: {'Authorization' : refresh_token},
    );

    int status_code = res.statusCode;
    if(status_code == 200) {
      // var body_str = json.decode(res.body);
      // print("refresh received. body=$body_str");
      // TokenInfo tokenInfo = TokenInfo.fromJSON(body_str);
      // print("received refresh result. tokenInfo=$tokenInfo");

      String responseBody = utf8.decode(res.bodyBytes);
      Map<String, dynamic> map = jsonDecode(responseBody);
      print("map = $map");
      var prefix = map['grantType'];
      var access = map['accessToken'];
      var refresh = map['refreshToken'];
      print("[$status_code] refresh success");
      var re_refreshtoken = prefix + refresh;
      var re_authorization = prefix + access;
      print("received refresh result. re_authorization=$re_authorization, re_refreshtoken=$re_refreshtoken");
      setState(() {
        refresh_token = re_refreshtoken;
        access_token = re_authorization;
      });
      print("after setState tokens. authorization=$access_token, refreshtoken=$refresh_token");
    } else {
      var res_body = res.body;
      print("[$status_code] refresh fail.. body=$res_body");
    }
  }

  void logout() {
    var data = {
      "username" : username
    };

    final uri = Uri.http(baseUrl, '/api/logout', data);
    http.put(uri);

    // super.dispose();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: <Widget>[
            IconButton(onPressed: (){logout();}, icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(30.0),
          child: GridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            mainAxisSpacing: 30.0,
            crossAxisSpacing: 30.0,
            children: [
              ElevatedButton(onPressed: (){checkAuthorization('/api/user');}, child: Text("USER")),
              ElevatedButton(onPressed: (){checkAuthorization('/api/manager');}, child: Text("MANAGER")),
              ElevatedButton(onPressed: (){checkAuthorization('/api/admin');}, child: Text("ADMIN")),
            ],
          ),
      )
    );
  }
}