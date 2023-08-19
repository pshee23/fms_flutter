import 'package:flutter/material.dart';
import 'package:fms/screen/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'fitness management service',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}
