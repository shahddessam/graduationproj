import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LunchPage extends StatefulWidget {
  @override
  _LunchPageState createState() => _LunchPageState();
}

class _LunchPageState extends State<LunchPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> lunchData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLunchPlan();
  }

  Future<void> fetchLunchPlan() async {
    final userId = supabase.auth.currentUser?.id;

    final response = await supabase
        .from('users_meals')
        .select()
        .eq('user_id', userId as Object)
        .eq('meal_type', 'lunch');

    setState(() {
      lunchData = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lunch Plan')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : lunchData.isEmpty
          ? Center(child: Text('No lunch data found.'))
          : ListView.builder(
        itemCount: lunchData.length,
        itemBuilder: (context, index) {
          final day = lunchData[index]['day'];
          final meal = lunchData[index]['meal_description'];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ListTile(
              title: Text(day),
              subtitle: Text(meal),
              leading: Icon(Icons.lunch_dining),
              contentPadding: EdgeInsets.all(16.0),
            ),
          );
        },
      ),
    );
  }
}
