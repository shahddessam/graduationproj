import 'package:flutter/material.dart';
import 'breakfastpage.dart';  // Import the BreakfastPage
import 'lunchpage.dart';      // Import the LunchPage
import 'dinnerpage.dart';     // Import the DinnerPage

class MealsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Wrap the Column with SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              MealOption(
                imagePath: 'assets/breakfast.png',
                onTap: () {
                  // Navigating to the BreakfastPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BreakfastPage()),
                  );
                },
              ),
              SizedBox(height: 20), // Add some space between images
              MealOption(
                imagePath: 'assets/lunch.png',
                onTap: () {
                  // Navigating to the LunchPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LunchPage()),
                  );
                },
              ),
              SizedBox(height: 20), // Add some space between images
              MealOption(
                imagePath: 'assets/dinner.png',
                onTap: () {
                  // Navigating to the DinnerPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DinnerPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealOption extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  MealOption({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center, // Center the image horizontally
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          imagePath,
          height: 250,  // Increase the height of the image
          width: 350,   // Increase the width of the image (optional)
          fit: BoxFit.cover, // Ensure the image covers the space
        ),
      ),
    );
  }
}
