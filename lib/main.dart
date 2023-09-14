import 'package:flutter/material.dart';
import 'package:fms/screen/login_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fms/locator/locator.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'assets/.env');
  // Flutter 위젯이 준비 될때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  initLocator();

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
        fontFamily: 'NotoSans',
      ),
      home: LoginPage(),
    );
  }
}
