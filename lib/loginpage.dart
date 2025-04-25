import 'package:flutter/material.dart';
import 'aboutyou.dart';
import 'signuppage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  final RegExp _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AboutYouPage(
            onNext: () {
              Navigator.pushReplacementNamed(context, '/goal');
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Welcome back! Glad to see you, Again!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: _inputDecoration('Enter your email'),
                  onChanged: (val) => email = val,
                  validator: (val) => !_emailRegex.hasMatch(val!)
                      ? 'Enter a valid email'
                      : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: _inputDecoration('Enter your password'),
                  onChanged: (val) => password = val,
                  validator: (val) => val!.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Or login with'),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton('assets/Facebook.png'),
                    SizedBox(width: 20),
                    _socialButton('assets/Google.png'),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignUpPage()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                            text: "Register Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return GestureDetector(
      onTap: () {
        // Handle social login
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(assetPath),
      ),
    );
  }
}
