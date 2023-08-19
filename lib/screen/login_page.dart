import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    Map<String, String> queryParam = {
      "username" : emailController.text,
      "password" : passwordController.text
    };
    print(emailController.text);
    print(passwordController.text);

    final uri = Uri.http('192.168.0.2:8080', '/login', queryParam); // local test라도 ip를 직접 입력해야지 됨

    var res = await http.post(uri,
      headers: {'Content-Type': 'application/json'}
    );
    print(res.body);
    print(res.statusCode);
    if(res.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
              email: emailController.text,
            )),
      );
    } else {
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
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        save();
                        // Navigate the user to the Home page
                        // if (emailController.text == "arun@gogosoon.com" && passwordController.text == "qazxswedcvfr") {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomePage(
                        //           email: emailController.text,
                        //         )),
                        //   );
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         content: Text('Invalid Credentials')),
                        //   );
                        // }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill input')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}