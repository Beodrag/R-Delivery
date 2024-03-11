// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
<<<<<<< HEAD
import 'restaurant_list.dart';
=======

>>>>>>> f65a08f751c1463344e5d21f478c4ac8e464175a
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Robot Delivery',
      home: AddressSelectionPage(),
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
<<<<<<< HEAD
                    onPressed: () {
                      // Navigate to the restaurant list page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantList()),
                      );
                    },
=======
                    onPressed: () {},
>>>>>>> f65a08f751c1463344e5d21f478c4ac8e464175a
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
        ),
        body: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _initialCenter,
                zoom: 16.0,
                minZoom: 16.0,
<<<<<<< HEAD
                maxZoom: 18.0, // Set the maximum zoom level to 18
=======
                maxZoom: 18.0,
>>>>>>> f65a08f751c1463344e5d21f478c4ac8e464175a
                interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
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


