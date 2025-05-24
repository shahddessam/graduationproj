import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testproject/weeks.dart';

class WorkoutTimeScreen extends StatefulWidget {
  final String goal;

  const WorkoutTimeScreen({Key? key, required this.goal}) : super(key: key);

  @override
  State<WorkoutTimeScreen> createState() => _WorkoutTimeScreenState();
}

class _WorkoutTimeScreenState extends State<WorkoutTimeScreen> {
  String? selectedTime;

  Future<void> saveTimeToUserAnswers(String timeLabel) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    // Step 1: Get time_id from time table
    final timeResponse = await supabase
        .from('time')
        .select('time_id')
        .eq('time_label', timeLabel)
        .single();

    if (timeResponse == null || timeResponse['time_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout time not found in database')),
      );
      return;
    }

    final timeId = timeResponse['time_id'];

    // Step 2: Update user_answers with time_id
    final updateResponse = await supabase
        .from('user_answers')
        .update({'time_id': timeId})
        .eq('user_id', userId);

    if (updateResponse.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating time: ${updateResponse.error!.message}')),
      );
    } else {
      print('Workout time updated successfully in user_answers');
    }
  }

  void _onNextPressed() async {
    if (selectedTime != null) {
      await saveTimeToUserAnswers(selectedTime!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WeeksCommitScreen(
            goal: widget.goal,
            workoutTime: selectedTime!,
          ),
        ),
      );
    }
  }

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
            ...["5-10 minutes", "15-20 minutes", "30 minutes", "60 minutes"].map((time) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTime == time ? Colors.deepPurple : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    child: Text(
                      time,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            }).toList(),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedTime == null ? null : _onNextPressed,
                child: Text("Next", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
