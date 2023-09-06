import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.refreshtoken,
    required this.authorization
  });

  final String refreshtoken;
  final String authorization;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = '192.168.0.2:8080';

  set authorization(String? authorization) {}

  set refreshtoken(String? refreshtoken) {}

  Future checkAuthorization(path) async {
    final uri = Uri.http(url, path);
    var res = await http.get(uri,
        headers: {'Authorization' : widget.authorization},
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
    final uri = Uri.http(url, '/api/refresh');
    var res = await http.post(uri,
        headers: {'Authorization' : widget.refreshtoken},
    );

    int status_code = res.statusCode;
    print(res.body);
    if(status_code == 200) {
      print("[$status_code] refresh success");
      var re_refreshtoken = res.headers['refreshtoken'];
      var re_authorization = res.headers['authorization'];
      print("received refresh result. refresh=$re_refreshtoken, token=$re_authorization");
      setState(() {
        this.refreshtoken = re_refreshtoken;
        this.authorization = re_authorization;
      });
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