import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  Future<void> saveDurationToUserAnswers(String durationLabel) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    // Step 1: Get duration_id from duration table
    final durationResponse = await supabase
        .from('duration')
        .select('duration_id')
        .eq('duration_label', durationLabel)
        .single();

    if (durationResponse == null || durationResponse['duration_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Duration not found in database')),
      );
      return;
    }

    final durationId = durationResponse['duration_id'];

    // Step 2: Update user_answers with duration_id (assumes one answer row per user)
    final updateResponse = await supabase
        .from('user_answers')
        .update({'duration_id': durationId})
        .eq('user_id', userId);

    if (updateResponse.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating duration: ${updateResponse.error!.message}')),
      );
    } else {
      print('Duration updated successfully in user_answers');
    }
  }

  void _onNextPressed() async {
    if (selectedWeeks != null) {
      await saveDurationToUserAnswers(selectedWeeks!);
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
    }
  }

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
            ...["4 weeks", "8 weeks", "12 weeks"].map((weeks) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedWeeks == weeks ? Colors.deepPurple : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedWeeks = weeks;
                      });
                    },
                    child: Text(
                      weeks,
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
                onPressed: selectedWeeks == null ? null : _onNextPressed,
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
