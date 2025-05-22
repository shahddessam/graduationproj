import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testproject/loginpage.dart';
import 'mealspage.dart';
import 'loginpage.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zkuqtmzesjblwlzgwnms.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InprdXF0bXplc2pibHdsemd3bm1zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc5MDI4MjYsImV4cCI6MjA2MzQ3ODgyNn0.v71-H8tCCM69j5UbBmlzjoZTLg_jlZyBKkGVq8CYZ5k',
  );
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

