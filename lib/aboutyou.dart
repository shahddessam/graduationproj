import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testproject/weeks.dart';

class AboutYouScreen extends StatefulWidget {
  const AboutYouScreen({Key? key, required Null Function() onNext}) : super(key: key);

  @override
  _AboutYouScreenState createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends State<AboutYouScreen> {
  final _formKey = GlobalKey<FormState>();
  int workoutTime = 10; // default workout time in minutes

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
                const Text(
                  'Tell us more about you',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 30),

                DropdownButtonFormField<int>(
                  decoration: _inputDecoration('Workout Time'),
                  value: workoutTime,
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('5-10 minutes')),
                    DropdownMenuItem(value: 20, child: Text('15-20 minutes')),
                    DropdownMenuItem(value: 30, child: Text('30 minutes')),
                    DropdownMenuItem(value: 60, child: Text('60 minutes')),
                  ],
                  onChanged: (val) => setState(() {
                    workoutTime = val ?? 10;
                  }),
                  validator: (val) =>
                  val == null ? 'Please select workout time' : null,
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Goal'),
                  items: ['Lose Weight', 'Gain Muscle', 'Stay Healthy']
                      .map((goal) => DropdownMenuItem(
                    value: goal,
                    child: Text(goal),
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => goal = val ?? ''),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Please select your goal' : null,
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  label: 'Birthday (YYYY-MM-DD)',
                  keyboardType: TextInputType.datetime,
                  onChanged: (val) => birthday = val,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter your birthday';
                    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    return regex.hasMatch(val) ? null : 'Enter a valid date (YYYY-MM-DD)';
                  },
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  label: 'Weight (kg)',
                  keyboardType: TextInputType.number,
                  onChanged: (val) => weight = val,
                  validator: (val) {
                    final w = double.tryParse(val ?? '');
                    return (w == null || w <= 0) ? 'Enter a valid weight' : null;
                  },
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  label: 'Height (cm)',
                  keyboardType: TextInputType.number,
                  onChanged: (val) => height = val,
                  validator: (val) {
                    final h = double.tryParse(val ?? '');
                    return (h == null || h <= 0) ? 'Enter a valid height' : null;
                  },
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  label: 'Target Weight (kg) - Optional',
                  keyboardType: TextInputType.number,
                  onChanged: (val) => targetWeight = val,
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      final tw = double.tryParse(val);
                      return (tw == null || tw <= 0)
                          ? 'Enter a valid target weight'
                          : null;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveUserData,
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

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) =>
      TextFormField(
        keyboardType: keyboardType,
        decoration: _inputDecoration(label),
        validator: validator,
        onChanged: onChanged,
      );

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final goalValue = targetWeight.isNotEmpty ? '$goal to $targetWeight kg' : goal;

      final userData = {
        'user_id': userId,
        'workout_time': workoutTime,
        'birthday': birthday,
        'goal': goalValue,
        'weight': double.parse(weight),
        'height': double.parse(height),
      };

      try {
        await supabase.from('user').upsert(userData, onConflict: 'user_id');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WeeksCommitScreen(answerId: '', goal: '', workoutTime: '',),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }
}
