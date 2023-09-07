import 'package:flutter/material.dart';
import 'package:fms/screen/login_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'fitness management service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
