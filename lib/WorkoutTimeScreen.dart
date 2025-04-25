import 'package:flutter/material.dart';
import 'package:testproject/weeks.dart';

class WorkoutTimeScreen extends StatefulWidget {
  final String goal;

  const WorkoutTimeScreen({Key? key, required this.goal}) : super(key: key);

  @override
  State<WorkoutTimeScreen> createState() => _WorkoutTimeScreenState();
}

class _WorkoutTimeScreenState extends State<WorkoutTimeScreen> {
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Time"),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How much time do you have to workout?",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 20),
            // Create buttons for each workout time with fixed size
            ...["5-10 minutes", "15-20 minutes", "30 minutes", "60 minutes"].map((time) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,  // Ensure buttons take full width
                  height: 50,  // Fixed height for the buttons
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTime == time ? Colors.deepPurple : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners for buttons
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    child: Text(
                      time,
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
                onPressed: selectedTime == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeeksCommitScreen(
                        goal: widget.goal,
                        workoutTime: selectedTime!,
                      ),
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
