import 'package:flutter/material.dart';
import 'home.dart';

class WeeksCommitScreen extends StatefulWidget {
  final String goal;
  final String workoutTime;

  const WeeksCommitScreen({
    Key? key,
    required this.goal,
    required this.workoutTime,
  }) : super(key: key);

  @override
  State<WeeksCommitScreen> createState() => _WeeksCommitScreenState();
}

class _WeeksCommitScreenState extends State<WeeksCommitScreen> {
  String? selectedWeeks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plan Duration"),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How many weeks do you want to start with?", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 20),
            // Buttons for weeks selection with fixed size
            ...["4 weeks", "8 weeks", "12 weeks"].map((weeks) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,  // Ensure buttons take full width
                  height: 50,  // Fixed height for the buttons
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedWeeks == weeks ? Colors.deepPurple : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners for buttons
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedWeeks = weeks;
                      });
                    },
                    child: Text(
                      weeks,
                      style: TextStyle(fontSize: 16),  // Set font size for the button text
                    ),
                  ),
                ),
              );
            }).toList(),
            Spacer(),
            // Next button with fixed size
            SizedBox(
              width: double.infinity,  // Make the Next button take full width
              height: 50,  // Fixed height for the Next button
              child: ElevatedButton(
                onPressed: selectedWeeks == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(
                        goal: widget.goal,
                        workoutTime: widget.workoutTime,
                        duration: selectedWeeks!,
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

