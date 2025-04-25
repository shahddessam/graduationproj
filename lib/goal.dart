import 'package:flutter/material.dart';
import 'package:testproject/WorkoutTimeScreen.dart';

class GoalScreen extends StatefulWidget {
  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String? selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Goal")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What is your goal?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            // Create buttons for each goal with fixed size
            ...["Be More Active", "Lose Weight", "Gain Muscle", "Prenatal Fit", "Postnatal Fit"].map((goal) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,  // Ensure buttons take full width
                  height: 50,  // Fixed height for the buttons
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedGoal == goal ? Colors.deepPurple : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners for buttons
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedGoal = goal;
                      });
                    },
                    child: Text(
                      goal,
                      style: TextStyle(fontSize: 16),  // Set font size for the button text
                    ),
                  ),
                ),
              );
            }).toList(),
            Spacer(),
            // Next button
            SizedBox(
              width: double.infinity,  // Make the Next button take full width
              height: 50,  // Fixed height for the Next button
              child: ElevatedButton(
                onPressed: selectedGoal == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutTimeScreen(goal: selectedGoal!),
                    ),
                  );
                },
                child: Text("Next", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners for button
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
