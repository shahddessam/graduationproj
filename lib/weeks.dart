import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

class WeeksCommitScreen extends StatefulWidget {
  const WeeksCommitScreen({Key? key}) : super(key: key);

  @override
  State<WeeksCommitScreen> createState() => _WeeksCommitScreenState();
}

class _WeeksCommitScreenState extends State<WeeksCommitScreen> {
  String? selectedWeeks;
  bool isLoading = false;

  Future<void> saveDuration(String durationLabel) async {
    if (durationLabel.isEmpty) {
      _showSnackBar('Please select a duration');
      return;
    }

    setState(() => isLoading = true);

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null || userId.isEmpty) {
      _showSnackBar('User not logged in');
      setState(() => isLoading = false);
      return;
    }

    try {
      final existingUser = await supabase
          .from('user')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (existingUser == null) {
        await supabase.from('user').insert({
          'user_id': userId,
          'duration': durationLabel,
        });
      } else {
        await supabase.from('user')
            .update({'duration': durationLabel})
            .eq('user_id', userId);
      }

      _showSnackBar('Duration saved successfully ✅');
    } catch (error) {
      _showSnackBar('Failed to save duration: $error');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onNextPressed() async {
    if (selectedWeeks != null) {
      await saveDuration(selectedWeeks!);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } else {
      _showSnackBar('Please select a duration');
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
