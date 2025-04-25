import 'package:flutter/material.dart';

class ExercisesPage extends StatelessWidget {
  final Map<String, List<String>> exerciseData = {
    "Upper Body": [
      "Push-Ups",
      "Shoulder Press",
      "Tricep Dips",
    ],
    "Lower Body": [
      "Squats",
      "Lunges",
      "Glute Bridges",
    ],
    "Core": [
      "Plank",
      "Bicycle Crunches",
      "Leg Raises",
    ],
    "Cardio": [
      "Jumping Jacks",
      "Mountain Climbers",
      "Burpees",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exercises")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: exerciseData.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...entry.value.map((exercise) => Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.fitness_center),
                  title: Text(exercise),
                ),
              )),
              SizedBox(height: 20),
            ],
          );
        }).toList(),
      ),
    );
  }
}
