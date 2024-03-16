import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'cart_page.dart';
import 'food_item_models.dart';
import 'cart_model.dart';

class PandaExpressDetail extends StatefulWidget {
  final Map<String, String> restaurant;

  PandaExpressDetail({required this.restaurant});

  @override
  _PandaExpressDetailState createState() => _PandaExpressDetailState();
}

class _PandaExpressDetailState extends State<PandaExpressDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AutoScrollController _scrollController = AutoScrollController();
  List<GlobalKey> _keys = List.generate(7, (index) => GlobalKey());
  Timer? _debounce;
  bool _tabChangeByScroll = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      int? closestIndex;
      double closestDistance = double.infinity;
      for (int i = 0; i < _keys.length; i++) {
        final keyContext = _keys[i].currentContext;
        if (keyContext != null) {
          final RenderBox box = keyContext.findRenderObject() as RenderBox;
          final Offset position = box.localToGlobal(Offset.zero);
          final double itemTop = position.dy;
          final double viewportTop = _scrollController.position.pixels;
          final double viewportBottom = viewportTop + _scrollController.position.viewportDimension;

          // Check if the item is in the viewport
          if (itemTop <= viewportBottom && (itemTop >= viewportTop || position.dy <= viewportBottom)) {
            final double distance = (viewportTop - itemTop).abs();
            if (distance < closestDistance) {
              closestDistance = distance;
              closestIndex = i;
            }
          }
        }
      }

      if (!_tabChangeByScroll && closestIndex != null && closestIndex != _tabController.index) {
        setState(() {
          _tabChangeByScroll = true;
          _tabController.animateTo(closestIndex!);
        });
      }
    });
  }




  void _handleTabSelection() {
    if (_tabController.indexIsChanging && !_tabChangeByScroll) {
      // User initiated tab change through direct interaction
      _scrollToIndex(_tabController.index);
    }
    // Always reset the flag after handling tab selection
    _tabChangeByScroll = false;
  }


  Future _scrollToIndex(int index) async {
    await _scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _tabController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panda Express'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'Bowl'),
              Tab(text: 'Plate'),
              Tab(text: 'Bigger Plate'),
              Tab(text: 'Family Meal'),
              Tab(text: 'Drinks'),
              Tab(text: 'Appetizers and More'),
            ],
          ).preferredSize,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'Bowl'),
                Tab(text: 'Plate'),
                Tab(text: 'Bigger Plate'),
                Tab(text: 'Family Meal'),
                Tab(text: 'Drinks'),
                Tab(text: 'Appetizers and More'),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          AutoScrollTag(
            key: _keys[0],
            controller: _scrollController,
            index: 0,
            child: FoodCategory(
              key: _keys[0],
              categoryName: 'Bowl',
              isFirstCategory: true,
              foodList: [
                FoodItem(
                  name: 'Bowl',
                  description: 'Any 1 Side & 1 Entree',
                  image: 'assets/images/panda/bowl.webp',
                  price: 8.40,
                  requiredOptions: [
                    RequiredOption(
                        name: "Step 1",
                        options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                    ),
                    RequiredOption(
                      name: "Step 2",
                      options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                        "Honey Walnut Shrimp", "Grilled Teriyaki Chicken"],
                      optionPrices: {
                        "Firecracker Shrimp": 1.60,
                        "Black Pepper Angus Steak": 1.60,
                        "Honey Walnut Shrimp": 1.60,
                      },
                    ),
                  ],
                  extras: [],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[1],
            controller: _scrollController,
            index: 1,
            child: FoodCategory(
              key: _keys[1],
              categoryName: 'Plate',
              isFirstCategory: false,
              foodList: [
                FoodItem(
                  name: 'Plate',
                  description: 'Any 1 Side & 2 Entrees',
                  image: 'assets/images/panda/plate.jpg',
                  price: 9.90,
                  requiredOptions: [
                    RequiredOption(
                        name: "Step 1",
                        options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                    ),
                    RequiredOption(
                      name: "Step 2",
                      options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                        "Honey Walnut Shrimp", "Grilled Teriyaki Chicken"],
                      optionPrices: {
                        "Firecracker Shrimp": 1.60,
                        "Black Pepper Angus Steak": 1.60,
                        "Honey Walnut Shrimp": 1.60,
                      },
                    ),
                  ],
                  extras: [],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[2],
            controller: _scrollController,
            index: 2,
            child: FoodCategory(
              key: _keys[2],
              categoryName: 'Bigger Plate',
              isFirstCategory: false,
              foodList: [
                FoodItem(
                  name: 'Bigger Plate',
                  description: 'Any 1 Side & 2 Entrees',
                  image: 'assets/images/panda/bigger.jpg',
                  price: 11.40,
                  requiredOptions: [
                    RequiredOption(
                        name: "Step 1",
                        options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                    ),
                    RequiredOption(
                      name: "Step 2",
                      options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                        "Honey Walnut Shrimp", "Grilled Teriyaki Chicken"],
                      optionPrices: {
                        "Firecracker Shrimp": 1.60,
                        "Black Pepper Angus Steak": 1.60,
                        "Honey Walnut Shrimp": 1.60,
                      },
                    ),
                  ],
                  extras: [],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[3],
            controller: _scrollController,
            index: 3,
            child: FoodCategory(
              key: _keys[3],
              categoryName: 'Family Meal',
              isFirstCategory: false,
              foodList: [
                FoodItem(
                  name: 'Family Meal',
                  description: '2 Large Sides & 3 Entrees',
                  image: 'assets/images/panda/family.jpg',
                  price: 43.00,
                  requiredOptions: [
                    RequiredOption(
                        name: "Step 1",
                        options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                    ),
                    RequiredOption(
                      name: "Step 2",
                      options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                        "Honey Walnut Shrimp", "Grilled Teriyaki Chicken"],
                      optionPrices: {
                        "Firecracker Shrimp": 1.60,
                        "Black Pepper Angus Steak": 1.60,
                        "Honey Walnut Shrimp": 1.60,
                      },
                    ),
                  ],
                  extras: [],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[4],
            controller: _scrollController,
            index: 4,
            child: FoodCategory(
              key: _keys[4],
              categoryName: 'Drinks',
              isFirstCategory: false,
              foodList: [
                FoodItem(
                  name: 'Drinks',
                  description: 'Add a refreshing beverage',
                  image: 'assets/images/panda/drinks2.jpg',
                  price: 0.00,
                  requiredOptions: [
                    RequiredOption(
                      name: "Drinks",
                      options: ["Regular Drink", "Large Drink"],
                      optionPrices: {
                        "Regular Drink": 1.50,
                        "Large Drink": 2.00,
                      },
                    ),
                  ],
                  extras: [],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[5],
            controller: _scrollController,
            index: 5,
            child: FoodCategory(
              key: _keys[5],
              categoryName: 'Appetizers and More',
              isFirstCategory: false,
              foodList: [
                FoodItem(
                  name: 'Appetizers and More',
                  description: 'Extras',
                  image: 'assets/images/panda/app.jpg',
                  price: 0.00,
                  requiredOptions: [
                    RequiredOption(
                      name: "Extras",
                      options: ["Chicken Egg Roll - Small (1)", "Chicken Egg Roll - Large (6)" "Veggie Spring Roll - Small (2)", "Veggie Spring Roll - Large (12)", "Cream Cheese Rangoon (3)",
                        "Hot and Sour Soup"],
                      optionPrices: {
                        "Chicken Egg Roll - Small (1)": 2.00,
                        "Chicken Egg Roll - Large (6)": 11.20,
                        "Veggie Spring Roll - Small (2)": 2.00,
                        "Veggie Spring Roll - Large (12)": 11.20,
                        "Cream Cheese Rangoon (3)": 2.00,
                        "Hot and Sour Soup": 1.50,
                      },
                    ),
                  ],
                  extras: [],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
              },
              child: Text('Go to Cart'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Restaurant List'),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodCategory extends StatelessWidget {
  final GlobalKey key;
  final String categoryName;
  final List<FoodItem> foodList;
  final bool isFirstCategory;

  FoodCategory({required this.key, required this.categoryName, required this.foodList, this.isFirstCategory = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // If this is the first category, display the image and restaurant name
        if (isFirstCategory) ...[
          Image.asset(
            'assets/images/panda_express.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'Panda Express',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],

        // Category title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            categoryName,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),

        // Food items in this category
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


class FoodOption extends StatelessWidget {
  final FoodItem foodItem;

  FoodOption({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCustomizationOptions(context, foodItem),
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Display the food image on the left
            Expanded(
              flex: 2,
              child: Image.asset(
                foodItem.image,
                fit: BoxFit.contain,
                height: 100.0, // You can adjust the height of the food image
              ),
            ),
            // Display the food name and description on the right
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
                    SizedBox(height: 8.0),
                    Text(
                      "\$${foodItem.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomizationOptions(BuildContext context, FoodItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWithExtras(
          foodItem: item,
          onAddToCart: (FoodItem addedItem, Map<String, String?> selectedOptions, Map<String, bool> extras) {
            double totalPrice = addedItem.price;

            // Calculate additional costs for required options
            addedItem.requiredOptions.forEach((option) {
              String? selectedOption = selectedOptions[option.name];
              double? additionalCost = option.optionPrices[selectedOption];
              if (additionalCost != null) {
                totalPrice += additionalCost;
              }
            });

            // Add the price of selected extras
            addedItem.extras.forEach((extra) {
              if (extras[extra.name] == true) {
                totalPrice += extra.price ?? 0.0;
              }
            });

            // Update the price of the item
            addedItem.price = totalPrice;

            Provider.of<CartModel>(context, listen: false).addItem(addedItem);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}


class DialogWithExtras extends StatefulWidget {
  final FoodItem foodItem;
  final Function(FoodItem, Map<String, String?>, Map<String, bool>) onAddToCart;

  DialogWithExtras({Key? key, required this.foodItem, required this.onAddToCart}) : super(key: key);

  @override
  _DialogWithExtrasState createState() => _DialogWithExtrasState();
}


class _DialogWithExtrasState extends State<DialogWithExtras> {
  late double totalPrice;
  Map<String, bool> extrasSelected = {};
  Map<String, String?> selectedRequiredOptions = {};
  Map<String, bool> showError = {};

  @override
  void initState() {
    super.initState();
    initializeSelections();
  }

  void initializeSelections() {
    totalPrice = widget.foodItem.price;
    widget.foodItem.extras.forEach((extra) {
      extrasSelected[extra.name] = false;
    });
    widget.foodItem.requiredOptions.forEach((option) {
      selectedRequiredOptions[option.name] = "(Choose an option)";
      showError[option.name] = false;
    });
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    double tempTotal = widget.foodItem.price;
    widget.foodItem.extras.forEach((extra) {
      if (extrasSelected[extra.name] == true) {
        tempTotal += extra.price ?? 0.0;
      }
    });

    widget.foodItem.requiredOptions.forEach((option) {
      String? selectedOption = selectedRequiredOptions[option.name];
      double? additionalCost = option.optionPrices[selectedOption];
      if (additionalCost != null) {
        tempTotal += additionalCost;
      }
    });

    setState(() {
      totalPrice = tempTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Customize Your Order"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...buildRequiredOptions(),
            ...buildExtrasOptions(),
          ],
        ),
      ),
      actions: <Widget>[
        Text("Total: \$${totalPrice.toStringAsFixed(2)}"),
        ElevatedButton(
          onPressed: () {
            if (validateRequiredOptions()) {
              // Update the item with the selected options and extras
              widget.foodItem.selectedRequiredOptions = selectedRequiredOptions;
              widget.foodItem.selectedExtras = extrasSelected;
              Provider.of<CartModel>(context, listen: false).addItem(widget.foodItem.clone());
              Navigator.of(context).pop(); // Close the dialog
            } else {
              // Handle the case where not all required options are selected
              print('Validation failed, item not added to cart');
            }
          },

          child: Text('Add to Cart'),
        ),

        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  List<Widget> buildRequiredOptions() {
    return widget.foodItem.requiredOptions.map((requiredOption) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showError[requiredOption.name] == true)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                "Please select an option",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: requiredOption.name),
            value: selectedRequiredOptions[requiredOption.name],
            onChanged: (String? newValue) {
              setState(() {
                selectedRequiredOptions[requiredOption.name] = newValue;
                showError[requiredOption.name] = newValue == "(Choose an option)";
                calculateTotalPrice();
              });
            },
            items: [DropdownMenuItem<String>(value: "(Choose an option)", child: Text("(Choose an option)"))]
              ..addAll(requiredOption.options.map((option) {
                double? price = requiredOption.optionPrices[option];
                String optionText = price != null && price > 0 ? "$option (+\$${price.toStringAsFixed(2)})" : option;
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(optionText),
                );
              })),
          ),
          SizedBox(height: 10),
        ],
      );
    }).toList();
  }

  List<Widget> buildExtrasOptions() {
    return widget.foodItem.extras.isNotEmpty ? [
      SizedBox(height: widget.foodItem.requiredOptions.isNotEmpty ? 16.0 : 0.0),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Extras",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ...widget.foodItem.extras.map((extra) {
        return CheckboxListTile(
          title: Text("${extra.name} (\$${extra.price?.toStringAsFixed(2)})"),
          value: extrasSelected[extra.name],
          onChanged: (bool? value) {
            setState(() {
              extrasSelected[extra.name] = value!;
              calculateTotalPrice();
            });
          },
        );
      }).toList(),
    ] : [];
  }

  bool validateRequiredOptions() {
    bool allValid = true;
    setState(() {
      for (var option in widget.foodItem.requiredOptions) {
        if (selectedRequiredOptions[option.name] == "(Choose an option)") {
          showError[option.name] = true;
          allValid = false;
        } else {
          showError[option.name] = false;
        }
      }
    });
    return allValid;
  }
}