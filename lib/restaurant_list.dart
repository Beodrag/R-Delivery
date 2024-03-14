import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'TheHabitDetail.dart';
import 'ChronicTacosDetail.dart';
import 'CoffeeBeanDetail.dart';
import 'HalalShackDetail.dart';
import 'HibachiSanDetail.dart';
import 'PandaExpressDetail.dart';
import 'SubwayDetail.dart';
import 'cart_model.dart';

class RestaurantList extends StatelessWidget {
  final List<Map<String, dynamic>> restaurants = [
    {
      'name': 'The Habit',
      'image': 'assets/images/the_habit.jpg',
      'detailPage': (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: TheHabitDetail(
          restaurant: {
            'name': 'The Habit',
            'image': 'assets/images/the_habit.jpg',
          },
        ),
      ),
    },
    {
      'name': 'The Coffee Bean & Tea Leaf',
      'image': 'assets/images/coffee_bean.jpg',
      'detailPage': (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: CoffeeBeanDetail(
          restaurant: {
            'name': 'The Coffee Bean & Tea Leaf',
            'image': 'assets/images/coffee_bean.jpg',
          },
        ),
      ),
    },
    {
      'name': 'Subway',
      'image': 'assets/images/subway.jpg',
      'detailPage': (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: SubwayDetail(
          restaurant: {
            'name': 'Subway',
            'image': 'assets/images/subway.jpg',
          },
        ),
      ),
    },
    {
      'name': 'Panda Express',
      'image': 'assets/images/panda_express.jpg',
      'detailPage': (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: PandaExpressDetail(
          restaurant: {
            'name': 'Panda Express',
            'image': 'assets/images/panda_express.jpg',
          },
        ),
      ),
    },
    {
      'name': 'Chronic Tacos',
      'image': 'assets/images/chronic_tacos.jpg',
      'detailPage': (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: ChronicTacosDetail(
          restaurant: {
            'name': 'Chronic Tacos',
            'image': 'assets/images/chronic_tacos.jpg',
          },
        ),
      ),
    },
    {
      'name': 'Hibachi-San',
      'image': 'assets/images/hibachi_san.jpg',
      'detailPage': (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: HibachiSanDetail(
          restaurant: {
            'name': 'Hibachi-San',
            'image': 'assets/images/hibachi_san.jpg',
          },
        ),
      ),
    },
    {
      'name': 'The Halal Shack',
      'image': 'assets/images/halal_shack.jpg',
      'detailPage': (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: HalalShackDetail(
          restaurant: {
            'name': 'The Halal Shack',
            'image': 'assets/images/halal_shack.jpg',
          },
        ),
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
          child: const Text('Change Address'),
        ),
      ),
    );
  }
}
