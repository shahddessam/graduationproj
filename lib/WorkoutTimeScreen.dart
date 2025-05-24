import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'weeks.dart';

class WorkoutTimeScreen extends StatefulWidget {
  final String goal;

  const WorkoutTimeScreen({Key? key, required this.goal}) : super(key: key);

  @override
  State<WorkoutTimeScreen> createState() => _WorkoutTimeScreenState();
}

class _WorkoutTimeScreenState extends State<WorkoutTimeScreen> {
  String? selectedTime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserWorkoutTime();
  }

  Future<void> _loadUserWorkoutTime() async {
    setState(() => isLoading = true);

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      _showErrorSnackBar('Please log in to continue');
      setState(() => isLoading = false);
      return;
    }

    try {
      final userResponse = await supabase
          .from('user')
          .select('goal, goal_name, goal_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (userResponse == null) {
        _showErrorSnackBar('User data not found. Please ensure your profile is set up.');
        setState(() => isLoading = false);
        return;
      }

      String goalValue = widget.goal.trim();
      if (userResponse['goal'] != null) {
        final userGoal = userResponse['goal'] as String;
        if (userGoal.contains(' to ')) goalValue = userGoal;
        else if (userResponse['goal_name'] != null) goalValue = userResponse['goal_name'] as String;
      }

      // Retrieve the latest user_answers record
      final userAnswerResponse = await supabase
          .from('user_answers')
          .select('time_id')
          .eq('user_id', userId)
          .eq('goal_id', userResponse['goal_id'] ?? '')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (userAnswerResponse != null && userAnswerResponse['time_id'] != null) {
        final timeId = userAnswerResponse['time_id'] as String;
        final timeResponse = await supabase
            .from('time')
            .select('duration')
            .eq('time_id', timeId)
            .maybeSingle();

        if (timeResponse != null && timeResponse['duration'] != null) {
          final duration = timeResponse['duration'] as int;
          const timeMap = {
            10: '5-10 minutes',
            20: '15-20 minutes',
            30: '30 minutes',
            60: '60 minutes',
          };
          setState(() {
            selectedTime = timeMap[duration];
          });
        }
      }
    } catch (error, stackTrace) {
      print('Error loading workout time: $error\nStack trace: $stackTrace');
      _showErrorSnackBar('Failed to load workout time: $error');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> saveTimeToUserAnswers(String timeLabel) async {
    if (timeLabel.isEmpty || widget.goal.isEmpty) {
      _showErrorSnackBar('Please select a workout time and ensure goal is set');
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

    const timeMap = {
      '5-10 minutes': 10,
      '15-20 minutes': 20,
      '30 minutes': 30,
      '60 minutes': 60,
    };

    final duration = timeMap[timeLabel];
    if (duration == null) {
      _showErrorSnackBar('Invalid workout time selected');
      setState(() => isLoading = false);
      return;
    }

    try {
      final userResponse = await supabase
          .from('user')
          .select('goal, goal_name, goal_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (userResponse == null) {
        _showErrorSnackBar('User data not found. Please ensure your profile is set up.');
        setState(() => isLoading = false);
        return;
      }

      String goalValue = widget.goal.trim();
      if (userResponse['goal'] != null) {
        final userGoal = userResponse['goal'] as String;
        if (userGoal.contains(' to ')) goalValue = userGoal;
        else if (userResponse['goal_name'] != null) goalValue = userResponse['goal_name'] as String;
      }

      // Fetch or create time_id
      var timeResponse = await supabase
          .from('time')
          .select('time_id')
          .eq('duration', duration)
          .maybeSingle();

      String timeId;
      if (timeResponse == null || timeResponse['time_id'] == null) {
        final newTimeId = const Uuid().v4();
        await supabase.from('time').insert({'time_id': newTimeId, 'duration': duration});
        timeId = newTimeId;
      } else {
        timeId = timeResponse['time_id'] as String;
      }

      final answerId = const Uuid().v4();

      // Save to user_answers with timestamp
      await supabase.from('user_answers').insert({
        'answer_id': answerId,
        'user_id': userId,
        'goal_id': userResponse['goal_id'] ?? '',
        'time_id': timeId,
        'duration_id': null,
        'created_at': DateTime.now().toUtc().toIso8601String(), // Explicitly UTC
      });

      print('Workout time saved successfully at ${DateTime.now().toUtc().toIso8601String()}');

      // Navigate to WeeksCommitScreen
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WeeksCommitScreen(
              goal: goalValue,
              workoutTime: timeLabel,
              answerId: answerId,
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      print('Error saving time: $error\nStack trace: $stackTrace');
      _showErrorSnackBar('Failed to save selection: $error');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onNextPressed() {
    if (selectedTime != null) {
      saveTimeToUserAnswers(selectedTime!);
    } else {
      _showErrorSnackBar('Please select a workout time');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Time"),
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
                  "How much time do you have to workout?",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ...["5-10 minutes", "15-20 minutes", "30 minutes", "60 minutes"]
                    .map((time) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          selectedTime == time ? Colors.deepPurple : null,
                          foregroundColor:
                          selectedTime == time ? Colors.white : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                        child: Text(
                          time,
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
                    onPressed: isLoading || selectedTime == null
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
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
