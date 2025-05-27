import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BreakfastPage extends StatefulWidget {
  @override
  _BreakfastPageState createState() => _BreakfastPageState();
}

class _BreakfastPageState extends State<BreakfastPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> breakfastData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBreakfastPlan();
  }

  Future<void> fetchBreakfastPlan() async {
    final userId = supabase.auth.currentUser?.id;

    final response = await supabase
        .from('users_meals')
        .select()
        .eq('user_id', userId as Object)
        .eq('meal_type', 'breakfast');

    setState(() {
      breakfastData = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Breakfast Plan')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : breakfastData.isEmpty
          ? Center(child: Text('No breakfast data found.'))
          : ListView.builder(
        itemCount: breakfastData.length,
        itemBuilder: (context, index) {
          final day = breakfastData[index]['day'];
          final meal = breakfastData[index]['meal_description'];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ListTile(
              title: Text(day),
              subtitle: Text(meal),
              leading: Icon(Icons.breakfast_dining),
              contentPadding: EdgeInsets.all(16.0),
            ),
          );
        },
      ),
    );
  }
}
