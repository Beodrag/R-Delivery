import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'food_item_models.dart';

class CartModel extends ChangeNotifier {
  final List<FoodItem> _items = [];

  String _userAddress = '';
  LatLng _userLocation = LatLng(0.0, 0.0);

  List<FoodItem> get items => _items;

  double get totalPrice => _items.fold(0.0, (total, current) => total + current.getTotalPrice());

  String get userAddress => _userAddress;

  LatLng get userLocation => _userLocation;

  void addItem(FoodItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateUserLocation(String address, LatLng location) {
    _userAddress = address;
    _userLocation = location;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;


  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
