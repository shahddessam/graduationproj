import 'package:flutter/material.dart';

class DinnerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of weekdays with corresponding dinner details
    final List<Map<String, String>> dinnerDetails = [
      {'day': 'Monday', 'meal': 'Grilled salmon with steamed vegetables'},
      {'day': 'Tuesday', 'meal': 'Beef stir-fry with noodles'},
      {'day': 'Wednesday', 'meal': 'Chicken Alfredo pasta'},
      {'day': 'Thursday', 'meal': 'Vegetable curry with rice'},
      {'day': 'Friday', 'meal': 'Pizza with a side salad'},
      {'day': 'Saturday', 'meal': 'BBQ ribs with mashed potatoes'},
      {'day': 'Sunday', 'meal': 'Roast chicken with vegetables'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Dinner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dinnerDetails.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(dinnerDetails[index]['day']!),
                subtitle: Text(dinnerDetails[index]['meal']!),
                leading: Icon(Icons.dinner_dining),
                contentPadding: EdgeInsets.all(16.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
