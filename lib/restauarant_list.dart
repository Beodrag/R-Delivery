// restaurant_list.dart
// This has all the restaurants in UCR, just a simple menu style page that can be used later

import 'package:flutter/material.dart';

class RestaurantList extends StatelessWidget {
  final List<Map<String, String>> restaurants = [
    {'name': 'The Habit', 'image': 'assets/images/the_habit.jpg'},
    {'name': 'The Coffee Bean & Tea Leaf', 'image': 'assets/images/coffee_bean.jpg'},
    {'name': 'Subway', 'image': 'assets/images/subway.jpg'},
    {'name': 'Panda Express', 'image': 'assets/images/panda_express.jpg'},
    {'name': 'Chronic Tacos', 'image': 'assets/images/chronic_tacos.jpg'},
    {'name': 'Hibachi-San', 'image': 'assets/images/hibachi_san.jpg'},
    {'name': 'The Halal Shack', 'image': 'assets/images/halal_shack.jpg'},
    //{'name': 'Starbucks at Glen More', 'image': 'assets/images/glen_more.jpg'},
    //{'name': 'Bytes', 'image': 'assets/images/bytes.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return InkWell(
            child: Column(
              children: [
                Image.asset(
                  restaurant['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                SizedBox(height: 16.0),
                Text(
                  restaurant['name']!,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Change Address'),
        ),
      ),
    );
  }
}
