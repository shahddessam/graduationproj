import 'package:flutter/material.dart';
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
  String targetWeight = '';

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

                // Age input
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

                // Gender dropdown
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

                // Weight input
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

                // Height input
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

                // Target weight input
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
                  onChanged: (val) => targetWeight = val,
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save or process the data here if needed

                        // Navigate to GoalScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => GoalScreen()),
                        );

                        // Or call widget.onNext if you want to keep that logic
                        // if (widget.onNext != null) {
                        //   widget.onNext!();
                        // }
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
