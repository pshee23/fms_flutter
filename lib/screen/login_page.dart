import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fms/screen/register_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/Login.dart';
import 'home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  static final storage = FlutterSecureStorage();
  String baseUrl = '';
  dynamic userInfo = '';

  //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    String serverUrl = dotenv.get('SERVER_URL'); // Null Saftey 방지. 예외 발생. 기본값도 설정가능 (예외 안나는거 같은데)
    //String serverPort = dotenv.env['SERVER_URL'].toString(); // 예시
    if (serverUrl.isEmpty) {
      print('.env config SERVER_URL is empty! URL=$serverUrl');
      SystemNavigator.pop();
      return;
    } else {
      baseUrl = serverUrl;
    }

    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key:'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      print('로그인 정보 있음!');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()),
      );
    } else {
      print('로그인이 필요합니다');
    }
  }

  Future login(accountName, password) async {
    var data = { "username" : '$accountName', "password" : '$password' };
    var body = json.encode(data);
    final uri = Uri.http(baseUrl, '/login'); // local test라도 ip를 직접 입력해야지 됨
    var response;
    try {
      response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: body
      ).timeout(const Duration(milliseconds: 5000)); // TODO 뭔가 다른 에러가 리턴됨. exception catch
    } catch(e) {
      print(e);
    }
    print(response.body);
    print(response.statusCode);
    // TODO ip 잘못되면 아무 반응없던데 어떻게 해결?
    if(response.statusCode == 200) {
      print("login success");
      var refreshtoken = response.headers['refreshtoken'];
      var authorization = response.headers['authorization'];
      print("auth token=$authorization");
      print("refresh token=$refreshtoken");
      if(authorization == null || refreshtoken == null) {
        print("no token retured.");
        return;
      }
      var val = jsonEncode(Login(accountName, password, authorization, refreshtoken));
      await storage.write(key: 'login', value: val,);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()),
      );
    } else {
      print("fail..");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid Credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login page'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(child: Text('new user?')),
                    TextButton(
                        onPressed: () {
                          print("Create new user");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterUser()),
                          );
                        },
                        child: Text('Register'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login(emailController.text, passwordController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill input')),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}