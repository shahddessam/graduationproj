import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testproject/ExercisesPage.dart';
import 'package:testproject/mealspage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  String goal = "";
  String workoutTime = "";
  String duration = "";
  List<String> plan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDataAndGeneratePlan();
  }

  Future<void> fetchUserDataAndGeneratePlan() async {
    try {
      final userId = supabase.auth.currentUser?.id;

      final response = await supabase
          .from('user')
          .select()
          .eq('user_id', userId as Object)
          .single();

      if (response != null) {
        setState(() {
          goal = response['goal'] ?? "Be More Active";
          workoutTime = response['workout_time'] ?? "30 mins";
          duration = response['duration'] ?? "4 weeks";
          plan = _generatePlan(goal, workoutTime, duration);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Your Plan")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🎯 Goal: $goal", style: const TextStyle(fontSize: 18)),
            Text("⏱ Workout Time: $workoutTime", style: const TextStyle(fontSize: 18)),
            Text("📅 Duration: $duration", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text("📋 Your Weekly Plan", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: plan.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(plan[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ExercisesPage()));
                      },
                      child: Image.asset('assets/exercises.jpg', width: 150, height: 150, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    const Text("Exercises"),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => MealsPage()));
                      },
                      child: Image.asset('assets/meals.jpeg', width: 150, height: 150, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    const Text("Meals"),
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
