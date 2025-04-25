import 'package:flutter/material.dart';

class LunchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of weekdays with corresponding lunch details
    final List<Map<String, String>> lunchDetails = [
      {'day': 'Monday', 'meal': 'Grilled chicken with vegetables and rice'},
      {'day': 'Tuesday', 'meal': 'Spaghetti with marinara sauce'},
      {'day': 'Wednesday', 'meal': 'Caesar salad with grilled shrimp'},
      {'day': 'Thursday', 'meal': 'Turkey sandwich with chips and a pickle'},
      {'day': 'Friday', 'meal': 'Veggie burger with sweet potato fries'},
      {'day': 'Saturday', 'meal': 'Grilled cheese sandwich with tomato soup'},
      {'day': 'Sunday', 'meal': 'Chicken and waffles with syrup'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Lunch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: lunchDetails.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(lunchDetails[index]['day']!),
                subtitle: Text(lunchDetails[index]['meal']!),
                leading: Icon(Icons.lunch_dining),
                contentPadding: EdgeInsets.all(16.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
