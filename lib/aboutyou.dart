import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testproject/goal.dart';

class AboutYouScreen extends StatefulWidget {
  final VoidCallback? onNext;

  AboutYouScreen({Key? key, this.onNext}) : super(key: key);

  @override
  _AboutYouScreenState createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends State<AboutYouScreen> {
  final _formKey = GlobalKey<FormState>();
  String age = '';
  String gender = '';
  String weight = '';
  String height = '';
  String target_Weight = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About You'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tell us more about you',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Your Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your age';
                    }
                    final ageNum = int.tryParse(val);
                    if (ageNum == null || ageNum <= 0) {
                      return 'Enter a valid age';
                    }
                    return null;
                  },
                  onChanged: (val) => age = val,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      gender = val ?? '';
                    });
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final w = double.tryParse(val);
                    if (w == null || w <= 0) {
                      return 'Enter a valid weight';
                    }
                    return null;
                  },
                  onChanged: (val) => weight = val,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your height';
                    }
                    final h = double.tryParse(val);
                    if (h == null || h <= 0) {
                      return 'Enter a valid height';
                    }
                    return null;
                  },
                  onChanged: (val) => height = val,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target Weight (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your target weight';
                    }
                    final tw = double.tryParse(val);
                    if (tw == null || tw <= 0) {
                      return 'Enter a valid target weight';
                    }
                    return null;
                  },
                  onChanged: (val) => target_weight = val,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final supabase = Supabase.instance.client;
                        final userId = supabase.auth.currentUser?.id;

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User not logged in')),
                          );
                          return;
                        }

                        final response = await supabase.from('user').upsert({
                          'user_id': user_id,
                          'age': int.parse(age),
                          'gender': gender,
                          'weight': double.parse(weight),
                          'height': double.parse(height),
                          'target_weight': double.parse(target_weight),
                        });

                        if (response.error == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => GoalScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Error: ${response.error!.message}')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
}
