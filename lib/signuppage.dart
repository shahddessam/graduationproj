import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'aboutyou.dart';
import 'mealspage.dart';
import 'loginpage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp _phoneRegex = RegExp(r'^\d{10,15}$');

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );

        final user = response.user;
        if (user != null) {
          await Supabase.instance.client
              .from('user')  // Make sure your table name matches
              .insert({'user_id': user.id, 'name': name, 'phone': phone});

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AboutYouScreen(
                onNext: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MealsPage()),
                  );
                },
              ),
            ),
          );
        } else {
          _showError("Signup failed. Please try again.");
        }
      } on AuthException catch (e) {
        _showError(e.message);
      } catch (e) {
        print('Unexpected error: $e');
        _showError("Unexpected error occurred. Try again.");
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("OK"),
          ),
        ],
      ),
    );
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
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Create your account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: _inputDecoration('Enter your name'),
                  onChanged: (val) => name = val,
                  validator: (val) =>
                  val!.trim().isEmpty ? 'Please enter your name' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Enter your phone number'),
                  onChanged: (val) => phone = val,
                  validator: (val) => !_phoneRegex.hasMatch(val!)
                      ? 'Enter a valid phone number (10–15 digits)'
                      : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: _inputDecoration('Enter your email'),
                  onChanged: (val) => email = val,
                  validator: (val) =>
                  !_emailRegex.hasMatch(val!) ? 'Enter a valid email address' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: _inputDecoration('Enter your password'),
                  onChanged: (val) => password = val,
                  validator: (val) =>
                  val!.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: _inputDecoration('Confirm your password'),
                  onChanged: (val) => confirmPassword = val,
                  validator: (val) => val != password ? 'Passwords do not match' : null,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Sign Up', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Or sign up with'),
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
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: "Login Now",
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
        // Handle social login here if needed
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(assetPath),
      ),
    );
  }
}
