import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DinnerPage extends StatefulWidget {
  @override
  _DinnerPageState createState() => _DinnerPageState();
}

class _DinnerPageState extends State<DinnerPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> dinnerData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDinnerPlan();
  }

  Future<void> fetchDinnerPlan() async {
    final userId = supabase.auth.currentUser?.id;

    final response = await supabase
        .from('users_meals')
        .select()
        .eq('user_id', userId as Object)
        .eq('meal_type', 'dinner');

    setState(() {
      dinnerData = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dinner Plan')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dinnerData.isEmpty
          ? Center(child: Text('No dinner data found.'))
          : ListView.builder(
        itemCount: dinnerData.length,
        itemBuilder: (context, index) {
          final day = dinnerData[index]['day'];
          final meal = dinnerData[index]['meal_description'];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ListTile(
              title: Text(day),
              subtitle: Text(meal),
              leading: Icon(Icons.dinner_dining),
              contentPadding: EdgeInsets.all(16.0),
            ),
          );
        },
      ),
    );
  }
}
