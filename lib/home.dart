import 'package:flutter/material.dart';
import 'package:testproject/ExercisesPage.dart';
import 'package:testproject/mealspage.dart';

class HomeScreen extends StatelessWidget {
  final String goal;
  final String workoutTime;
  final String duration;

  const HomeScreen({
    Key? key,
    required this.goal,
    required this.workoutTime,
    required this.duration,
  }) : super(key: key);

  List<String> _generatePlan(String goal, String time, String duration) {
    int weeks = int.parse(duration.split(" ").first);
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
    final plan = _generatePlan(goal, workoutTime, duration);

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
