import 'package:flutter/material.dart';
import 'package:testproject/goal.dart';

class AboutYouPage extends StatefulWidget {
  final VoidCallback onNext;

  const AboutYouPage({required this.onNext});

  @override
  State<AboutYouPage> createState() => _AboutYouPageState();
}

class _AboutYouPageState extends State<AboutYouPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController targetWeightController = TextEditingController();

  @override
  void dispose() {
    birthdayController.dispose();
    heightController.dispose();
    weightController.dispose();
    targetWeightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GoalScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About You"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please fill in the following details",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: birthdayController,
                label: "Birthday",
                validator: (val) =>
                val!.isEmpty ? "Please enter your birthday" : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: heightController,
                label: "Height (cm)",
                keyboardType: TextInputType.number,
                validator: (val) =>
                val!.isEmpty ? "Enter your height" : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: weightController,
                label: "Weight (kg)",
                keyboardType: TextInputType.number,
                validator: (val) =>
                val!.isEmpty ? "Enter your weight" : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: targetWeightController,
                label: "Target Weight (kg)",
                keyboardType: TextInputType.number,
                validator: (val) =>
                val!.isEmpty ? "Enter your target weight" : null,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
