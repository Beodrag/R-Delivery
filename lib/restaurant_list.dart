import 'package:flutter/material.dart';
import 'TheHabitDetail.dart'; // Import the specific restaurant detail page for The Habit
import 'ChronicTacosDetail.dart';
import 'CoffeeBeanDetail.dart';
import 'HalalShackDetail.dart';
import 'HibachiSanDetail.dart';
import 'PandaExpressDetail.dart';
import 'SubwayDetail.dart';

class RestaurantList extends StatelessWidget {
  final List<Map<String, dynamic>> restaurants = [
    {
      'name': 'The Habit',
      'image': 'assets/images/the_habit.jpg',
      'detailPage': (BuildContext context) => TheHabitDetail(
        restaurant: {
          'name': 'The Habit',
          'image': 'assets/images/the_habit.jpg',
        },
      ),
    },
    {
      'name': 'The Coffee Bean & Tea Leaf',
      'image': 'assets/images/coffee_bean.jpg',
      'detailPage': (BuildContext context) => CoffeeBeanDetail(
        restaurant: {
          'name': 'The Coffee Bean & Tea Leaf',
          'image': 'assets/images/coffee_bean.jpg',
        },
      ),
    },
    {
      'name': 'Subway',
      'image': 'assets/images/subway.jpg',
      'detailPage': (BuildContext context) => SubwayDetail(
        restaurant: {
          'name': 'Subway',
          'image': 'assets/images/subway.jpg',
        },
      ),
    },
    {
      'name': 'Panda Express',
      'image': 'assets/images/panda_express.jpg',
      'detailPage': (BuildContext context) => PandaExpressDetail(
        restaurant: {
          'name': 'Panda Express',
          'image': 'assets/images/panda_express.jpg',
        },
      ),
    },
    {
      'name': 'Chronic Tacos',
      'image': 'assets/images/chronic_tacos.jpg',
      'detailPage': (BuildContext context) => ChronicTacosDetail(
        restaurant: {
          'name': 'Chronic Tacos',
          'image': 'assets/images/chronic_tacos.jpg',
        },
      ),
    },
    {
      'name': 'Hibachi-San',
      'image': 'assets/images/hibachi_san.jpg',
      'detailPage': (BuildContext context) => HibachiSanDetail(
        restaurant: {
          'name': 'Hibachi-San',
          'image': 'assets/images/hibachi_san.jpg',
        },
      ),
    },
    {
      'name': 'The Halal Shack',
      'image': 'assets/images/halal_shack.jpg',
      'detailPage': (BuildContext context) => HalalShackDetail(
        restaurant: {
          'name': 'The Halal Shack',
          'image': 'assets/images/halal_shack.jpg',
        },
      ),
    },
    // Add more restaurants with their names, image paths, and corresponding detail pages
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => restaurant['detailPage'](context),
                ),
              );
            },
            child: Column(
              children: [
                Image.asset(
                  restaurant['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity, // Cover the screen horizontally
                ),
                const SizedBox(height: 16.0), // Add spacing between the image and restaurant name
                Text(
                  restaurant['name']!,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0), // Add additional spacing between restaurants
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the address selection page
            Navigator.pop(context);
          },
          child: const Text('Change Address'),
        ),
      ),
    );
  }
}
