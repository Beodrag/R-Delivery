// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'cart_model.dart';
import 'restaurant_list.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widget binding is initialized
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAmNx-ZIbRwikaR2J2AW5f5S-uB1Ax94pY",
        authDomain: "r-delivery-1e16f.firebaseapp.com",
        databaseURL: "https://r-delivery-1e16f-default-rtdb.firebaseio.com",
        projectId: "r-delivery-1e16f",
        storageBucket: "r-delivery-1e16f.appspot.com",
        messagingSenderId: "768251260161",
        appId: "1:768251260161:web:d7f01ddc12b37c59e0ff00"
    ),
  ); // Initialize Firebase before the app starts
  runApp(MyApp()); // Run the app
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        title: 'Food Robot Delivery',
        home: AddressSelectionPage(),
      ),
    );
  }
}

class AddressSelectionPage extends StatefulWidget {
  @override
  _AddressSelectionPageState createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  final LatLng _initialCenter = LatLng(33.9763, -117.3247);
  MapController _mapController = MapController();

  Future<String> _getAddress(LatLng location) async {
    final endpoint = 'nominatim.openstreetmap.org';
    final path = '/reverse';
    final params = {
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString(),
      'format': 'json',
    };

    final uri = Uri.https(endpoint, path, params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'] ?? 'Unknown location';
    } else {
      return 'Error fetching address';
    }
  }

  void _confirmAddress() async {
    LatLng center = _mapController.center;
    String address = await _getAddress(center);

    Provider.of<CartModel>(context, listen: false).updateUserLocation(address, center);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Confirm Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(address, textAlign: TextAlign.center),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantList()),
                      );
                    },
                    child: Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Delivery Location'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: 16.0,
                minZoom: 16.0,
                maxZoom: 18.0,
                interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                // Add other layers or widgets here
              ],
            ),
            Center(
              child: Icon(Icons.location_pin, color: Colors.red, size: 40.0),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _confirmAddress,
                child: Text('Confirm Address'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
