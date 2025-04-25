import 'package:flutter/material.dart';

class BreakfastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of weekdays with corresponding breakfast details
    final List<Map<String, String>> breakfastDetails = [
      {'day': 'Monday', 'meal': 'Pancakes with syrup and fruits'},
      {'day': 'Tuesday', 'meal': 'Omelette with toast and coffee'},
      {'day': 'Wednesday', 'meal': 'Cereal with milk and a banana'},
      {'day': 'Thursday', 'meal': 'Scrambled eggs and avocado toast'},
      {'day': 'Friday', 'meal': 'Smoothie bowl with granola'},
      {'day': 'Saturday', 'meal': 'French toast with berries'},
      {'day': 'Sunday', 'meal': 'Bagels with cream cheese and smoked salmon'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Breakfast')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: breakfastDetails.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(breakfastDetails[index]['day']!),
                subtitle: Text(breakfastDetails[index]['meal']!),
                leading: Icon(Icons.fastfood),
                contentPadding: EdgeInsets.all(16.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
