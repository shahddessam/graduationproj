import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'WorkoutTimeScreen.dart'; //

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String? selectedGoal;

  Future<void> saveUserGoal(String goalName) async {
    final supabase = Supabase.instance.client;
    final user_Id = supabase.auth.currentUser?.id;

    if (user_Id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final goalResponse = await supabase
        .from('goal')
        .select('goal_id')
        .eq('goal_name', goalName)
        .maybeSingle();

    if (goalResponse == null || goalResponse['goal_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal not found in database')),
      );
      return;
    }

    final goal_Id = goalResponse['goal_id'];

    final response = await supabase.from('user answers').upsert({
      'user_id': user_Id,
      'goal_id': goal_Id,
    });

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    } else {
      print('User goal saved successfully');
    }
  }

  void _onNextPressed() async {
    if (selectedGoal != null) {
      await saveUserGoal(selectedGoal!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutTimeScreen(goal: selectedGoal!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final goals = [
      "Be More Active",
      "Lose Weight",
      "Gain Muscle",
      "Prenatal Fit",
      "Postnatal Fit",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Goal")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What is your goal?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ...goals.map((goal) {
              final isSelected = selectedGoal == goal;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.deepPurple : null,
                      foregroundColor: isSelected ? Colors.white : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedGoal = goal;
                      });
                    },
                    child: Text(goal, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              );
            }).toList(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedGoal == null ? null : _onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Next", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
