import 'package:flutter/material.dart';
import 'package:testproject/loginpage.dart';
import 'mealspage.dart';
import 'loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginPage(), // Start app with LoginPage
    );
  }
}

