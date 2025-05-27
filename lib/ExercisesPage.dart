import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExercisesPage extends StatefulWidget {
  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final supabase = Supabase.instance.client;
  Map<String, List<String>> exerciseData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExercisePlan();
  }

  Future<void> fetchExercisePlan() async {
    final userId = supabase.auth.currentUser?.id;

    final response = await supabase
        .from('user_workout_plans')
        .select()
        .eq('user_id', userId as Object);

    final data = List<Map<String, dynamic>>.from(response);

    // Group exercises by muscle group
    Map<String, List<String>> groupedExercises = {};

    for (var item in data) {
      final group = item['muscle_group'] ?? 'General';
      final exercise = item['exercise'] ?? '';
      if (!groupedExercises.containsKey(group)) {
        groupedExercises[group] = [];
      }
      groupedExercises[group]!.add(exercise);
    }

    setState(() {
      exerciseData = groupedExercises;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exercises Plan")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : exerciseData.isEmpty
          ? Center(child: Text('No exercises found for your plan.'))
          : ListView(
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
