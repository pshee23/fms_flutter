import 'package:flutter/material.dart';
import 'package:fms/screen/register_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future save() async {
    var data = {
      "username" : emailController.text,
      "password" : passwordController.text
    };
    var body = json.encode(data);
    final uri = Uri.http('192.168.0.2:8080', '/login'); // local test라도 ip를 직접 입력해야지 됨
    var res = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: body
    );
    print(res.body);
    print(res.statusCode);
    // TODO ip 잘못되면 아무 반응없던데 어떻게 해결?
    if(res.statusCode == 200) {
      print("success");
      var refreshtoken = res.headers['refreshtoken'];
      var authorization = res.headers['authorization'];
      print(refreshtoken);
      print(authorization);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
              refreshtoken: refreshtoken!,
              authorization: authorization!
            )),
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
                        save();
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