import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'WorkoutTimeScreen.dart'; // Import WorkoutTimeScreen

class AboutYouScreen extends StatefulWidget {
  final VoidCallback? onNext;

  const AboutYouScreen({Key? key, this.onNext}) : super(key: key);

  @override
  _AboutYouScreenState createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends State<AboutYouScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = ''; // New field for name
  String birthday = '';
  String goal = '';
  String weight = '';
  String height = '';
  String targetWeight = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About You'),
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
                const SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (val) => name = val,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Birthday (YYYY-MM-DD)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your birthday';
                    }
                    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    if (!regex.hasMatch(val)) {
                      return 'Enter a valid date (YYYY-MM-DD)';
                    }
                    return null;
                  },
                  onChanged: (val) => birthday = val,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Goal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Lose Weight', 'Gain Muscle', 'Stay Healthy']
                      .map((goal) => DropdownMenuItem(
                    value: goal,
                    child: Text(goal),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      goal = val ?? '';
                    });
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please select your goal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target Weight (kg) - Optional',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      final tw = double.tryParse(val);
                      if (tw == null || tw <= 0) {
                        return 'Enter a valid target weight';
                      }
                    }
                    return null;
                  },
                  onChanged: (val) => targetWeight = val,
                ),
                const SizedBox(height: 30),
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
                            const SnackBar(content: Text('User not logged in')),
                          );
                          return;
                        }

                        // Combine goal and targetWeight (if provided) for the goal column
                        final goalValue = targetWeight.isNotEmpty
                            ? '$goal to $targetWeight kg'
                            : goal;

                        final userData = {
                          'user_id': userId,
                          'name': name, // Added name field
                          'height': double.parse(height),
                          'weight': double.parse(weight),
                          'goal': goalValue,
                          'birthday': birthday,
                        };

                        try {
                          await supabase.from('user').upsert(
                            userData,
                            onConflict: 'user_id',
                          );

                          // Navigate to WorkoutTimeScreen with goal
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutTimeScreen(goal: goalValue),
                            ),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $error')),
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
                    child: const Text(
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
