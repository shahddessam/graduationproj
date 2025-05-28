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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
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
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Fitness Overview"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              color: Colors.deepPurple[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("🎯 Goal: $goal", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Text("⏱ Workout Time: $workoutTime", style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text("📅 Duration: $duration", style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionCard(
                  title: "Exercises",
                  imagePath: 'assets/exercises.jpg',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ExercisesPage()));
                  },
                ),
                _buildOptionCard(
                  title: "Meals",
                  imagePath: 'assets/meals.jpeg',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MealsPage()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
