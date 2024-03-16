import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'food_item_models.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'restaurant_list.dart'; // Ensure this is imported correctly

class CheckoutPage extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String userAddress;
  final List<FoodItem> items;
  final LatLng userLocation;

  CheckoutPage({
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.items,
    required this.userLocation,
  });

  Future<void> saveOrderToDatabase() async {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Construct the order data
    final orderData = {
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'userLocation': {
        'latitude': userLocation.latitude,
        'longitude': userLocation.longitude,
      },
      'items': items.map((item) {
        return {
          'name': item.name,
          'totalPrice': item.getTotalPrice(),
          'requiredOptions': item.selectedRequiredOptions,
          'extraOptions': item.selectedExtras.entries
              .where((extra) => extra.value)
              .map((extra) => extra.key)
              .toList(),
        };
      }).toList(),
    };

    // Push the order data to Firebase Realtime Database
    await databaseReference.child('orders').push().set(orderData);
  }

  @override
  Widget build(BuildContext context) {
    double totalOrderPrice = items.fold(0, (total, current) => total + current.getTotalPrice());

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmed'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Details:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Name: $userName'),
                  Text('Address: $userAddress'),
                  Text('Phone: $userPhone'),
                  Divider(),
                  Text('Food Items:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ...items.map((item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.name} - \$${item.getTotalPrice().toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...item.selectedRequiredOptions.entries.map((e) => Text("${e.key} - ${e.value}")),
                        if (item.selectedExtras.isNotEmpty)
                          ...item.selectedExtras.entries.where((e) => e.value).map((e) => Text("${e.key}")),
                        SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                  Divider(),
                  Text('Total Order Price: \$${totalOrderPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: userLocation,
                zoom: 16.0,
                interactiveFlags: InteractiveFlag.none,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userLocation,
                      child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await saveOrderToDatabase();
                // After saving the data, navigate back to the RestaurantList
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantList()),
                  ModalRoute.withName('/'),
                );
              },
              child: Text('Place Order', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
