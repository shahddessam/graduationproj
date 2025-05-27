import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

class WeeksCommitScreen extends StatefulWidget {
  final String goal;
  final String workoutTime;
  final String answerId;

  const WeeksCommitScreen({
    Key? key,
    required this.goal,
    required this.workoutTime,
    required this.answerId,
  }) : super(key: key);

  @override
  State<WeeksCommitScreen> createState() => _WeeksCommitScreenState();
}

class _WeeksCommitScreenState extends State<WeeksCommitScreen> {
  String? selectedWeeks;
  bool isLoading = false;

  Future<void> saveDurationToUserAnswers(String durationLabel) async {
    if (durationLabel.isEmpty) {
      _showErrorSnackBar('Please select a duration');
      return;
    }

    setState(() => isLoading = true);

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      _showErrorSnackBar('User not logged in');
      setState(() => isLoading = false);
      return;
    }

    try {
      // Parse weeks from label (e.g., "4 weeks" -> 4)
      final weeks = int.parse(durationLabel.split(' ')[0]);

      // Check if duration already exists
      final durationResponse = await supabase
          .from('duration')
          .select('duration_id')
          .eq('weeks', weeks)
          .maybeSingle();

      print('Duration response: $durationResponse');

      String? durationId = durationResponse?['duration_id'];

      // If it doesn't exist, insert it and return the new ID
      if (durationId == null || durationId.isEmpty) {
        final insertResult = await supabase
            .from('duration')
            .insert({'weeks': weeks})
            .select()
            .single();

        durationId = insertResult['duration_id'];
        print('Created new duration with ID: $durationId');
      }

      if (durationId == null || durationId.isEmpty) {
        _showErrorSnackBar('Failed to get or create duration ID');
        setState(() => isLoading = false);
        return;
      }

      // ✅ Update user_answers with duration_id
      final updateResult = await supabase
          .from('user_answers')
          .update({'duration_id': durationId})
          .eq('answer_id', widget.answerId);

      print('Update result: $updateResult');

      _showErrorSnackBar('Duration saved successfully ✅');
    } catch (error, stackTrace) {
      print('Error saving duration: $error\nStack trace: $stackTrace');
      _showErrorSnackBar('Failed to save duration: $error');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }


  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onNextPressed() async {
    if (selectedWeeks != null) {
      await saveDurationToUserAnswers(selectedWeeks!);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    } else {
      _showErrorSnackBar('Please select a duration');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan Duration"),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How many weeks do you want to start with?",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ...["4 weeks", "8 weeks", "12 weeks"].map((weeks) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          selectedWeeks == weeks ? Colors.deepPurple : null,
                          foregroundColor:
                          selectedWeeks == weeks ? Colors.white : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                          setState(() {
                            selectedWeeks = weeks;
                          });
                        },
                        child: Text(
                          weeks,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading || selectedWeeks == null
                        ? null
                        : _onNextPressed,
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
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
