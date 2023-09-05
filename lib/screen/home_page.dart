import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.refreshtoken,
    required this.authorization
  });

  final String url = '192.168.10.139:8080';
  final String refreshtoken;
  final String authorization;

  Future checkAuthorization(path) async {
    final uri = Uri.http(url, path);
    var res = await http.get(uri,
        headers: {'Authorization' : authorization},
    );
    int status_code = res.statusCode;
    print(res.body);
    if(status_code == 200) {
      print("[$status_code] $path success");
    } else if (status_code == 403) {
      print("[$status_code] $path not allowed");
    } else {
      print("[$status_code] $path fail..");
    }
  }

  Future refreshToken() async {
    final uri = Uri.http(url, '/api/refresh');
    var res = await http.post(uri,
        headers: {'Authorization' : refreshtoken},
    );

    int status_code = res.statusCode;
    print(res.body);
    if(status_code == 200) {
      print("[$status_code] refresh success");
    } else {
      print("[$status_code] refresh fail..");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
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