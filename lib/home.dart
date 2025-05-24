import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testproject/ExercisesPage.dart';
import 'package:testproject/mealspage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required String goal, required String workoutTime, required String duration}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? goal;
  String? workoutTime;
  String? duration;
  List<String> plan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserAnswers();
  }

  Future<void> _fetchUserAnswers() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      final response = await supabase
          .from('user_answers')
          .select('goal_id, time_id, weeks')
          .eq('user_id', userId)
          .single();

      if (response == null) {
        throw Exception("No answers found for this user");
      }

      final goalLabel = await supabase
          .from('goal')
          .select('goal_label')
          .eq('goal_id', response['goal_id'])
          .single();

      final timeLabel = await supabase
          .from('time')
          .select('time_label')
          .eq('time_id', response['time_id'])
          .single();

      setState(() {
        goal = goalLabel['goal_label'];
        workoutTime = timeLabel['time_label'];
        duration = "${response['weeks']} weeks";
        plan = _generatePlan(goal!, workoutTime!, duration!);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user answers: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading plan')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  List<String> _generatePlan(String goal, String time, String duration) {
    int weeks = int.tryParse(duration.split(" ").first) ?? 4;
    List<String> plan = [];

    for (int i = 1; i <= weeks; i++) {
      String weekPlan = "Week $i: ";

      switch (goal) {
        case "Lose Weight":
          weekPlan += (i % 2 == 0) ? "HIIT + Core burn" : "Cardio + Full Body";
          break;
        case "Gain Muscle":
          weekPlan += (i % 2 == 0) ? "Upper Body Strength" : "Leg Day & Core";
          break;
        case "Be More Active":
          weekPlan += (i % 2 == 0) ? "Mobility + Stretching" : "Light Cardio + Fun Moves";
          break;
        case "Prenatal Fit":
          weekPlan += (i % 2 == 0) ? "Breathing + Pelvic Floor" : "Gentle Strength & Stretch";
          break;
        case "Postnatal Fit":
          weekPlan += (i % 2 == 0) ? "Core recovery + Stretches" : "Bodyweight Moves";
          break;
        default:
          weekPlan += "Custom Fitness Plan";
      }

      weekPlan += " – $time per day";
      plan.add(weekPlan);
    }

    return plan;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Your Plan")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Your Plan")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🎯 Goal: $goal", style: TextStyle(fontSize: 18)),
            Text("⏱ Workout Time: $workoutTime", style: TextStyle(fontSize: 18)),
            Text("📅 Duration: $duration", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("📋 Your Weekly Plan", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: plan.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(plan[index]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ExercisesPage()),
                        );
                      },
                      child: Image.asset(
                        'assets/exercises.jpg',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Exercises"),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MealsPage()),
                        );
                      },
                      child: Image.asset(
                        'assets/meals.jpeg',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Meals"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
