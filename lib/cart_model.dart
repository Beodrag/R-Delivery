import 'package:flutter/foundation.dart';
import 'food_item_models.dart';

class CartModel extends ChangeNotifier {
  final List<FoodItem> _items = [];

  List<FoodItem> get items => _items;

  double get totalPrice => _items.fold(0.0, (total, current) => total + current.getTotalPrice());

  void addItem(FoodItem item) {
    _items.add(item);

    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;
}
