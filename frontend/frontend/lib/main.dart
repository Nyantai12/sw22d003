import 'package:flutter/material.dart';
import 'package:frontend/adminhomepage.dart';
import 'package:frontend/homepage.dart';
import 'package:frontend/login.dart';
import 'package:frontend/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}