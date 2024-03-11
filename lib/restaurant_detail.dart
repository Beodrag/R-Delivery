// restaurant_detail.dart

import 'package:flutter/material.dart';

class RestaurantDetail extends StatelessWidget {
  final Map<String, String> restaurant;

  RestaurantDetail({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['name'] ?? 'Restaurant Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              restaurant['image'] ?? 'assets/images/default_image.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0,
            ),
            SizedBox(height: 16.0),

            Text(
              restaurant['name'] ?? 'N/A',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  FoodCategory(
                    categoryName: 'Popular',
                    foodList: [
                      FoodItem(
                        name: 'Food Item 1',
                        description: 'Description for Food Item 1',
                        image: 'assets/images/food_item_1.jpg',
                      ),
                      FoodItem(
                        name: 'Food Item 2',
                        description: 'Description for Food Item 2',
                        image: 'assets/images/food_item_2.jpg',
                      ),
                      // Add more popular food items
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Charburgers',
                    foodList: [
                      FoodItem(
                        name: 'Food Item 3',
                        description: 'Description for Food Item 3',
                        image: 'assets/images/food_item_3.jpg',
                      ),
                      FoodItem(
                        name: 'Food Item 4',
                        description: 'Description for Food Item 4',
                        image: 'assets/images/food_item_4.jpg',
                      ),
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Signature Sandwiches',
                    foodList: [
                      FoodItem(
                        name: 'Food Item 5',
                        description: 'Description for Food Item 5',
                        image: 'assets/images/food_item_5.jpg',
                      ),
                      FoodItem(
                        name: 'Food Item 6',
                        description: 'Description for Food Item 6',
                        image: 'assets/images/food_item_6.jpg',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCategory extends StatelessWidget {
  final String categoryName;
  final List<FoodItem> foodList;

  FoodCategory({required this.categoryName, required this.foodList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          children: foodList.map((foodItem) {
            return FoodOption(foodItem: foodItem);
          }).toList(),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}

class FoodItem {
  final String name;
  final String description;
  final String image;

  FoodItem({required this.name, required this.description, required this.image});
}

class FoodOption extends StatelessWidget {
  final FoodItem foodItem;

  FoodOption({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              foodItem.image,
              fit: BoxFit.cover,
              height: 100.0,
            ),
          ),

          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    foodItem.description,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
